#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# Copyright (c) 2017  Thilo Fischer.
#
# This file is part of super-hid.
#
# super-hid is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# super-hid is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with super-hid.  If not, see <http://www.gnu.org/licenses/>.

# Parse .xkb from stdin or from file given as command line argument
# and create KeyboardLayout class from is. Write YAML representation
# of KeyboardLayout to stdout.
#
# You can generate .xkb files and pipe into this program like
#  setxkbmap LAYOUT [VARIANT] -print | xkbcomp -xkb - - | xkb-to-yaml.rb > [OUTPUT]
# e.g.
#  setxkbmap us            -print | xkbcomp -xkb - - | xkb-to-yaml.rb > us.yaml
#  setxkbmap us dvorak     -print | xkbcomp -xkb - - | xkb-to-yaml.rb > us_dvorak.yaml
#  setxkbmap de            -print | xkbcomp -xkb - - | xkb-to-yaml.rb > de.yaml
#  setxkbmap de nodeadkeys -print | xkbcomp -xkb - - | xkb-to-yaml.rb > de_nodeadkeys.yaml
#  setxkbmap de neo        -print | xkbcomp -xkb - - | xkb-to-yaml.rb > de_neo.yaml
#
# This is a rather quick and dirty implementation that just does the
# job concerning those aspects I consider necessary for my current use
# case. If you feel something is wrong or missing: Feel free to fix
# and enhance ;)

require 'yaml'

module SuperHid; end

require_relative 'keyboard_layout'

module States

  # forward declarations (sort of)

  class Base; end
  class Initial < Base; end
  class Keymap < Base; end
  class Keycodes < Base; end
  class Types < Base; end
  class SpecificType < Base; end
  class Symbols < Base; end
  class SymbolKey < Base; end
  class Ignore < Base; end
  
  class Base
    def initialize(parent)
      @parent = parent
    end
    def process(line, ctx)
      case line
      when "};"
        return @parent
      when ""
        nil # silently ignore
      else
        warn "ignore unsupported line: `#{line.chomp}' (current state #{self.class.name})"
      end
      self
    end
  end

  class Initial < Base
    def process(line, ctx)
      case line
      when /^xkb_keymap {$/
        return Keymap.new(self)
      else
        return super
      end
    end # def process
  end # state class

  class Keymap < Base
    def process(line, ctx)
      case line
      when /^xkb_keycodes "evdev.*" {$/
        return Keycodes.new(self)
      when /^xkb_types ".*" {$/
        return Types.new(self)
      when /^xkb_symbols ".*" {$/
        return Symbols.new(self)
      when /^xkb_compatibility ".*" {$/, /^xkb_geometry ".*" {$/
        return Ignore.new(self)
      else
        return super
      end
      self
    end # def process
  end # state class

  class Keycodes < Base
    def process(line, ctx)
      case line
      when /^minimum = (\d+);$/
        ctx[:keycode_minimum] = $1.to_i
      when /^maximum = (\d+);$/
        ctx[:keycode_maximum] = $1.to_i
      when /^<([\w+\-]+)> = (\d+);$/
        ctx[:keycode_names][$1] = $2.to_i
      when /^(virtual )?indicator \d+ = .*;$/
        nil # silently ignore
      when /^alias <([\w+\-]+)> = <([\w+\-]+)>;$/
        ctx[:keycode_aliases][$1] = $2
      else
        return super
      end
      self
    end # def process
  end # state class

  class Types < Base
    def process(line, ctx)
      case line
      when /^virtual_modifiers .*;$/
        nil # ignore
      when /^type "([\w+\-]+)" {$/
        return SpecificType.new(self, $1)
      else
        return super
      end
      self
    end # def process
  end # state class

  class SpecificType < Base
    def initialize(parent, name)
      super(parent)
      @name = name
      @mod_to_level = {}
    end
    def process(line, ctx)
      case line
      when /^modifiers= .*;$/, /^level_name\[.*\]= .*;$/
        nil # ignore
      when /^map\[([\w+\-]+)\]= ([\w+\-]+);$/
        modifiers = $1.split("+")
        level_id = $2.sub("Level", "").to_i
        @mod_to_level[modifiers] = level_id
      when "};"
        ctx[:kbl].types[@name] = @mod_to_level
        return @parent
      else
        return super
      end
      self
    end # def process
  end # state class

  class Symbols < Base
    def process(line, ctx)
      case line
      when /^name\[group1\]="(.*)";$/
        #ctx[:name] = $1
        ctx[:kbl].name = $1
      when /^name[group\d+]=.*$/
        # ignore everything (for now)
        nil
      when /^key\s+<([\w+\-]+)>\s+{(.*)};$/
        keycode = $1
        symbols = $2.strip
        symbols =~ /^\[(.*)\]$/
        symbols = $1.strip.split(/\s*,\s*/)
        ctx[:kbl].keys[keycode] = SuperHid::Processing::Key.new(nil, symbols)
        # FIXME duplicated code (SymbolKey#process -> "};")
        # FIXME add to ctx[:kbl].symbols
      when /^key <([\w+\-]+)> {$/
        return SymbolKey.new(self, $1)
      else
        return super
      end
      self
    end # def process
  end # state class

  class SymbolKey < Base
    def initialize(parent, keycode)
      super(parent)
      @keycode = keycode
    end
    def process(line, ctx)
      case line
      when /^type= "([\w+\-]+)",?$/
        raise unless ctx[:kbl].types.key?($1)
        @type = ctx[:kbl].types[$1]
      when /^symbols\[Group1\]= \[(.*)\],?$/
        @symbols = $1.strip.split(/\s,\s/)
      when "};"
        ctx[:kbl].keys[@keycode] = SuperHid::Processing::Key.new(@type, @symbols)
        @symbols.each_with_index do |s, idx|
          level = idx + 1
          ctx[:kbl].symbols[s] ||= []
          ctx[:kbl].symbols[s].push( [s, level] )
        end
        return @parent
      else
        return super
      end
      self
    end # def process
  end # state class

  class Ignore < Base
    def process(line, ctx)
      case line
      when /^.*{$/
        return Ignore.new(self)
      when /^};$/
        return super
      when /^.*$/
        # ignore everything (for now)
        nil
      else
        return super
      end
      self
    end # def process
  end # state class

end # module States

state = States::Initial.new(nil)
context = {
  :kbl => SuperHid::Processing::KeyboardLayout.new,
  :keycode_names => {},
  :keycode_aliases => {},
}

ARGF.each_line do |l|
  #warn("DBG #{state.class.name} : `#{l.chomp}'")
  state = state.process(l.strip, context)
end

puts context[:kbl].to_yaml

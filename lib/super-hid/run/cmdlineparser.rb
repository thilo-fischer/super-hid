# -*- coding: utf-8 -*-

# Copyright (c) 2016  Thilo Fischer.
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

require 'optparse'

require 'super-hid/processing/operations'
require 'super-hid/processing/event_filters'

##
# Start an instance of the super-hid program
module SuperHid::Run

  ##
  # Parses the command line arguments passed to the super-hid program at invocation
  class CommandLineParser

    attr_reader :devices, :options

    def initialize
      @operations = []
      @options = {}
    end


    def parse

      config_files = []
      all_sources = []
      operations = []

      current_sources = []
      current_conditions = []

      state = :then
      
      option_parser = OptionParser.new do |opts|
        
        opts.banner =
          "Usage: #{File.basename $0} ( ( --config <config-file> ... ) | ( [ --from <source> ... ] [ --when <condition> ... ] --then <operation> ... [ [ --else ] [ --when <condition> ... ] --then <operation> ... ] ) ) ..."
        
	opts.on("--config",
                "Read configuration parameters and operation rules from the following config files.") do
          state = :config
        end
        
	opts.on("--from",
                "Track input and other events from the following input device files and other other sources.") do
          state = :from
        end

	opts.on("--when",
                "Apply operations only on those events that match at least one of the following conditions.") do
          if state == :else
            raise "TODO"
          end
          state = :when
        end

	opts.on("--then",
                "Apply the following operations.") do
          state = :then
        end

	opts.on("--else",
                "When given before an operation: Apply the following operation(s) only if the previous operation did not succeed. When given before an `--when' option: Test following conditions and (possibly) apply following operations only if none of the conditions on the previous `--when' option matched or if previous operation did not succeed.") do
          state = :else
        end

        opts.separator ""

        opts.separator "Supported sources:"
        opts.separator "dev:foo        -> device /dev/input/by-path/foo"
        opts.separator "dev:*foo*      -> all devices maching /dev/input/by-path/*foo*"
        opts.separator "dev            -> all devices in /dev/input/by-path/"
        opts.separator "/dev/input/foo -> device /dev/input/foo"
        opts.separator "dev_kind:(kbd|mouse|game) -> all keyboards/mice/game controllers found in /dev/input/by-path/"
        opts.separator "timer:NN(s|m|h)[:once] -> virtual source that provides an event after the given number of seconds, minutes or hours, cyclically or if `:once' is given just once."
        opts.separator "..."

        opts.separator ""

        opts.separator "Supported conditions for dev sources:"
        opts.separator "dev:<type>[:<code>[:<value>]] -> matches events from /dev/input sources with appropriate type, code and value. <type> is the name of a specific event type according to https://www.kernel.org/doc/Documentation/input/event-codes.txt, a (Ruby) regular expression matching such names or a comma-separated list of these. <code> may be the name of a specific event code according to +include/linux/input.h+, a (Ruby) regular expression matching such names, an integer value, a range between integer values and/or code names or a comma-separated list of these. <value> may be an integer values, a range between integer values or a comma-separated list of these. Ranges for <code> and <value> can be specified as '64..127' or '64...128' according to the Ruby range syntax. Option may be given multiple times, and events must match at least one (not all) filters to apply operations."

        #  types, codes, values = arg.split(':')
        #  types = types.split(',').map do |arg|
        #    arg.strip!
        #    case arg
        #    when /^\w+$/
        #      arg
        #    when /^\/.*\/$/
        #      Regexp.new(arg)
        #    else
        #      raise "invalid event type specifier: `#{arg}'"
        #    end
        #  end
        #  codes = codes.split(',').map do |arg|
        #    arg.strip!
        #    case arg
        #    when /^\w+$/
        #      arg
        #    when /^\/.*\/$/
        #      Regexp.new(arg)
        #    when /^(0x)?\d$/
        #      base = $1 ? 16 : 10
        #      arg.to_i(base)
        #    when /^(\w+|(0x)?\d)(\.\.\.?)(\w+|(0x)?\d)$/
        #      raise "TODO: event code range from symbol or integer to symbol or integer"
        #    else
        #      raise "invalid event code specifier: `#{arg}'"
        #    end
        #  end if codes
        #  values = values.split(',').map do |arg|
        #    arg.strip!
        #    case arg
        #    when /^(0x)?\d$/
        #      base = $1 ? 16 : 10
        #      arg.to_i(base)
        #    when /^((0x)?\d)(\.\.\.?)((0x)?\d)$/
        #      raise "TODO: event value range"
        #    else
        #      raise "invalid event code specifier: `#{arg}'"
        #    end
        #  end if values
        #  filters << EventFilterStandard.new(types, codes, values)
        #end

        opts.separator ""
        opts.separator "Supported Operations:"

        opts.separator("nop         -> No-operation: Don't do anything, is always successful.")
        opts.separator("log[:verbose] -> Print information about the event to stdout or log file; print greater amount of information if `:verbose' is given.")
        opts.separator("generate:<output> -> Simulate events specified by <output>.")
        opts.separator("forward     -> Forward events. (Useful to set up filters that drop certain events.)")
        opts.separator("kbd-layout-translate:FROM:TO -> Interpret input from connected keyboards according to X11 kbd layout given as FROM and send keys to target system according to X11 kbd layout given as TO.")

        opts.separator ""
        
        opts.separator "Common options:"

        opts.on_tail("-h", "--help", "Prints this help") do
          puts opts
          exit
        end

        opts.on_tail("--version", "Show version") do
          puts SuperHid::VERSION
          exit
        end

      end # OptionParser.new

      option_parser.order(ARGV) do |arg|
        case state
        when :config
          config_files << arg # XXX parse config file
        when :from
          src = Source.create(arg)
          all_sources << src unless all_sources.include?(src)
          current_sources << src
        when :when
          current_conditions << Condition.create(arg)
        when :then
          operations << Operation.create(arg, current_sources, current_conditions)
        when :else
          raise "TODO"
        else
          raise "invalid command line syntax. unexpected: `#{arg}'"
        end
      end

    end # def parse
    
  end # class CommandLineParser

end # module SuperHid::Run

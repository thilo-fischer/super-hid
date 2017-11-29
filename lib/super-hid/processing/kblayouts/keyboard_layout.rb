# -*- coding: utf-8 -*-

# Copyright (c) 2017 Thilo Fischer.
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

module SuperHid::Processing

  class KeyboardLayout

    #attr_accessor :name, :level_modifiers, :keycode_to_symbols, :symbol_generation
    #
    #def initialize(name = "")
    #  @name = name
    #  @level_modifiers = {}
    #  @keycode_to_symbols = {}
    #  @symbol_generation = {}
    #end
    
    attr_accessor :name, :types, :keys, :symbols

    def initialize(name = "")
      @name = name
      @types = {}
      @keys = {}
      @symbols = {}
    end

  end # class KeyboardLayout

  class Key
    attr_accessor :type, :symbols
    def initialize(type = nil, symbols = nil)
      @type = type
      @symbols = symbols
    end
  end

  class Type
    attr_accessor :name, :modifiers
    def initialize(name = nil, modifiers = nil)
      @name = name
      @modifiers = modifiers
    end
  end
    

end # module SuperHid::Processing

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

require 'super-hid/processing/event'

module SuperHid::Processing

  ##
  # Internal representation of events received from sources
  class EvKeyboard < Event
    attr_reader :key
    def initialize(key, source, raw_data = nil)
      super(source, raw_data)
      @key = key
    end
    def complete?
      return true
    end
  end # class EvKeyboard
  
  ##
  # Internal representation of events received from sources
  class EvKeyPress < EvKeyboard
    def to_s
      "keyboard press #{@key}"
    end
  end # class EvKeyboard
  
  ##
  # Internal representation of events received from sources
  class EvKeyRelease < EvKeyboard
    def to_s
      "keyboard release #{@key}"
    end
  end # class EvKeyboard
  
end #module SuperHid::Processing

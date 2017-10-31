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

raise "deprecated"

require 'super-hid/processing/event_filter'

module SuperHid::Processing

  class EventFilterStandard < EventFilter

    def initialize(types, codes, values)
      @types, @codes, @values = types, codes, values
    end

    ##
    # Return true if filter applies to event.
    def apply?(event)
      @types.find {|t| match_type?(t, event.type) } and
      (@codes == nil or @codes.empty? or @codes.find {|c| match_code?(c, event.code) }) and
      (@values == nil or @values.empty? or @values.find {|v| match_value?(v, event.value) })
    end
    
    private

    ##
    # Return true if +type+ passes the test specified by +test+.
    def match_type?(test, type)
      case test
      when String
        type.to_s == test.upcase
      when Regexp
        type.to_s.match?(test)
      else
        raise "invalid argument"
      end
    end
    
    def match_code?(test, code)
      case test
      when String
        code.to_s == test.upcase
      when Regexp
        code.to_s.match?(test)
      when Integer
        DevInput.Constants.value(code) == test
      when Range
        test.include?(DevInput.Constants.value(code))
      else
        raise "invalid argument"
      end
    end
    
    def match_value?(test, value)
      case test
      when Integer
        value == test
      when Range
        test.include?(value)
      else
        raise "invalid argument"
      end
    end
    
  end # class EventFilterStandard

end # module SuperHid::Processing

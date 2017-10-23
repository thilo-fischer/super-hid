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

module SuperHid::Processing

  class Operation

    attr_accessor :final

    def initialize(devices, event_filters, final = false)
      @devices = devices
      @event_filters = event_filters
      @final = final
    end

    ##
    # Test if operation applies to event. If so, process event.
    # Returns true if no further operations shall process the event.
    def check(event)
      if apply?(event)
        process(event) and @final
      else
        false
      end
    end

    ##
    # Return true is operation applies to event, i.e. event's source device is in the list of devices the operations applies to and event matches the operations event filter.
    def apply?(event)
      (devices == nil or devices.empty? or devices.find {|d| File.identical?(event.source, d) }) and
        (event_filters == nil or event_filters == empty? or event_filters.find {|f| f.apply?(event) })
    end

    ##
    # Do what's the purpose of this operation is with the given event.
    # To be overridden by derived classes.
    # Return true if event was processed successfully.
    # This class' method implementation does nothing, i.e. Operation base class impelemts the nop (*no*-*op*eration) operation.
    def process(event)
      true
    end
    
  end # class Operation

end # module SuperHid::Processing

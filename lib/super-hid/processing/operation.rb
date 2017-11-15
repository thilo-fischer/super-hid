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

  class Operation

    #def initialize(sources, conditions)
    #  @sources = sources
    #  @conditions = conditions
    #end
    attr_accessor :sources, :conditions

    ##
    # Test if operation applies to event. If so, process event.
    # Returns true if event processed successfully
    def check(event)
      if apply?(event)
        process(event)
      else
        false
      end
    end

    ##
    # Return true is operation applies to event, i.e. event's source device is in the list of devices the operations applies to and event matches the operations event filter.
    def apply?(event)
      (
        @sources == nil or
        @sources.empty? or
        #@sources.find {|src| File.identical?(event.source.path, src.path) }
        #@sources.find {|src| event.source == src }
        @sources.find {|src| event.source.equal?(src) }
      ) and (
        @conditions == nil or
        @conditions.empty? or
        @conditions.find {|cond| cond.apply?(event) }
      )
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

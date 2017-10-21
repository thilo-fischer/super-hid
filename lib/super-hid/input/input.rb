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

require 'super-hid/log/logging'

module SuperHid::Input

  ##
  # Read linux's /dev/input/* device files.
  # See also /usr/include/linux/input.h.
  class DevInput

    ##
    # Container for the data read from /dev/input/* device files.
    class Event
      attr_reader :time, :type, :code, :value
      def initialize(time, type, code, value)
        @time = time
        @type = type
        @code = code
        @value = value
      end # def initialize
    end # class Event
    
    # FIXME padding? (platform specific to align with 32 or 64 bit?)
    SIZEOF_TIMEVAL = 16 # FIXME platform specific
    SIZEOF_INT16 = 2
    SIZEOF_INT32 = 4
    SIZEOF_INPUT_EVENT = SIZEOF_TIMEVAL + SIZEOF_INT16 + SIZEOF_INT16 + SIZEOF_INT32
    INPUT_EVENT_UNPACK_FMTSTR = '@#{SIZEOF_TIMEVAL}SSl'
    
    def initialize(devices)
      @devices = devices.map |dev| do
        case dev
        when String
          File.open(dev)
        when IO
          dev
        else
          raise
        end
      end
      
      $logger.debug("Input devices to track: #{@devices.inspect}")
    end # def initialize
    
    ##
    # Wait for devices to return an input_event.
    # Returns an array of all input_events read from the tracked device files (converted to DevInput.Event objects).
    def get_events
      sel = IO.select(@devices)

      $logger.debug("input events available at #{sel.inspect}")

      events = sel.map |dev| do
        binary = dev.sysread(SIZEOF_INPUT_EVENT)
        type, code, value = binary.unpack(INPUT_EVENT_UNPACK_FMTSTR)
        ev = Event.new(0, type, code, value) # XXX time
        $logger.debug("from #{dev.inspect}: #{binary.unpack("H*")} => #{ev.inspect}")
      end

      events
    end # def get_events
    
  end # class DevInput

end # module SuperHid::Input

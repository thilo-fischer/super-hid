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
require 'super-hid/input/dev_input_constants'

module SuperHid::Input

  ##
  # Read linux's /dev/input/* device files.
  # See also /usr/include/linux/input.h.
  class DevInput

    ##
    # Container for the data read from /dev/input/* device files.
    class Event
      attr_reader :source, :time, :type, :code, :value
      def initialize(source, time, type, code, value)
        @source = source
        @time = time
        @type = type.is_a?(Symbol) ? type : Constants::EVENT_TYPES[type]
        if code.is_a?(Symbol)
          @code = code
        else
          case @type
          when :EV_KEY
            @code = Constants::KEYS_AND_BTNS[code]
          else
            $logger.warn("Unknown input_event.code: #{code} for type #{@type}")
            @code = code
          end
        end
        @value = value
      end # def initialize
    end # class Event
    
    # FIXME padding? (platform specific to align with 32 or 64 bit?)
    SIZEOF_TIMEVAL = 16 # FIXME platform specific
    SIZEOF_INT16 = 2
    SIZEOF_INT32 = 4
    SIZEOF_INPUT_EVENT = SIZEOF_TIMEVAL + SIZEOF_INT16 + SIZEOF_INT16 + SIZEOF_INT32
    INPUT_EVENT_UNPACK_FMTSTR = "@#{SIZEOF_TIMEVAL}SSl"
    
    def initialize(devices)
      @devices = devices.map do |dev|
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
      sel_read = sel.first

      $logger.debug("input events available at #{sel_read.inspect}")

      events = sel_read.map do |dev|
        binary = dev.sysread(SIZEOF_INPUT_EVENT)
        type, code, value = binary.unpack(INPUT_EVENT_UNPACK_FMTSTR)
        ev = Event.new(dev, 0, type, code, value) # XXX time
        $logger.debug("from #{dev.inspect}: #{ev.inspect}")
      end

      events
    end # def get_events
    
  end # class DevInput

end # module SuperHid::Input

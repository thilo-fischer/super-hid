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

require 'super-hid/log/logging'
require 'super-hid/source/dev_input_constants'

require 'super-hid/processing/ev_keyboard'
require 'super-hid/processing/ev_mouse'

require 'super-hid/helper'

module SuperHid::Source

  ##
  # Read linux's /dev/input/* device files.
  # See also /usr/include/linux/input.h.
  class DevInput

    ##
    # Container for the data read from /dev/input/* device files.
    class Event
      KEY_VALUES = [ :release, :press, :repeat ]
      attr_reader :source, :time, :type, :code, :value
      def initialize(source, time, type, code, value)
        @source = source
        @time = time
        @type = type.is_a?(Symbol) ? type : Constants::EVENT_TYPES[type]
        @code = code
        @value = value
        
        unless code.is_a?(Symbol)
          case @type
          when :EV_SYN
            @code = code
          when :EV_KEY
            @code = Constants::KEYS_AND_BTNS[code]
            @value = KEY_VALUES[value]
          when :EV_REL
            @code = Constants::REL_AXES[code]
          when :EV_ABS
            @code = Constants::ABS_AXES[code]
          when :EV_SW
            @code = Constants::SWITCH_EV[code]
          when :EV_MSC
            @code = Constants::MISC_EV[code]
          else
            $logger.warn("Unknown input_event.code: #{code} for type #{@type}")
            @code = code
          end
        end
      end # def initialize
      def to_s
        "#{@type}:#{@code}:#{@value}"
      end
    end # class Event
    
    # FIXME sizeof(timeval) and padding bytes: platform specific
    # https://en.wikipedia.org/wiki/Data_structure_alignment
    SIZEOF_TIMEVAL = 16 # FIXME platform specific
    SIZEOF_INT16 = 2
    SIZEOF_INT32 = 4
    SIZEOF_INPUT_EVENT = SIZEOF_TIMEVAL + SIZEOF_INT16 + SIZEOF_INT16 + SIZEOF_INT32
    INPUT_EVENT_UNPACK_FMTSTR = "@#{SIZEOF_TIMEVAL}SSl"

    @@devices = {}

    @@ev_queue = []
    
    def initialize(path)
      @io = File.open(path)
      @@devices[@io] = self
    end # def initialize

    def self.get_events
      events = []
      while events.empty?
        raw = read_events
        @@ev_queue.concat(raw)
        events = aggregate_events if raw.find {|e| e.type == :EV_SYN}
      end
      events
    end
    
    private
    ##
    # Wait for devices to return an input_event.
    # Returns an array of all input_events read from the tracked device files (converted to DevInput.Event objects).
    def self.read_events
      sel = IO.select(@@devices.keys)
      sel_read = sel[0]

      #$logger.debug("input events available at #{sel_read.path}")
      #$logger.debug("input events available at #{sel_read.inspect}")

      events = []

      sel_read.each do |dev_io|
        count = 0
        begin
          while true
            binary = dev_io.read_nonblock(SIZEOF_INPUT_EVENT)
            byte_cnt = binary.length
            $logger.warn("unexpected input: #{byte_cnt} bytes") if byte_cnt != SIZEOF_INPUT_EVENT
            $logger.debug{"bytes %02d..%02d from %s: %s" % [ count, count + byte_cnt - 1, dev_io.path, SuperHid::Helper.hexdump(binary) ]}
            type, code, value = binary.unpack(INPUT_EVENT_UNPACK_FMTSTR)
            events << Event.new(@@devices[dev_io], 0, type, code, value) # XXX time
            count += byte_cnt
          end
        rescue SystemCallError
          # read_nonblock called and no data ready to be read
          $logger.warn "failed reading events from #{dev_io}" if count == 0
        end
      end

      $logger.debug{"#{events.length} new event(s): #{events.map{|e|e.to_s}.join(" ")}"}
      events
    end # def get_events

    def self.aggregate_events
      events = []

      # Enumerable.slice_after requires Ruby v2.2.0 or grater
      if Array.public_method_defined?(:slice_after)
        chunks = @@ev_queue.slice_after {|e| e.type == :EV_SYN }

        if chunks.last.last.type == :EV_SYN
          @@ev_queue = []
        else
          @@ev_queue = chunks.pop
        end
      else
        chunks = []
        syn_idx = @@ev_queue.index {|e| e.type == :EV_SYN }
        while syn_idx
          chunks << @@ev_queue.shift(syn_idx + 1)
          syn_idx = @@ev_queue.index {|e| e.type == :EV_SYN }
        end
      end

      chunks.each do |cnk|
        ev = nil
        cnk.each do |raw_ev|
          case raw_ev.type
          when :EV_SYN
            $logger.warn("Incomplete event: #{ev.inspect}") if ev and not ev.complete?
            raise unless raw_ev.equal?(cnk.last)
          when :EV_KEY
            next if raw_ev.value == :repeat
            case Constants.value(raw_ev.code)
            when Constants::CODERANGE_KEYBOARD_KEY
              raise if ev
              key = raw_ev.code
              $logger.warn("Unsupported key: #{raw_ev.code}") and next unless key and key.is_a?(Symbol)
              ev = SuperHid::Processing::EvKbdKey.new(key, raw_ev.value, raw_ev.source, cnk)
            when Constants::CODERANGE_MOUSE_BUTTON
              if ev == nil
                ev = SuperHid::Processing::EvMouse.new(raw_ev.source, cnk)
              else
                raise unless ev.is_a?(SuperHid::Processing::EvMouse)
              end
              # XXX quick and dirty
              ev.buttons ||= {}
              ev.buttons[raw_ev.code] = raw_ev.value
            else
              $logger.warn("unsupported event: #{raw_ev}")
            end
          when :EV_REL
            if ev == nil
              ev = SuperHid::Processing::EvMouse.new(raw_ev.source, cnk)
            else
              raise unless ev.is_a?(SuperHid::Processing::EvMouse)
            end
            case raw_ev.code
            when :REL_X
              ev.x = raw_ev.value
            when :REL_Y
              ev.y = raw_ev.value
            else
              $logger.warn("Unsupported event: #{raw_ev}")
            end
          else
            $logger.debug("Ignoring unsupported DevInput event #{raw_ev}")
          end
        end # cnk.each
        if ev
          events << ev
        else
          $logger.debug{"No event created from DevInput events #{cnk.map{|e|e.to_s}.join(" ")}"}
        end
      end # chunks.each
      
      events
    end
    
  end # class DevInput

end # module SuperHid::Source

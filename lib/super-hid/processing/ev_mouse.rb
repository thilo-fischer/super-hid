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
  # Base class for all mouse related events
  class EvMouse < Event
    attr_reader :buttons, :wheel
    def initialize(source, raw_data = nil)
      super(source, raw_data)
    end
    def x
      @x or 0
    end
    def x=(arg)
      raise if @x
      @x = arg
    end
    def y
      @y or 0
    end
    def y=(arg)
      raise if @y
      @y = arg
    end
    def complete?
      @x or @y or @buttons or @wheel
    end
    ##
    # add mouse movement information
    def move(x, y)
      @x = x
      @y = y
    end
    def move?
      @x or @y
    end
    ##
    # add button press or button release information
    # +id+:: identifies the button whose state changes
    # +action+:: +:press+ or +:release+
    def button(id, action)
      @buttons ||= {}
      raise if @buttons.key?(id)
      @buttons[id] = action
    end
    ##
    # add mouse wheel information
    def wheel=(arg)
      raise if @wheel
      @wheel = arg
    end
    def to_s
      s = "mouse "
      s += "(move x:#{x} y:#{y}) " if @x or @y
      s += "(buttons:#{@buttons}) " if @buttons
      s += "(wheel:#{@wheel}) " if @wheel
      s.chop!
      s
    end
  end # class EvMouse
  
end #module SuperHid::Processing

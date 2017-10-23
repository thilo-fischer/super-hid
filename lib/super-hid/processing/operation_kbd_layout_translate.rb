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

require 'super-hid/processing/operation'

module SuperHid::Processing

  class OperationKbdLayoutTranslate < Operation

    def initialize(devices, filters, from, to)
      super(devices, filters)
      raise "TODO"
      # parse /usr/share/X11/xkb/symbols/{from,to} and set up translation table
    end

    def process(event)
      raise "TODO"
      # find substitute event(s) to achive the effects of event at +from+ with substitute events at +to+
      send(substitue_events)
    end
    
  end # class OperationKbdLayoutTranslate

end # module SuperHid::Processing

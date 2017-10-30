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
require 'super-hid/processing/operation_log'
require 'super-hid/processing/operation_forward'
require 'super-hid/processing/operation_kbd_layout_translate'
require 'super-hid/processing/operation_quit'

module SuperHid::Processing

  module Operations

    def self.create(spec, sources, conditions)
      case spec
      when String
        case spec
        when "nop"
          Operation.new(sources, conditions)
        when /^log(:verbose)?$/
          OperationLog.new(sources, conditions, $1)
        when "forward"
          OperationForward.new(sources, conditions)
        when /^kbd-layout-translate:(.*):(.*)$/
          from_layout = $1
          to_layout = $2
          OperationKbdLayoutTranslate.new(sources, condition, from_layout, to_layout)
        when "QUIT"
          OperationQuit.new(sources, conditions)
        else
          raise "invalid operation spec: #{spec}"
        end
      else
        raise "unsupported operation spec: #{spec.inspect}"
      end
    end

  end # module Operations
end # module SuperHid::Processing

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

module SuperHid::Output

  class ProtocolHidApiCmds

    # Keep in sync with Arduino/hid-api-cmds/interface.h !!
    
    DEV_TYPES = {
      :DEV_INVALID    => 0x00,
      :DEV_KBD        => 0x01,
      :DEV_KBD_BOOT   => 0x02,
      :DEV_KBD_NKRO   => 0x03,
      :DEV_MOUSE      => 0x04,
      :DEV_MOUSE_BOOT => 0x05,
      :DEV_MOUSE_ABS  => 0x06,
      :DEV_GAMEPAD    => 0x07,
      :DEV_CONSUMER   => 0x08,
      :DEV_SYSTEM     => 0x09,
      :DEV_RAW_HID    => 0x1F      
    }
    
    OP_CODES = {
      :OP_KBD_INVALID   => 0,
      :OP_KBD_BEGIN     => 1,
      :OP_KBD_PRESS     => 2,
      :OP_KBD_RELEASE   => 3,
      :OP_KBD_REL_ALL   => 4,
      :OP_KBD_END       => 7,
      
      :OP_MOUSE_INVALID => 0,
      :OP_MOUSE_BEGIN   => 1,
      :OP_MOUSE_MOVE    => 2,
      :OP_MOUSE_PRESS   => 3,
      :OP_MOUSE_RELEASE => 4,
      :OP_MOUSE_WHEEL   => 5,
      :OP_MOUSE_END     => 7, 
    }
    
    PACK_FMT_STRS = {
      :OP_KBD_BEGIN   => "C",
      :OP_KBD_PRESS   => "CC",
      :OP_KBD_RELEASE => "CC",
      :OP_KBD_REL_ALL => "C",
      :OP_KBD_END     => "C",

      :OP_MOUSE_BEGIN   => "C",
      :OP_MOUSE_PRESS   => "CC",
      :OP_MOUSE_RELEASE => "CC",
      :OP_MOUSE_MOVE    => "CCC",
      :OP_MOUSE_WHEEL   => "CC",
      :OP_MOUSE_END     => "C",
    }

    def encode(event)
      
      param = []
      dev_type = nil
      op_code = nil
      
      case event
      when EvKeyboard
        dev_type = :DEV_KBD_BOOT
      when EvMouse
        dev_type = :DEV_MOUSE
      else
        raise "unsupproted event: #{event.inspect}"
      end
      case event
      when EvKeyPress
        op_code = :OP_KBD_PRESS
        param = [ event.hid_usage_id ]
      when EvKeyRelease
        op_code = :OP_KBD_RELEASE
        param = [ event.hid_usage_id ]
      else
        raise "unsupproted event: #{event.inspect}"
      end

      data = [ DEV_TYPES[dev_type] << 3 | OP_CODES[op_code] ]
      data.concat(params)
      data.pack(PACK_FMT_STRS[op_code])
      
    end # def encode
    
  end # class ProtocolHidApiCmds

end # module SuperHid::Output

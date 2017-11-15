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

require 'super-hid/output/interface_i2c'
require 'super-hid/output/protocol_hid-api-cmds'

module SuperHid::Output

  class Sender

    def initialize(interface, protocol, address)
      #@interface = interface
      #@protocol = protocol
      #@address = address
      setup(interface, protocol, address)
    end

    def setup(interface, protocol, address)
      case interface
      when :i2c
        @interface = InterfaceI2c.new(address)
      else
        raise
      end
      case protocol
      when :hid_api_cmds
        @protocol = ProtocolHidApiCmds.new
      else
        raise
      end
    end
    
    def send(event)
      @interface.send(@protocol.encode(event))
    end
    
  end # class Sender

end # module SuperHid::Output

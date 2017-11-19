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

    @@pool = {}

    def self.acquire(interface, protocol, address)
      find_instance(interface, protocol, address) or self.new(interface, protocol, address)
    end

    def self.find_instance(interface, protocol, address)
      if @@pool.key?(interface) and
         @@pool[interface].key?(protocol) and
         @@pool[interface][protocol].key?(address)
        @@pool[interface][protocol][address]
      end
    end

    def self.teardown_instances
      @@pool.each do |if_sym, protocol_map|
        protocol_map.each do |protocol_sym, addr_map|
          addr_map.each do |addr, sender|
            sender.teardown
          end
        end
      end
    end

    def add_to_pool
      interface = @interface.class::SYMBOL
      protocol = @protocol.class::SYMBOL
      address = @interface.address
      @@pool[interface] = {} unless @@pool.key?(interface)
      @@pool[interface][protocol] = {} unless @@pool[interface].key?(protocol)
      raise "sender instance already exists: #{self.inspect}" if @@pool[interface][protocol].key?(address)
      @@pool[interface][protocol][address] = self
    end

    def initialize(interface, protocol, address)
      #@interface = interface
      #@protocol = protocol
      #@address = address
      setup(interface, protocol, address)
    end

    def setup(interface, protocol, address)
      case interface
      when InterfaceI2c::SYMBOL
        @interface = InterfaceI2c.new(address)
      else
        raise
      end
      case protocol
      when ProtocolHidApiCmds::SYMBOL
        @protocol = ProtocolHidApiCmds.new
      else
        raise
      end
      
      add_to_pool

      @interface.send(@protocol.start)
    end

    def teardown
      @interface.send(@protocol.stop)
      @protocol.teardown
      @interface.teardown
    end
    
    def send(event)
      @interface.send(@protocol.encode(event))
    end
    
  end # class Sender

end # module SuperHid::Output

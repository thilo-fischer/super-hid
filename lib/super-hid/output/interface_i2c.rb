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

require 'super-hid/helper'

module SuperHid::Output

  class InterfaceI2c

    SYMBOL = :i2c

    attr_reader :address

    def initialize(address)
      @address = address
      setup
    end
    
    IOCLT_CODE_I2C_SLAVE = 0x0703

    def setup
      i2cbus = 1 # for raspberry pi version 2 and later (?) -- FIXME make configurable
      @file = File.open("/dev/i2c-#{i2cbus}", "r+b")
      @file.ioctl(IOCLT_CODE_I2C_SLAVE, @address)
    end

    def teardown
      @file.close
    end
    
    def send(payload)
      case payload
      when Array
        payload.each {|p| send(p) }
      when String
        $logger.debug{"write to `#{@file.path}': #{hexdump(payload)}"}
        @file.write(payload)
      else
        raise "Invalid argument: #{payload.inspect}"
      end
    end
    
  end # class InterfaceI2c

end # module SuperHid::Output

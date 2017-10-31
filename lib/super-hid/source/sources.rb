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

require 'super-hid/source/dev_input'

module SuperHid::Source

  module Sources

    def self.create(spec)
      case spec
      when String
        case spec
        when /^dev:(.*)$/
          DevInput.new("/dev/input/by_path/#{$1}")
        when /^\/dev\/input\/(.*)$/
          DevInput.new(spec)
        else
          raise "invalid source spec: #{spec}"
        end
      else
        raise "unsupported source spec: #{spec.inspect}"
      end
    end

  end # module Sources
end # module SuperHid::Source

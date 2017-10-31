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

#require 'super-hid/processing/sources'
#require 'super-hid/processing/conditions'
#require 'super-hid/processing/operations'

##
# Start an instance of the super-hid program
module SuperHid::Run

  class Session

    attr_reader :sources, :operations, :options

    def initialize
      @sources = []
      @operations = []
      @options = {}
    end

    def announce_source(s)
      @sources << s unless @sources.include?(s)
    end

    def add_operation(o)
      @operations << o
    end

    def set_option(key, value)
      @options[key] = value
    end
    
  end # class Session

end # module SuperHid::Run

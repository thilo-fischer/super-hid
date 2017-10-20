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

require 'singleton'

require 'super-hid/session/session'

##
# Things related to the currently running program instance.
module SuperHid::Run  

  class Main

    include Singleton

    def run
      @cmdlineparser = SuperHid::Ui::CommandLineParser.new
      @cmdlineparser.parse
      
      #puts @cmdlineparser.inspect

    end # def run

  end # class Main

end # module SuperHid::Run

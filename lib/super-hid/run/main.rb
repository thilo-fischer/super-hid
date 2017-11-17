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

require 'singleton'

require 'super-hid/run/session'
require 'super-hid/run/cmdlineparser'

require 'super-hid/source/dev_input'

##
# Things related to the currently running program instance.
module SuperHid::Run

  class Main

    include Singleton

    def run
      @session = Session.new
      
      @cmdlineparser = CommandLineParser.new(@session)
      @cmdlineparser.parse
      
      $logger.debug("** Session: #{@session.inspect}")


      while true do

        # For now: only one source, DevInput.
        # TODO support multipe sources simultaneously => multithreaded source tracking
        events = SuperHid::Source::DevInput.get_events

        events.each do |ev|
          @session.operations.each do |op|
            # XXX stop procession according to `--else' option -> arrange operations in a tree structure instead of in an array?!
            op.check(ev)
          end
        end
        
      end

      Sender.teardown_instances

    end # def run

  end # class Main

end # module SuperHid::Run

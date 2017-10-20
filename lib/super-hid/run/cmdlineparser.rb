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

require 'optparse'

##
# Start an instance of the super-hid program
module SuperHid::Run

  ##
  # Parses the command line arguments passed to the super-hid program at invocation
  class CommandLineParser


    def initialize
      @options = {}
    end


    def parse
      
      option_parser = OptionParser.new do |opts|

        opts.banner =
          "Usage: #{File.basename $0} [ --config=<config-file> ] [ --input-layout=<kbd-layout> --target-layout=<kbd-layout> ] [ options ... ]"
        
	opts.on("--config=PATH",
                "Read key mapping configuration from given config file.") do |arg|
          @options[:config_file] = arg
        end

        opts.on("-iLAYOUT",
                "--input-layout=LAYOUT",
                "Interpret input from connected keyboards according to given X11 kbd layout.") do |arg|
          @options[:input_layout] = arg
        end

        opts.on("-tLAYOUT"
                "--target-layout=LAYOUT",
                "Send keycodes to be interpreted with given X11 kbd layout.") do |arg|
          @options[:target_layout] = arg
        end
        
        opts.separator ""
        opts.separator "Common options:"

        opts.on_tail("-h", "--help", "Prints this help") do
          puts opts
          exit
        end

        opts.on_tail("--version", "Show version") do
          puts SuperHid::VERSION
          exit
        end

      end # OptionParser.new

      option_parser.order(ARGV) do |arg|
        raise "wrong command line syntax" # XXX
      end

    end # def parse
    
  end # class CommandLineParser

end # module SuperHid::Run

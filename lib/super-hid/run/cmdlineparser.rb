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

require 'super-hid/processing/operations'
require 'super-hid/processing/event_filters'

##
# Start an instance of the super-hid program
module SuperHid::Run

  ##
  # Parses the command line arguments passed to the super-hid program at invocation
  class CommandLineParser

    attr_reader :devices, :options

    def initialize
      @operations = []
      @options = {}
    end


    def parse

      # to collect device arguments and event filter options (+--event+) given before operation option
      devices = []
      filters = []
      
     option_parser = OptionParser.new do |opts|

        opts.banner =
          "Usage: #{File.basename $0} [ --config=<config-file> ] ( [ /dev/input/<device> ... ] [ --event=<type>[:<code>[:<value>]] ... ] <operation-option> [ --final ] ) ..."
        
	opts.on("--config=PATH",
                "Read key mapping configuration from given config file.") do |arg|
          @options[:config_file] = arg
        end

	opts.on("--event=<type>[:<code>[:<value>]]",
                "Apply the following operations only to those events matching the given filter. <type> is the name of a specific event type according to https://www.kernel.org/doc/Documentation/input/event-codes.txt, a (Ruby) regular expression matching such names or a comma-separated list of these. Filter may also restrict events to certain event codes of values using the <code> and <value> parameters. <code> may be the name of a specific event code according to +include/linux/input.h+, a (Ruby) regular expression matching such names, an integer value, a range between integer values and/or code names or a comma-separated list of these. <value> may be an integer values, a range between integer values or a comma-separated list of these. Ranges for <code> and <value> can be specified as '64..127' or '64...128' according to the Ruby range syntax. Option may be given multiple times, and events must match at least one (not all) filters to apply operations.") do |arg|
          types, codes, values = arg.split(':')
          types = types.split(',').map do |arg|
            arg.strip!
            case arg
            when /^\w+$/
              arg
            when /^\/.*\/$/
              Regexp.new(arg)
            else
              raise "invalid event type specifier: `#{arg}'"
            end
          end
          codes = codes.split(',').map do |arg|
            arg.strip!
            case arg
            when /^\w+$/
              arg
            when /^\/.*\/$/
              Regexp.new(arg)
            when /^(0x)?\d$/
              base = $1 ? 16 : 10
              arg.to_i(base)
            when /^(\w+|(0x)?\d)(\.\.\.?)(\w+|(0x)?\d)$/
              raise "TODO: event code range from symbol or integer to symbol or integer"
            else
              raise "invalid event code specifier: `#{arg}'"
            end
          end if codes
          values = values.split(',').map do |arg|
            arg.strip!
            case arg
            when /^(0x)?\d$/
              base = $1 ? 16 : 10
              arg.to_i(base)
            when /^((0x)?\d)(\.\.\.?)((0x)?\d)$/
              raise "TODO: event value range"
            else
              raise "invalid event code specifier: `#{arg}'"
            end
          end if values
          filters << EventFilterStandard.new(types, codes, values)
        end

	opts.on("--final",
                "If operation has been applied to an event successfully, do not apply any further operations to it.") do |arg|
          @operations.last.final = true
        end

        opts.separator ""
        opts.separator "Devices:"
        opts.separator "Apply the following operations to the given devices."

        opts.separator ""
        opts.separator "Operations:"

        opts.on("--nop",
                "No-operation: Don't do anything. Useful e.g. in combination with `--final' to stop processing events with successive operations.") do
          Operation.new(devices, filters)
          devices, filters = [], []
        end
        
        opts.on("--combine=OPERATIONS",
                "Apply all given oprations successively. OPERATIONS is a string containing other operation and optional `--final' command line options. Command line options in the string shall be whitespace separated, keep in mind to escape this properly on the command line.") do |arg|
          raise TODO
          devices, filters = [], []
        end

        # XXX? add command line option +--drop+ as shortcut for +--nop --final+ followed by unrestricted +--forward+
        #opts.on("--drop",
        #        "Ignore such events.") do
        #  OperationDrop.new(devices, filters)
        #  devices, filters = [], []
        #end

        opts.on("--forward",
                "Simply forward events the operation applies to, drop all other.") do
          OperationForward.new(devices, filters)
          devices, filters = [], []
        end

        opts.on("--kbd-layout-translate=FROM:TO",
                "Interpret input from connected keyboards according to X11 kbd layout given as FROM and send keys to target system according to X11 kbd layout given as TO.") do |arg|
          from, to = arg.split(':')
          OperationKbdLayoutTranslate.new(devices, filters, from, to)
          devices, filters = [], []
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
        devices << arg
      end

    end # def parse
    
  end # class CommandLineParser

end # module SuperHid::Run

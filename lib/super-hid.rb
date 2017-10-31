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

##
# This is the central super-hid lib file.
#
# This block comment is used as the central place for general
# documentation and alike.
# 
# = TODOs
#
# == Conventions
#
# Some shortcuts are taken in implementation. When some code is
# written, and it is known upon time of writing that the code is not
# that great because it does not handle special corner cases, has
# suboptimal performance, is not flexible, extendable, easy to read
# and understand or unclean in another way, this code section should
# be marked accordingly. To mark these code sections, a comment is
# added including an according keyword that marks it as a TODO
# comment. Keywords are used according to the conventions of the
# Eclipse IDE:
#
# [FIXME] marks high priority issues.
# [TODO]  marks medium priority issues.
# [XXX]   marks low priority issues.
#
# As a general guideline, FIXME is used for issues that *should* be
# fixed before a stable release, e.g. possible bugs on corner cases,
# issues with huge performance impact and such.
#
# TODO is used for issues that should be fixed ASAP.
#
# XXX marks nice to have issues that should be fixed some day.
#
# Todo items shall also be prioritized according to the
#  Make It Work -- Make It Right -- Make It Fast
# principle. (I consider marking a todo item with huge performance
# impact +FIXME+ not in contrast to this principle: A *huge*
# performace impact may affect the program's usability in a way that
# comes close to _not working_.)
#
# If one of the keywords is followed by a _W, _R or _F, the todo item
# should be addressed to either make something *W*ork, *R*ight or
# *F*ast.
#
# If one of the keywords is followed by a question mark (e.g. +XXX?+),
# the comment does not describe an action that should be taken, but
# rather an action that should be considered and requires additional
# investigation and consideration to determine whether it is a good
# idea that should be done or a bad idea that should be forgotten
# after removing the comment.
#
# Most todo comments are located at those code sections they apply
# to. Some comments with general scope or affecting multiple code
# sections are placed in the central todo list below.
#
# To mark a region of code to which a todo comment applies to, the
# comment will be put before that region with the keyword suffixed
# with a '>'. The same keyword prefixed with a '<' will mark the end
# of the region.
#
# To link several such comments together, a tag can be specified in
# parenthesis as a suffix to the keyword, e.g. TODO(ticket4711).
#
# Code example demonstrating these conventions:
#  MAX_BAR_COUNTER = 42 # TODO(ut)
#  def foo(bar)
#    counter = 0 # TODO_R(ut) Defensive programming. Ensures +bar+
#                # contains correct number of elements. This code
#                # causes unnecessary runtime overhead and shall
#                # be superseeded by according unit tests ASAP.
#    bar.each do |bar_element|
#      # TODO(ut)>
#      counter += 1
#      raise "bar contains to many elements" if counter > MAX_BAR_COUNTER
#      # <TODO(ut)
#      process(bar_element)
#    end
#  end
#
# == Central TODO list
#


module SuperHid

  require 'super-hid/version'

end # module SuperHid

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

require 'super-hid/processing/event'

module SuperHid::Processing

  HID_USAGE_ID = {
      :KEY_A			=>  4,
      :KEY_B			=>  5,
      :KEY_C			=>  6,
      :KEY_D			=>  7,
      :KEY_E			=>  8,
      :KEY_F			=>  9,
      :KEY_G			=> 10,
      :KEY_H			=> 11,
      :KEY_I			=> 12,
      :KEY_J			=> 13,
      :KEY_K			=> 14,
      :KEY_L			=> 15,
      :KEY_M			=> 16,
      :KEY_N			=> 17,
      :KEY_O			=> 18,
      :KEY_P			=> 19,
      :KEY_Q			=> 20,
      :KEY_R			=> 21,
      :KEY_S			=> 22,
      :KEY_T			=> 23,
      :KEY_U			=> 24,
      :KEY_V			=> 25,
      :KEY_W			=> 26,
      :KEY_X			=> 27,
      :KEY_Y			=> 28,
      :KEY_Z			=> 29,

      :KEY_1			=> 30,
      :KEY_2			=> 31,
      :KEY_3			=> 32,
      :KEY_4			=> 33,
      :KEY_5			=> 34,
      :KEY_6			=> 35,
      :KEY_7			=> 36,
      :KEY_8			=> 37,
      :KEY_9			=> 38,
      :KEY_0			=> 39,

      :KEY_ENTER		=> 40,
      :KEY_ESC			=> 41,
      :KEY_BACKSPACE		=> 42,
      :KEY_TAB			=> 43,
      :KEY_SPACE		=> 44,
      :KEY_MINUS		=> 45,
      :KEY_EQUAL		=> 46,
      :KEY_LEFTBRACE		=> 47,
      :KEY_RIGHTBRACE		=> 48,
      :KEY_BACKSLASH		=> 49,
      # FIXME Non-US # => 50,
      :KEY_SEMICOLON		=> 51,
      :KEY_APOSTROPHE		=> 52,
      :KEY_GRAVE		=> 53,
      :KEY_COMMA		=> 54,
      :KEY_DOT			=> 55,
      :KEY_SLASH		=> 56,
      :KEY_CAPSLOCK		=> 57,

      :KEY_F1			=> 58,
      :KEY_F2			=> 59,
      :KEY_F3			=> 60,
      :KEY_F4			=> 61,
      :KEY_F5			=> 62,
      :KEY_F6			=> 63,
      :KEY_F7			=> 64,
      :KEY_F8			=> 65,
      :KEY_F9			=> 66,
      :KEY_F10			=> 67,
      :KEY_F11			=> 68,
      :KEY_F12			=> 69,

      # FIXME PrintScreen => 70,
      :KEY_SCROLLLOCK		=> 71,
      # FIXME Pause => 72,

      :KEY_INSERT		=> 73,
      :KEY_HOME			=> 74,
      :KEY_PAGEUP		=> 75,
      :KEY_DELETE		=> 76,
      :KEY_END			=> 77,
      :KEY_PAGEDOWN		=> 78,
      :KEY_RIGHT		=> 79,
      :KEY_LEFT			=> 80,
      :KEY_DOWN			=> 81,
      :KEY_UP			=> 82,

      :KEY_NUMLOCK		=> 83,
      :KEY_KPSLASH		=> 84,
      :KEY_KPASTERISK		=> 85,
      :KEY_KPMINUS		=> 86,
      :KEY_KPPLUS		=> 87,
      :KEY_KPENTER		=> 88,
      :KEY_KP1			=> 89,
      :KEY_KP2			=> 90,
      :KEY_KP3			=> 91,
      :KEY_KP4			=> 92,
      :KEY_KP5			=> 93,
      :KEY_KP6			=> 94,
      :KEY_KP7			=> 95,
      :KEY_KP8			=> 96,
      :KEY_KP9			=> 97,
      :KEY_KP0			=> 98,
      :KEY_KPDOT		=> 99,
      
      # FIXME Non-US \  => 100, ...

      :KEY_KPEQUAL		=> 103,

      :KEY_F13			=> 104,
      :KEY_F14			=> 105,
      :KEY_F15			=> 106,
      :KEY_F16			=> 107,
      :KEY_F17			=> 108,
      :KEY_F18			=> 109,
      :KEY_F19			=> 110,
      :KEY_F20			=> 111,
      :KEY_F21			=> 112,
      :KEY_F22			=> 113,
      :KEY_F23			=> 114,
      :KEY_F24			=> 115,

      # FIXME execute => 116
      :KEY_HELP			=> 117,
      :KEY_MENU			=> 118,
      # FIXME select => 119
      :KEY_STOP			=> 120,
      :KEY_AGAIN		=> 121,
      :KEY_UNDO			=> 122,
      :KEY_CUT			=> 123,
      :KEY_COPY			=> 124,
      :KEY_PASTE		=> 125,
      :KEY_FIND			=> 126,
      :KEY_MUTE			=> 127,
      :KEY_VOLUMEUP		=> 128,
      :KEY_VOLUMEDOWN		=> 129,

      # TODO ...

      :KEY_LEFTCTRL		=> 224,
      :KEY_LEFTSHIFT		=> 225,
      :KEY_LEFTALT		=> 226,
      # FIXME left GUI => 227
      :KEY_RIGHTCTRL		=> 228,
      :KEY_RIGHTSHIFT		=> 229,
      :KEY_RIGHTALT		=> 230,
      # FIXME right GUI => 231

      #:KEY_KPJPCOMMA		= 95
      #
      #:KEY_ZENKAKUHANKAKU	= 85
      #:KEY_102ND		= 86
      #:KEY_RO			= 89
      #:KEY_KATAKANA		= 90
      #:KEY_HIRAGANA		= 91
      #:KEY_HENKAN		= 92
      #:KEY_KATAKANAHIRAGANA	= 93
      #:KEY_MUHENKAN		= 94
      #:KEY_SYSRQ		= 99
      #:KEY_LINEFEED		= 101
      #:KEY_MACRO		= 112
      #:KEY_POWER		= 116	# SC System Power Down 
      #:KEY_KPPLUSMINUS		= 118
      #:KEY_PAUSE		= 119
      #:KEY_SCALE		= 120	# AL Compiz Scale (Expose) 
      #:
      #:KEY_KPCOMMA		= 121
      #:KEY_HANGEUL		= 122
      #:KEY_HANGUEL		= KEY_HANGEUL
      #:KEY_HANJA		= 123
      #:KEY_YEN			= 124
      #:KEY_LEFTMETA		= 125
      #:KEY_RIGHTMETA		= 126
      #:KEY_COMPOSE		= 127
      #:
      #:KEY_FRONT		= 132
      #:KEY_OPEN			= 134	# AC Open 
      #:KEY_PROPS		= 130	# AC Properties 
      #
      #:KEY_CALC			= 140	# AL Calculator 
      #:KEY_SETUP		= 141
      #:KEY_SLEEP		= 142	# SC System Sleep 
      #:KEY_WAKEUP		= 143	# System Wake Up 
      #:KEY_FILE			= 144	# AL Local Machine Browser 
      #:KEY_SENDFILE		= 145
      #:KEY_DELETEFILE		= 146
      #:KEY_XFER			= 147
      #:KEY_PROG1		= 148
      #:KEY_PROG2		= 149
      #:KEY_WWW			= 150	# AL Internet Browser 
      #:KEY_MSDOS		= 151
      #:KEY_COFFEE		= 152	# AL Terminal Lock/Screensaver 
      #:KEY_SCREENLOCK		= KEY_COFFEE
      #:KEY_DIRECTION		= 153
      #:KEY_CYCLEWINDOWS		= 154
      #:KEY_MAIL			= 155
      #:KEY_BOOKMARKS		= 156	# AC Bookmarks 
      #:KEY_COMPUTER		= 157
      #:KEY_BACK			= 158	# AC Back 
      #:KEY_FORWARD		= 159	# AC Forward 
      #:KEY_CLOSECD		= 160
      #:KEY_EJECTCD		= 161
      #:KEY_EJECTCLOSECD		= 162
      #:KEY_NEXTSONG		= 163
      #:KEY_PLAYPAUSE		= 164
      #:KEY_PREVIOUSSONG		= 165
      #:KEY_STOPCD		= 166
      #:KEY_RECORD		= 167
      #:KEY_REWIND		= 168
      #:KEY_PHONE		= 169	# Media Select Telephone 
      #:KEY_ISO			= 170
      #:KEY_CONFIG		= 171	# AL Consumer Control Configuration 
      #:KEY_HOMEPAGE		= 172	# AC Home 
      #:KEY_REFRESH		= 173	# AC Refresh 
      #:KEY_EXIT			= 174	# AC Exit 
      #:KEY_MOVE			= 175
      #:KEY_EDIT			= 176
      #:KEY_SCROLLUP		= 177
      #:KEY_SCROLLDOWN		= 178
      #:KEY_KPLEFTPAREN		= 179
      #:KEY_KPRIGHTPAREN		= 180
      #:KEY_NEW			= 181	# AC New 
      #:KEY_REDO			= 182	# AC Redo/Repeat 
      #:
      #:KEY_PLAYCD		= 200
      #:KEY_PAUSECD		= 201
      #:KEY_PROG3		= 202
      #:KEY_PROG4		= 203
      #:KEY_DASHBOARD		= 204	# AL Dashboard 
      #:KEY_SUSPEND		= 205
      #:KEY_CLOSE		= 206	# AC Close 
      #:KEY_PLAY			= 207
      #:KEY_FASTFORWARD		= 208
      #:KEY_BASSBOOST		= 209
      #:KEY_PRINT		= 210	# AC Print 
      #:KEY_HP			= 211
      #:KEY_CAMERA		= 212
      #:KEY_SOUND		= 213
      #:KEY_QUESTION		= 214
      #:KEY_EMAIL		= 215
      #:KEY_CHAT			= 216
      #:KEY_SEARCH		= 217
      #:KEY_CONNECT		= 218
      #:KEY_FINANCE		= 219	# AL Checkbook/Finance 
      #:KEY_SPORT		= 220
      #:KEY_SHOP			= 221
      #:KEY_ALTERASE		= 222
      #:KEY_CANCEL		= 223	# AC Cancel 
      #:KEY_BRIGHTNESSDOWN	= 224
      #:KEY_BRIGHTNESSUP		= 225
      #:KEY_MEDIA		= 226
      #:
      #:KEY_SWITCHVIDEOMODE	= 227	# Cycle between available video outputs (Monitor/LCD/TV-out/etc)
      #:KEY_KBDILLUMTOGGLE	= 228
      #:KEY_KBDILLUMDOWN		= 229
      #:KEY_KBDILLUMUP		= 230
      #:
      #:KEY_SEND			= 231	# AC Send 
      #:KEY_REPLY		= 232	# AC Reply 
      #:KEY_FORWARDMAIL		= 233	# AC Forward Msg 
      #:KEY_SAVE			= 234	# AC Save 
      #:KEY_DOCUMENTS		= 235
      #:
      #:KEY_BATTERY		= 236
      #:
      #:KEY_BLUETOOTH		= 237
      #:KEY_WLAN			= 238
      #:KEY_UWB			= 239
      #:
      #:KEY_UNKNOWN		= 240
      #:
      #:KEY_VIDEO_NEXT		= 241	# drive next video source 
      #:KEY_VIDEO_PREV		= 242	# drive previous video source 
      #:KEY_BRIGHTNESS_CYCLE	= 243	# brightness up, after max is min 
      #:KEY_BRIGHTNESS_AUTO	= 244	# Set Auto Brightness: manual brightness control is off, rely on ambient
      #:KEY_BRIGHTNESS_ZERO	= KEY_BRIGHTNESS_AUTO
      #:KEY_DISPLAY_OFF		= 245	# display device to off state 
      #:
      #:KEY_WWAN			= 246	# Wireless WAN (LTE, UMTS, GSM, etc.) 
      #:KEY_WIMAX		= KEY_WWAN
      #:KEY_RFKILL		= 247	# Key that controls all radios 
      #:
      #:KEY_MICMUTE		= 248	# Mute / unmute the microphone 
  }
  
  ##
  # Base class for all keyboard related events
  class EvKbd < Event
  end

  ##
  # Key press or release event
  class EvKbdKey < EvKbd
    attr_reader :key, :action
    ##
    # Params:
    # +key+:: Symbol refering to the key being pressed or released
    # +action+:: +:press+ or +:release+
    # +source+:: see Event#initialize
    # +raw_data+:: see Event#initialize
    def initialize(key, action, source, raw_data = nil)
      super(source, raw_data)
      @key = key
      @action = action
    end
    def to_s
      "keyboard #{@action} #{@key}"
    end
    def complete?
      @key and @action
    end
    ##
    # usage ID code of key according to "USB HID Usage Tables v1.12" (Hut1_12v2) 0x07
    def hid_usage_id
      if HID_USAGE_ID.key?(@key)
        HID_USAGE_ID[@key]
      else
        $logger.warn("Ignoring unsupported key: `#{@key}'")
      end
    end
  end # class EvKbdKey
  
end #module SuperHid::Processing

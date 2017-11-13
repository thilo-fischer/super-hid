// Invoke functions of the Arduino HID library based on data packets received via I2C.

#include <HID-Project.h>
#include <HID-Settings.h>

#include <Wire.h>

#include "interface.h"

// Original Arduino Micro has built-in LED connected to digital pin 13 (LED_BUILTIN).
// The cheap Arduino Micro compatible board I use most of the times (called "Pro Micro",
// seems to be a clone of SparcFun Pro Micro, https://www.sparkfun.com/products/12640)
// has LED connected to digital pin 17. We will always toggle pin 13 and pin 17 together
// such that the code would switch the LED properly on either board.
#define LED_BUILTIN_ALT 17

// We used pins 2 und 3 for I2C/TWI. Use pin 4 for key switch.
#define SWITCH_PIN 4

// this device's I2C slave Address
#define I2C_ADDRESS 0x10

// delay between two loop iterations in ms
#define LOOP_DELAY 50

void light_led(bool active) {
  if (active) {
    digitalWrite(LED_BUILTIN, LOW);
    digitalWrite(LED_BUILTIN_ALT, LOW);
  } else {
    digitalWrite(LED_BUILTIN, HIGH);
    digitalWrite(LED_BUILTIN_ALT, HIGH);
  }
}

bool switch_pressed() {
  return digitalRead(SWITCH_PIN) == LOW;
}

bool active = true;

void twi_rx(int count) {
  if (! active) {
    while (Wire.available()) {
      Wire.read();
    }
    return;
  }
  struct sCmd cmd;
  uint8_t *buf = (uint8_t*) &cmd;
  while (Wire.available()) {
    buf[0] = Wire.read();
    switch (cmd.dev_type) {
      case DEV_INVALID:
      continue;
      case DEV_KBD:
      case DEV_KBD_BOOT:
      {
      DefaultKeyboardAPI *dev = nullptr;
      switch (cmd.dev_type) {
        case DEV_KBD:
        dev = &Keyboard;
        break;
        case DEV_KBD_BOOT:
        dev = &BootKeyboard;
        break;
        default:
        ; // todo: signal error
      }      
      switch (cmd.op_code) {
        case OP_KBD_BEGIN:
        dev->begin();
        break;
        case OP_KBD_PRESS:
        cmd.data.kbd_key.keycode = Wire.read();
        dev->press(cmd.data.kbd_key.keycode);
        break;
        case OP_KBD_RELEASE:
        cmd.data.kbd_key.keycode = Wire.read();
        dev->release(cmd.data.kbd_key.keycode);
        break;
        case OP_KBD_REL_ALL:
        dev->releaseAll();
        break;
        case OP_KBD_END:
        dev->end();
        break;
        default:
        ; // todo: signal error
      }
      }
      case DEV_MOUSE:
      case DEV_MOUSE_BOOT:
      {
      MouseAPI *dev = nullptr;
      
      switch (cmd.dev_type) {
        case DEV_MOUSE:
        dev = &Mouse;
        break;
        case DEV_MOUSE_BOOT:
        dev = &BootMouse;
        break;
        default:
        ; // todo: signal error
      }      
      switch (cmd.op_code) {
        case OP_MOUSE_BEGIN:
        dev->begin();
        break;
        case OP_MOUSE_MOVE:
        {
        cmd.data.mouse_mv.x = Wire.read();
        cmd.data.mouse_mv.y = Wire.read();        
        int8_t wheel_dummy = 0;
        dev->move(cmd.data.mouse_mv.x, cmd.data.mouse_mv.y, wheel_dummy);
        break;
        }
        case OP_MOUSE_PRESS:
        cmd.data.mouse_btn.button = Wire.read();
        dev->press(cmd.data.mouse_btn.button);
        break;
        case OP_MOUSE_RELEASE:
        cmd.data.mouse_btn.button = Wire.read();
        dev->release(cmd.data.mouse_btn.button);
        break;
        case OP_MOUSE_WHEEL:
        {
        cmd.data.mouse_wheel.val = Wire.read();        
        int8_t x_dummy = 0;
        int8_t y_dummy = 0;
        dev->move(x_dummy, y_dummy, cmd.data.mouse_wheel.val);
        break;
        }
        case OP_MOUSE_END:
        dev->end();
        break;
        default:
        ; // todo: signal error
      }
      }
      default:
      ; // todo: signal not yet supported or error
    }
  }
}

void setup() {
  // LED pins (original and alternative pin)
  pinMode(LED_BUILTIN, OUTPUT);
  pinMode(LED_BUILTIN_ALT, OUTPUT);

  // key switch to GND on SWITCH_PIN
  pinMode(SWITCH_PIN, INPUT_PULLUP);

  Wire.begin(I2C_ADDRESS);        // join i2c bus with address #32 (ASCII code for space)
  Wire.onReceive(twi_rx);
}

bool switch_state = false;

void loop() {
  bool new_sw_state = switch_pressed();

  if (switch_state != new_sw_state) {
    if (new_sw_state) {
      active = false;
      // todo: release all keys of those devices of which the `begin()`function was called
      light_led(true);
    } else {
      active = true;
      light_led(false);
    }
    switch_state = new_sw_state;
  }

  delay(LOOP_DELAY);
}


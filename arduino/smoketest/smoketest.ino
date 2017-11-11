// Turn on LED and move mouse cursor to bottom right when switch connects pin 4 to GND.

#include <HID-Project.h>
#include <HID-Settings.h>

#include <Wire.h>

// Original Arduino Micro has built-in LED connected to digital pin 13 (LED_BUILTIN).
// The cheap Arduino Micro compatible board I use most of the times (called "Pro Micro",
// seems to be a clone of SparcFun Pro Micro, https://www.sparkfun.com/products/12640)
// has LED connected to digital pin 17. We will always toggle pin 13 and pin 17 together
// such that the code would switch the LED properly on either board.
#define LED_BUILTIN_ALT 17

// We will need pins 2 und 3 for I2C/TWI later on => use pin 4 for switch
#define SWITCH_PIN 4

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

void twi_rx(int count) {
  static bool toggle = false;
  toggle = ! toggle;
  light_led(toggle);

  while (1 < Wire.available()) { // loop through all but the last
    char c = Wire.read(); // receive byte as a character
  }
  int x = Wire.read();    // receive byte as an integer
}

void setup() {
  // LED pins (original and alternative pin)
  pinMode(LED_BUILTIN, OUTPUT);
  pinMode(LED_BUILTIN_ALT, OUTPUT);

  // switch to GND pin
  pinMode(SWITCH_PIN, INPUT_PULLUP);

  Wire.begin(' ');                // join i2c bus with address #32 (ASCII code for space)
  Wire.onReceive(twi_rx);
}

bool switch_state = false;

void loop() {
  bool new_sw_state = switch_pressed();

  if (switch_state != new_sw_state) {
    if (new_sw_state) {
      // XXX run Mouse.begin() every time again when switch is getting pressed?
      Mouse.begin();
      light_led(true);
    } else {
      Mouse.end();
      light_led(false);
    }
    switch_state = new_sw_state;
  }

  if (switch_state) {
    Mouse.move(2, 2, 0);
  }
  
  delay(100);
}


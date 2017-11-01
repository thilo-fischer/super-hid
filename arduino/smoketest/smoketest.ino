// Turn on LED when switch connects pin 4 to GND.

// Original Arduino Micro has built-in LED connected to digital pin 13 (LED_BUILTIN).
// The cheap Arduino Micro compatible board I use most of the times ("Pro-Micro-v11")
// has LED connected to digital pin 17
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

void setup() {
  // LED pins (original and alternative pin)
  pinMode(LED_BUILTIN, OUTPUT);
  pinMode(LED_BUILTIN_ALT, OUTPUT);

  // switch to GND pin
  pinMode(SWITCH_PIN, INPUT_PULLUP);
}

void loop() {

  if (switch_pressed()) {
    light_led(true);
  } else {
    light_led(false);
  }

   delay(50);
}


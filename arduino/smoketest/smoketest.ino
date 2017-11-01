// Turn off LED when switch connects pin 4 to GND.

// Original Arduino Micro has built-in LED connected to digital pin 13 (LED_BUILTIN).
// The cheap Arduino Micro compatible board I use most of the times ("Pro-Micro-v11")
// has LED connected to digital pin 17
#define LED_BUILTIN_ALT 17

// We will need pins 2 und 3 for I2C/TWI later on => use pin 4 for switch
#define INPUT_PIN 4

void setup() {
  pinMode(LED_BUILTIN, OUTPUT);
  pinMode(LED_BUILTIN_ALT, OUTPUT);

  pinMode(INPUT_PIN, INPUT_PULLUP);
}

void loop() {

  if (digitalRead(INPUT_PIN) == HIGH) {
    digitalWrite(LED_BUILTIN, LOW);
    digitalWrite(LED_BUILTIN_ALT, LOW);
  } else {
    digitalWrite(LED_BUILTIN, HIGH);
    digitalWrite(LED_BUILTIN_ALT, HIGH);
  }

   delay(50);
}


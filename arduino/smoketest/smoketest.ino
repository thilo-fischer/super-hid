// Like Arduino Blink example: Turns LED on for one second,
// then off for one second, repeatedly.

// Original Arduino Micro has built-in LED connected to digital pin 13 (LED_BUILTIN).
// The cheap Arduino Micro compatible board I use most of the times ("Pro-Micro-v11")
// has LED connected to digital pin 17
#define LED_BUILTIN_ALT 17

void setup() {
  pinMode(LED_BUILTIN, OUTPUT);
  pinMode(LED_BUILTIN_ALT, OUTPUT);
}

void loop() {
  digitalWrite(LED_BUILTIN, HIGH);
  digitalWrite(LED_BUILTIN_ALT, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  digitalWrite(LED_BUILTIN_ALT, LOW);
  delay(1000);
}


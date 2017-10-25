#include <Adafruit_NeoPixel.h>
#ifdef __AVR__
#include <avr/power.h>
#endif

#define NEO_DATA_PIN 6
Adafruit_NeoPixel strip = Adafruit_NeoPixel(7, NEO_DATA_PIN, NEO_GRB + NEO_KHZ800);

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  while (!Serial) {} // wait for connection

  delay(1000);
  
#ifdef SAMD_MKR1000
  Serial.println("MKR1k!");
#endif

  // start neopixel
  strip.begin();
  strip.setBrightness(128);
  strip.show(); // Initially, all pixels are 'off'
}

int pix = 0;

void loop() {
  // put your main code here, to run repeatedly:
  delay(1000);

  // reset to 0
  setColor(0, 0, 0);

  // show one pixel
  strip.setPixelColor(pix, strip.Color(50, 0, 0));
  strip.show();
  pix = (pix + 1) % 7;

#if !defined(ARDUINO_ARCH_AVR) && defined(ARDUINO_ARCH_SAMD) && defined(WINC1501_RESET_PIN)
  Serial.println("MKR1k!");
#else 
  Serial.println("tick");  
#endif
}

int i;

void setColor(int r, int g, int b) {
  // turn NP on
  for(i=0; i<strip.numPixels(); i++) {
    strip.setPixelColor(i, strip.Color(r, g, b));
  }
  strip.show();
}


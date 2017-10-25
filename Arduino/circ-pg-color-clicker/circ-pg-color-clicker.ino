#include <Adafruit_CircuitPlayground.h>
#include "Colorizer.h";

Colorizer colorizer;

volatile boolean tapped = false;
bool flashed = false;
unsigned long flashDelay = 450;
unsigned long flashStart = 0;
uint32_t flashColor = 0xFFFFFF;

bool buttonState = false;   // current reading
bool lastButtonState = false;   // last reading

unsigned long lastDebounceTime = 0;
unsigned long debounceDelay = 50;

unsigned long ic = 0;

void onTap() {
  tapped = true; // Hey loop(), play the sound!
}

void setup() {
  /* Serial.begin(9600);
    unsigned long start = millis();
    while (!Serial || (millis() - start) < 1000) {}; */

  // put your setup code here, to run once:
  CircuitPlayground.begin();

  // Configure accelerometer for +-4G range, use the tap interrupt
  // feature to call myFunction() automatically when tapped.
  CircuitPlayground.setAccelRange(LIS3DH_RANGE_4_G);
  CircuitPlayground.setAccelTap(1, 127);
  attachInterrupt(digitalPinToInterrupt(7), onTap, RISING);

  colorizer.start();

  randomSeed(analogRead(0));
}

void loop() {
  if (!CircuitPlayground.slideSwitch()) {
    CircuitPlayground.clearPixels();
    delay(1000);
    return;
  }

  if (tapped) {
    /*
       states:
       - tapped and not flashed yet
       - tapped and flashing
       - tapped and done flashing
    */
    if (!flashed) {
      if (!colorizer.flashing()) {
        flashed = true; // flash complete
        tapped = false; // tap complete
      }
    } else {
      flashed = false;
      colorizer.startFlash(450);
    }
  } else {
    bool left = CircuitPlayground.leftButton();
    bool right = CircuitPlayground.rightButton();
  
    bool reading = left || right;

    if (reading != lastButtonState) {
      lastDebounceTime = millis();
    }

    if ((millis() - lastDebounceTime) > debounceDelay) {
      if (reading != buttonState) {
        buttonState = reading;

        if (buttonState) {
          // colorizer.startFlash(100, colorizer.pick());
          
          if (left)  colorizer.next();
          if (right) colorizer.prev();
        }
      }
    }

    lastButtonState = reading;
  }

  colorizer.update();
  colorizer.draw();
}

/***********************************************************
  This is a test example for the Adafruit Trellis w/HT16K33.
  Reads buttons and sets/clears LEDs in a loop.
  "momentary" mode lights only when a button is pressed.
  "latching" mode toggles LED on/off when pressed.
  4 or 8 matrices can be used.  #define NUMTRELLIS to the
  number in use.

  Designed specifically to work with the Adafruit Trellis
  ----> https://www.adafruit.com/products/1616
  ----> https://www.adafruit.com/products/1611

  Adafruit invests time and resources providing this
  open source code, please support Adafruit and open-source
  hardware by purchasing products from Adafruit!

  Written by Limor Fried/Ladyada for Adafruit Industries.  
  MIT license, all text above must be included in any redistribution
 ***********************************************************/

#include <Wire.h>
#include "Adafruit_Trellis.h"

#define NUMTRELLIS 4        // **** SET # OF TRELLISES HERE

#define MOMENTARY 0
#define LATCHING  1

#define MODE      MOMENTARY  // **** SET MODE HERE

Adafruit_Trellis matrix[NUMTRELLIS] = {
  Adafruit_Trellis(), Adafruit_Trellis(),
  Adafruit_Trellis(), Adafruit_Trellis()
#if NUMTRELLIS > 4
 ,Adafruit_Trellis(), Adafruit_Trellis(),
  Adafruit_Trellis(), Adafruit_Trellis()
#endif
};

Adafruit_TrellisSet trellis = Adafruit_TrellisSet(
  &matrix[0], &matrix[1], &matrix[2], &matrix[3]
#if NUMTRELLIS > 4
 ,&matrix[4], &matrix[5], &matrix[6], &matrix[7]
#endif
);

#define numKeys (NUMTRELLIS * 16)

// Connect Trellis Vin to 5V and Ground to ground.
// Connect I2C SDA pin to your Arduino SDA line.
// Connect I2C SCL pin to your Arduino SCL line.
// All Trellises share the SDA, SCL and INT pin! 
// Even 8 tiles use only 3 wires max.

void setup() {
  Serial.begin(9600);
  Serial.println("Trellis Demo");

  // begin() with the addresses of each panel.
  // I find it easiest if the addresses are in order.
  trellis.begin(
    0x70, 0x71, 0x72, 0x73
#if NUMTRELLIS > 4
   ,0x74, 0x75, 0x76, 0x77
#endif
  );

  // light up all the LEDs in order
  for (uint8_t i=0; i<numKeys; i++) {
    trellis.setLED(i);
    trellis.writeDisplay();    
    delay(50);
  }
  // then turn them off
  for (uint8_t i=0; i<numKeys; i++) {
    trellis.clrLED(i);
    trellis.writeDisplay();    
    delay(50);
  }
}

void loop() {
  delay(30); // 30ms delay is required, dont remove me!
  
  if (MODE == MOMENTARY) {
    // If a button was just pressed or released...
    if (trellis.readSwitches()) {
      // go through every button
      for (uint8_t i=0; i<numKeys; i++) {
  // if it was pressed, turn it on
  if (trellis.justPressed(i)) {
    Serial.print("v"); Serial.println(i);
    trellis.setLED(i);
  } 
  // if it was released, turn it off
  if (trellis.justReleased(i)) {
    Serial.print("^"); Serial.println(i);
    trellis.clrLED(i);
  }
      }
      // tell the trellis to set the LEDs we requested
      trellis.writeDisplay();
    }
  }

  if (MODE == LATCHING) {
    // If a button was just pressed or released...
    if (trellis.readSwitches()) {
      // go through every button
      for (uint8_t i=0; i<numKeys; i++) {
        // if it was pressed...
  if (trellis.justPressed(i)) {
    Serial.print("v"); Serial.println(i);
    // Alternate the LED
    if (trellis.isLED(i))
      trellis.clrLED(i);
    else
      trellis.setLED(i);
        } 
      }
      // tell the trellis to set the LEDs we requested
      trellis.writeDisplay();
    }
  }
}

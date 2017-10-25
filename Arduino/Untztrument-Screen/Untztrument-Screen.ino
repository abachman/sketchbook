// Untztrument: https://www.adafruit.com/product/1929
// Arduino 101: https://www.adafruit.com/product/3033

// requires the Adafruit Trellis and Intel Curie (Arduino 101) board support, both available through the Arduino app.
#include <Wire.h>
#include <Adafruit_Trellis.h>

// Basic Trellis setup in the 2x2 Untztrument format
#define NUMTRELLIS 4

Adafruit_Trellis matrix[NUMTRELLIS] = {
  Adafruit_Trellis(), Adafruit_Trellis(),
  Adafruit_Trellis(), Adafruit_Trellis()
};

Adafruit_TrellisSet trellis = Adafruit_TrellisSet(
  &matrix[0], &matrix[1], &matrix[2], &matrix[3]
);
 
#define numKeys (NUMTRELLIS * 16)

// convert from Untz's 2x2 grid to a single large grid
const int UNTZ_TRANSLATE[64] = {
  0,  1,  2,  3,    16, 17, 18, 19, 
  4,  5,  6,  7,    20, 21, 22, 23,
  8,  9, 10, 11,    24, 25, 26, 27, 
 12, 13, 14, 15,    28, 29, 30, 31,

 32, 33, 34, 35,    48, 49, 50, 51, 
 36, 37, 38, 39,    52, 53, 54, 55, 
 40, 41, 42, 43,    56, 57, 58, 59, 
 44, 45, 46, 47,    60, 61, 62, 63
};

void setup() {
  Serial.begin(115200);

  // begin() with the addresses of each panel.
  // I find it easiest if the addresses are in order.
  trellis.begin(0x70, 0x71, 0x72, 0x73);
 
  // light up all the LEDs in order
  for (uint8_t i=0; i<numKeys; i++) {
    trellis.setLED(UNTZ_TRANSLATE[i]);
    trellis.writeDisplay();    
    delay(10);
  }
  
  // then turn them off
  for (uint8_t i=0; i<numKeys; i++) {
    trellis.clrLED(UNTZ_TRANSLATE[i]);
    trellis.writeDisplay();    
    delay(10);
  }
}

void loop() {
  while (Serial.available() > 0) {
    char image_val[8];
    Serial.readBytesUntil('\n', image_val, 8);
    
    for (uint8_t r=0; r < 8; r++) {
      char row = image_val[r];
      for (uint8_t c=0; c < 8; c++) {
        if ((1 << c) & row) {
          trellis.setLED(UNTZ_TRANSLATE[(c * 8) + r]);
        } else {            
          trellis.clrLED(UNTZ_TRANSLATE[(c * 8) + r]);              
        }
      }
    }
       
    trellis.writeDisplay();
  }
}

/*
   Original code retrieved from https://www.arduino.cc/en/Reference/BLEPeripheralAddAttribute

   Copyright (c) 2016 Intel Corporation.  All rights reserved.

   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with this library; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
*/

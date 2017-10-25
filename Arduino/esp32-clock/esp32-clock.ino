/*************************************************** 
  This is a library for our I2C LED Backpacks

  Designed specifically to work with the Adafruit LED 7-Segment backpacks 
  ----> http://www.adafruit.com/products/881
  ----> http://www.adafruit.com/products/880
  ----> http://www.adafruit.com/products/879
  ----> http://www.adafruit.com/products/878

  These displays use I2C to communicate, 2 pins are required to 
  interface. There are multiple selectable I2C addresses. For backpacks
  with 2 Address Select pins: 0x70, 0x71, 0x72 or 0x73. For backpacks
  with 3 Address Select pins: 0x70 thru 0x77

  Adafruit invests time and resources providing this open source code, 
  please support Adafruit and open-source hardware by purchasing 
  products from Adafruit!

  Written by Limor Fried/Ladyada for Adafruit Industries.  
  BSD license, all text above must be included in any redistribution
 ****************************************************/

#include <Wire.h> // Enable this line if using Arduino Uno, Mega, etc.
#include <Adafruit_GFX.h> 
#include "Adafruit_LEDBackpack.h"
Adafruit_7segment matrix = Adafruit_7segment();

void setup() {
#ifndef __AVR_ATtiny85__
  Serial.begin(9600);
  Serial.println("7 Segment Backpack Test");
#endif
  matrix.begin(0x70);
}

void loop() {
  /*
  // try to print a number thats too long
  matrix.print(10000, DEC);
  matrix.writeDisplay();
  delay(500);

  // print a hex number
  matrix.print(0xBEEF, HEX);
  matrix.writeDisplay();
  delay(500);

  // print a floating point 
  matrix.print(12.34);
  matrix.writeDisplay();
  delay(500);

    matrix.clear();
  matrix.writeDigitRaw(0, 1); matrix.writeDisplay(); delay(500);
  matrix.writeDigitRaw(0, 2); matrix.writeDisplay(); delay(500);
  matrix.writeDigitRaw(0, 4); matrix.writeDisplay(); delay(500);
  matrix.writeDigitRaw(0, 8); matrix.writeDisplay(); delay(500);
  matrix.writeDigitRaw(0, 16); matrix.writeDisplay(); delay(500);
  matrix.writeDigitRaw(0, 32); matrix.writeDisplay(); delay(500);
  matrix.writeDigitRaw(0, 64); matrix.writeDisplay(); delay(500);
  */

  // poop
  matrix.writeDigitRaw(0, 115); 
  matrix.writeDigitRaw(1, 63); 
  matrix.writeDigitRaw(3, 63); 
  matrix.writeDigitRaw(4, 115); 
  matrix.writeDisplay(); 
  delay(2000);

  // butt
  matrix.writeDigitRaw(0, 124); 
  matrix.writeDigitRaw(1, 28); 
  matrix.writeDigitRaw(3, 120); 
  matrix.writeDigitRaw(4, 120); 
  matrix.writeDisplay(); 
  delay(2000);
    
  // butt
  matrix.writeDigitRaw(0, 124); 
  matrix.writeDigitRaw(1, 28); 
  matrix.writeDigitRaw(3, 120); 
  matrix.writeDigitRaw(4, 120); 
  matrix.writeDisplay(); 
  delay(2000);

  matrix.writeDigitRaw(0, 28);
  matrix.writeDigitRaw(1, 112);
  matrix.writeDigitRaw(3, 83);
  matrix.writeDigitRaw(4, 19);
  matrix.writeDisplay();
  delay(500);
  /* 
  // print with print/println
  for (uint16_t counter = 0; counter < 9999; counter++) {
    matrix.println(counter);
    matrix.writeDisplay();
    delay(10);
  }

  // method #2 - draw each digit
  uint16_t blinkcounter = 0;
  boolean drawDots = false;
  for (uint16_t counter = 0; counter < 9999; counter ++) {
    matrix.writeDigitNum(0, (counter / 1000), drawDots);
    matrix.writeDigitNum(1, (counter / 100) % 10, drawDots);
    matrix.drawColon(drawDots);
    matrix.writeDigitNum(3, (counter / 10) % 10, drawDots);
    matrix.writeDigitNum(4, counter % 10, drawDots);
   
    blinkcounter+=50;
    if (blinkcounter < 500) {
      drawDots = false;
    } else if (blinkcounter < 1000) {
      drawDots = true;
    } else {
      blinkcounter = 0;
    }
    matrix.writeDisplay();
    delay(10);
  }
  */
}

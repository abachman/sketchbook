#include <Arduino.h>
#include <SPI.h>

/*
#include "Adafruit_BLE.h"
#include "Adafruit_BluefruitLE_SPI.h"
#include "Adafruit_BluefruitLE_UART.h"

#include "Adafruit_BLEMIDI.h"

#include "BluefruitConfig.h"
*/

#include <Wire.h>
#include "Adafruit_MPR121.h"

// You can have up to 4 on one i2c bus but one is enough for testing!
Adafruit_MPR121 cap = Adafruit_MPR121();

// Keeps track of the last pins touched
// so we know when buttons are 'released'
uint16_t lasttouched = 0;
uint16_t currtouched = 0;

void setup() {
  Serial.begin(9600);

  while (!Serial) { // delay until Serial attaches
    delay(10);
  }
  
  // put your setup code here, to run once:
  pinMode(A0, OUTPUT);

  Serial.println("Finding cap touch device...");

  // Default address is 0x5A, if tied to 3.3V its 0x5B
  // If tied to SDA its 0x5C and if SCL then 0x5D
  if (!cap.begin(0x5A)) {
    
    Serial.println("MPR121 not found, check wiring?");
    delay(100);
    
    while (1);
  }
  Serial.println("MPR121 found!");
}

int level = 0;

void loop() {
  // Get the currently touched pads
  currtouched = cap.touched();

  for (uint8_t i = 0; i < 12; i++) {
    // it if *is* touched and *wasnt* touched before, alert!
    if ((currtouched & _BV(i)) && !(lasttouched & _BV(i)) ) {
      // send note on
      // midi.send(0x90, i + 60, 0x64);
      Serial.print(i); Serial.println(" touched");
      digitalWrite(A0, HIGH);
    }
    // if it *was* touched and now *isnt*, alert!
    if (!(currtouched & _BV(i)) && (lasttouched & _BV(i)) ) {
      // send note off
      // midi.send(0x80, i + 60, 0x64);
      Serial.print(i); Serial.println(" released");
      digitalWrite(A0, LOW);
    }
  }

  // reset our state
  lasttouched = currtouched;
  
  // put a delay so it isn't overwhelming
  delay(100);
}

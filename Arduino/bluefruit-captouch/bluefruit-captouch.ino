#include <Arduino.h>
#include <SPI.h>

#include "Adafruit_BLE.h"
#include "Adafruit_BluefruitLE_SPI.h"
#include "Adafruit_BluefruitLE_UART.h"

#include "Adafruit_BLEMIDI.h"

#include "BluefruitConfig.h"

#define FACTORYRESET_ENABLE         1
#define MINIMUM_FIRMWARE_VERSION    "0.7.0"

Adafruit_BluefruitLE_SPI ble(BLUEFRUIT_SPI_CS, BLUEFRUIT_SPI_IRQ, BLUEFRUIT_SPI_RST);
Adafruit_BLEMIDI midi(ble);
bool isConnected = false;

/*********************************************************
  This is a library for the MPR121 12-channel Capacitive touch sensor

  Designed specifically to work with the MPR121 Breakout in the Adafruit shop
  ----> https://www.adafruit.com/products/

  These sensors use I2C communicate, at least 2 pins are required
  to interface

  Adafruit invests time and resources providing this open source code,
  please support Adafruit and open-source hardware by purchasing
  products from Adafruit!

  Written by Limor Fried/Ladyada for Adafruit Industries.
  BSD license, all text above must be included in any redistribution
**********************************************************/

#include <Wire.h>
#include "Adafruit_MPR121.h"

// You can have up to 4 on one i2c bus but one is enough for testing!
Adafruit_MPR121 cap = Adafruit_MPR121();


// Keeps track of the last pins touched
// so we know when buttons are 'released'
uint16_t lasttouched = 0;
uint16_t currtouched = 0;

#define LED_SIGNAL 14

// callback
void connected(void) {
  isConnected = true;

  Serial.println(F(" CONNECTED!"));
  delay(1000);
}

void disconnected(void) {
  Serial.println("disconnected");
  isConnected = false;
}

void BleMidiRX(uint16_t timestamp, uint8_t status, uint8_t byte1, uint8_t byte2)
{
  Serial.print("[MIDI ");
  Serial.print(timestamp);
  Serial.print(" ] ");

  Serial.print(status, HEX); Serial.print(" ");
  Serial.print(byte1 , HEX); Serial.print(" ");
  Serial.print(byte2 , HEX); Serial.print(" ");

  Serial.println();
}

void error(const __FlashStringHelper*err) {
  Serial.println("ERROR - ERROR - ERROR");
  Serial.println(err);
  while (1);
}

void setup() {
  Serial.begin(9600);

  /* while (!Serial) { // delay until Serial attaches
    delay(10);
  } */

  if ( !ble.begin(VERBOSE_MODE) ) {
    error(F("Couldn't find Bluefruit, make sure it's in CoMmanD mode & check wiring?"));
  }
  Serial.println( F("OK!") );

  if ( FACTORYRESET_ENABLE ) {
    /* Perform a factory reset to make sure everything is in a known state */
    Serial.println(F("Performing a factory reset: "));
    if ( ! ble.factoryReset() ) {
      error(F("Couldn't factory reset"));
    }
  }

  // Serial.println("sendCommandCheckON");
  // ble.sendCommandCheckOK(F("AT+uartflow=off"));
  Serial.println("echo(true)");
  ble.echo(true);

  // Serial.println("Requesting Bluefruit info:");
  /* Print Bluefruit information */
  // ble.info();

  /* Set BLE callbacks */
  Serial.println("setConnectCallback");
  ble.setConnectCallback(connected);
  Serial.println("setDisconnectCallback");
  ble.setDisconnectCallback(disconnected);

  // Set MIDI RX callback
  Serial.println("setRxCallback");
  midi.setRxCallback(BleMidiRX);

  ble.verbose(false);
  Serial.print(F("Waiting for a connection..."));

  Serial.println("Adafruit MPR121 Capacitive Touch sensor test");

  // Default address is 0x5A, if tied to 3.3V its 0x5B
  // If tied to SDA its 0x5C and if SCL then 0x5D
  if (!cap.begin(0x5A)) {
    Serial.println("MPR121 not found, check wiring?");
    while (1);
  }
  Serial.println("MPR121 found!");

  Serial.println(F("Enable MIDI: "));
  if ( ! midi.begin(true) ) {
    error(F("Could not enable MIDI"));
  }

  pinMode(A0, OUTPUT);

  Serial.println("rock and roll!");

}

uint8_t current_note;

void loop() {
  // Get the currently touched pads
  currtouched = cap.touched();

  for (uint8_t i = 0; i < 12; i++) {
    // it if *is* touched and *wasnt* touched before, alert!
    if ((currtouched & _BV(i)) && !(lasttouched & _BV(i)) ) {
      // send note on
      midi.send(0x90, i + 60, 0x64);
      Serial.print(i); Serial.println(" touched");
      digitalWrite(A0, HIGH);
    }
    // if it *was* touched and now *isnt*, alert!
    if (!(currtouched & _BV(i)) && (lasttouched & _BV(i)) ) {
      // send note off
      midi.send(0x80, i + 60, 0x64);
      Serial.print(i); Serial.println(" released");
      digitalWrite(A0, LOW);
    }
  }

  // reset our state
  lasttouched = currtouched;

  // comment out this line for detailed data from the sensor!
  // return;

  // put a delay so it isn't overwhelming
  delay(100);
}

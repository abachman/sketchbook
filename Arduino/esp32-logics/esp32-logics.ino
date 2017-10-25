#include <Wire.h> // Enable this line if using Arduino Uno, Mega, etc.
#include <Adafruit_GFX.h>
#include "Adafruit_LEDBackpack.h"

Adafruit_7segment matrix = Adafruit_7segment();

#include <AdafruitIO.h>
#include "config.h"

AdafruitIO_Feed *listen = io.feed("toggle-stream");
AdafruitIO_Feed *respond = io.feed("actions");

int chars[] = {0, 1, 3, 4};
#define CHARS 4

void setup() {
  matrix.begin(0x70);

  Serial.begin(115200);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for native USB
  }

  // connect to io.adafruit.com
  io.connect();

  // set up a message handler for the count feed.
  // the handleMessage function (defined below)
  // will be called whenever a message is
  // received from adafruit io.
  listen->onMessage(handleMessage);

  // wait for a connection
  int cur = 0;
  int attempts = 0;
  while(io.status() < AIO_CONNECTED) {
    if (cur % 2 == 0) {
      matrix.writeDigitRaw(0, 64);
      matrix.writeDigitRaw(1, 64);
      matrix.writeDigitRaw(3, 64);
      matrix.writeDigitRaw(4, 64);
    } else {
      matrix.writeDigitRaw(0, 0);
      matrix.writeDigitRaw(1, 0);
      matrix.writeDigitRaw(3, 0);
      matrix.writeDigitRaw(4, 0);
    }
    
    matrix.writeDisplay();
    cur = (cur + 1) % 2;

    if (attempts % 10 == 0) {
      Serial.println(io.statusText());
    }
    attempts++;
    
    delay(500);
  }

  int del = 200;
  
  matrix.writeDigitRaw(0, 0);
  matrix.writeDigitRaw(1, 0);
  matrix.writeDigitRaw(3, 0);
  matrix.writeDigitRaw(4, 125);
  matrix.writeDisplay();
  delay(del);  

  matrix.writeDigitRaw(0, 0);
  matrix.writeDigitRaw(1, 0);
  matrix.writeDigitRaw(3, 125);
  matrix.writeDigitRaw(4, 63);
  matrix.writeDisplay();
  delay(del);  
  
  matrix.writeDigitRaw(0, 0);
  matrix.writeDigitRaw(1, 125);
  matrix.writeDigitRaw(3, 63);
  matrix.writeDigitRaw(4, 0);
  matrix.writeDisplay();
  delay(del);
  
  matrix.writeDigitRaw(0, 125);
  matrix.writeDigitRaw(1, 63);
  matrix.writeDigitRaw(3, 0);
  matrix.writeDigitRaw(4, 0);
  matrix.writeDisplay();
  delay(del);
  
  matrix.writeDigitRaw(0, 63);
  matrix.writeDigitRaw(1, 0);
  matrix.writeDigitRaw(3, 0);
  matrix.writeDigitRaw(4, 0);
  matrix.writeDisplay();
  delay(del);

  matrix.writeDigitRaw(0, 0);
  matrix.writeDigitRaw(1, 0);
  matrix.writeDigitRaw(3, 0);
  matrix.writeDigitRaw(4, 0);
  matrix.writeDisplay();
  delay(del);

  matrix.writeDigitRaw(0, 64);
  matrix.writeDigitRaw(1, 64);
  matrix.writeDigitRaw(3, 64);
  matrix.writeDigitRaw(4, 64);
  matrix.writeDisplay();
}

void loop() {
  // put your main code here, to run repeatedly:
  io.run();
}

// this function is called whenever a 'counter' message
// is received from Adafruit IO. it was attached to
// the counter feed in the setup() function above.
void handleMessage(AdafruitIO_Data *data) {
  int i = data->toInt();
  if (i < 10000 && i > -1) {
    matrix.print(data->toInt());
  } else {
    matrix.writeDigitRaw(0, 64);
    matrix.writeDigitRaw(1, 64);
    matrix.writeDigitRaw(3, 64);
    matrix.writeDigitRaw(4, 64);  
  }
  /* if (data->toBool()) {
    matrix.print(1111); 
    respond->save((char*)"TRUTH");
  } else {
    matrix.print(9999);
    respond->save((char*)"FALSEHOOD");
  } */
  matrix.writeDisplay();
  
}

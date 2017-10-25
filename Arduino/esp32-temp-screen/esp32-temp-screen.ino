#include <Wire.h> // Enable this line if using Arduino Uno, Mega, etc.
#include <Adafruit_GFX.h>
#include "Adafruit_LEDBackpack.h"

Adafruit_7segment matrix = Adafruit_7segment();

#include <AdafruitIO.h>
#include "config.h"

AdafruitIO_Feed *temperature = io.feed("temperature");

int chars[] = {0, 1, 3, 4};
#define CHARS 4

void setup() {
  matrix.begin(0x70);

  // connect to io.adafruit.com
  io.connect();

  // set up a message handler for the count feed.
  // the handleMessage function (defined below)
  // will be called whenever a message is
  // received from adafruit io.
  temperature->onMessage(handleMessage);

  // wait for a connection
  int cur = 0;
  while(io.status() < AIO_CONNECTED) {
    for (int i=0; i<CHARS; i++) {
      matrix.writeDigitRaw(i, i == cur ? 64 : 0);
    }
    matrix.writeDisplay();
    cur = (cur + 1) % CHARS;
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
  
  matrix.print(data->toDouble());
  matrix.writeDisplay();
  
}

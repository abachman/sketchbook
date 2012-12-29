
#include <Wire.h>
#include <ArduinoNunchuk.h>
// #include <math.h>

/*
 * ArduinoNunchuk Demo
 *
 * Copyright 2011-2012 Gabriel Bianconi, http://www.gabrielbianconi.com/
 *
 * Project URL: http://www.gabrielbianconi.com/projects/arduinonunchuk/
 *
 */

#define BAUDRATE 19200

ArduinoNunchuk nunchuk = ArduinoNunchuk();

const int ledPinA = 13;

//// Average based input filter.
#define NUM_READINGS 10
#define NUM_FIELDS 3
int readings[NUM_FIELDS][NUM_READINGS];
int index = 0;          // the index of the current reading
int totals[NUM_FIELDS]; // the running totals
int averages[NUM_FIELDS]; // the average value
////

/// low-pass input filter.
// /*
//  * time smoothing constant for low-pass filter
//  * 0 ≤ alpha ≤ 1 ; a smaller value basically means more smoothing
//  * See: http://en.wikipedia.org/wiki/Low-pass_filter#Discrete-time_realization
//  */
// static final float ALPHA = 0.15f;
//  
// /**
//  * @see http://en.wikipedia.org/wiki/Low-pass_filter#Algorithmic_implementation
//  * @see http://developer.android.com/reference/android/hardware/SensorEvent.html#values
//  */
// protected float[] lowPass( float[] input, float[] output ) {
//     if ( output == null ) return input;
//      
//     for ( int i=0; i<input.length; i++ ) {
//         output[i] = output[i] + ALPHA * (input[i] - output[i]);
//     }
//     return output;
// }

////

void setup() {
  Serial.begin(BAUDRATE);

  nunchuk.init();
  pinMode(ledPinA, OUTPUT);

  // initialize all readings to 0
  for (int thisField = 0; thisField < NUM_FIELDS; thisField++) {
    for (int thisReading = 0; thisReading < NUM_READINGS; thisReading++) {
      readings[thisField][thisReading] = 0;
    }
  }
}

void loop() {
  nunchuk.update();
  calculateAverages(nunchuk);

  Serial.print(nunchuk.analogX, DEC);
  Serial.print(' ');
  Serial.print(nunchuk.analogY, DEC);
  Serial.print(' ');
  // Serial.print(nunchuk.accelX, DEC);
  Serial.print(averages[0], DEC);
  Serial.print(' ');
  // Serial.print(nunchuk.accelY, DEC);
  Serial.print(averages[1], DEC);
  Serial.print(' ');
  // Serial.print(nunchuk.accelZ, DEC);
  Serial.print(averages[2], DEC);
  Serial.print(' ');
  Serial.print(nunchuk.zButton, DEC);
  Serial.print(' ');
  Serial.println(nunchuk.cButton, DEC);

  // if (nunchuk.zButton == 0 && nunchuk.cButton == 0) {
  //   digitalWrite(ledPinA,LOW);
  // }
  // delay(10);
  // if (nunchuk.zButton == 1) {
  //   digitalWrite(ledPinA, HIGH);
  // }
  // delay(10);
  // if (nunchuk.cButton == 1) {
  //   digitalWrite(ledPinA, HIGH);
  // }
}

// calculate a moving average for the accelerometers
void calculateAverages(ArduinoNunchuk nunchuk) {
  int reading;

  for (int thisField = 0; thisField < NUM_FIELDS; thisField++) {
    // remove previous value in current index from running total
    totals[thisField] = totals[thisField] - readings[thisField][index];

    switch(thisField) {
    case 0:
      reading = nunchuk.accelX;
      break;
    case 1:
      reading = nunchuk.accelY;
      break;
    case 2:
      reading = nunchuk.accelZ;
      break;
    }
    readings[thisField][index] = reading;

    totals[thisField] = totals[thisField] + readings[thisField][index];

    // calculate the average:
    averages[thisField] = totals[thisField] / NUM_READINGS;
  }

  // if we're at the end of the array...
  if (index >= NUM_READINGS) {
    // ...wrap around to the beginning:
    index = 0;
  }
}

double lowPassFilter(int prev, int next) {
}

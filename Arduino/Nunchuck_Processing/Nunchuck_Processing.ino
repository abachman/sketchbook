
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

  nunchuk.init(true, true);
  pinMode(ledPinA, OUTPUT);
}

void loop() {
  nunchuk.update();

  Serial.print(nunchuk.analogX, DEC);
  Serial.print(' ');
  Serial.print(nunchuk.analogY, DEC);
  Serial.print(' ');
  Serial.print(nunchuk.accelX, DEC);
  Serial.print(' ');
  Serial.print(nunchuk.accelY, DEC);
  Serial.print(' ');
  Serial.print(nunchuk.accelZ, DEC);
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

double lowPassFilter(int prev, int next) {
}

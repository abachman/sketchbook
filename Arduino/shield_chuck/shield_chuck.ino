#include <Servo.h>
#include <Wire.h>
#include <ArduinoNunchuk.h>
#include <AFMotor.h>

/*
 * ArduinoNunchuk Demo
 *
 * Copyright 2011-2012 Gabriel Bianconi, http://www.gabrielbianconi.com/
 *
 * Project URL: http://www.gabrielbianconi.com/projects/arduinonunchuk/
 *
 */

AF_DCMotor motor(4);

#define BAUDRATE 19200

ArduinoNunchuk nunchuk = ArduinoNunchuk();

const int ledPinA = 13;

Servo servo1;

void setup() {
  Serial.begin(BAUDRATE);

  nunchuk.init();
  pinMode(ledPinA, OUTPUT);

  // turn on servo
  servo1.attach(9);
}

int servoDir = 90;

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

  if (nunchuk.zButton == 0 && nunchuk.cButton == 0) {
    digitalWrite(ledPinA,LOW);
    servo1.write(90);
  }
  delay(10);
  if (nunchuk.zButton == 1) {
    digitalWrite(ledPinA, HIGH);
    servo1.write(0);
  }
  delay(10);
  if (nunchuk.cButton == 1) {
    digitalWrite(ledPinA, HIGH);
    servo1.write(170);
  }

  // servoDir = map(nunchuk.analogX, 0, 255, 179, 0);
  // servo1.write(servoDir);
}

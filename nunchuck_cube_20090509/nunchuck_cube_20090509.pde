/**
 * wii controlled
 * RGB Cube.
 *
 * The three primary colors of the additive color model are red, green, and blue.
 * This RGB color cube displays smooth transitions between these colors.
 */

float xmag, ymag = 0;
float newXmag, newYmag = 0;
int sensorCount = 7;                        // number of values to expect

// NUNCHUCK sensors

static int STICK_X = 0;
static int STICK_Y = 1;
static int ACCEL_X = 2;
static int ACCEL_Y = 3;
static int ACCEL_Z = 4;
static int BUTTON_Z = 5;
static int BUTTON_C = 6;

import processing.serial.*;
Serial myPort;                // The serial port

int BAUDRATE = 19200;
char DELIM = ' '; // the delimeter for parsing incoming data

void setup() {
  size(600, 600, P3D);
  noStroke();
  colorMode(RGB, 1);
  println(Serial.list());
  myPort = new Serial(this, Serial.list()[4], BAUDRATE);
  // clear the serial buffer:
  myPort.clear();
}
float x, z;

void draw() {
  background(0.5, 0.5, 0.45);

  pushMatrix();

  translate(width/2, height/2, -30);

  newXmag = mouseX/float(width) * TWO_PI;
  newYmag = mouseY/float(height) * TWO_PI;

  float diff = xmag-newXmag;
  if (abs(diff) >  0.01) {
    xmag -= diff/4.0;
  }

  diff = ymag-newYmag;
  if (abs(diff) >  0.01) {
    ymag -= diff/4.0;
  }

//  if ((sensorValues[1] > 15) && (sensorValues[1] < 165)) {
    z = sensorValues[ACCEL_X] / 180 * PI ;
    x = sensorValues[ACCEL_Y] / 180 * PI;
 // }
 
 
  float transX = map(sensorValues[STICK_X], 0, 255, -255, 255), 
        transY = map(sensorValues[STICK_Y], 0, 255, 255, -255);
  translate(transX, transY);
  
  rotateZ(z);
  rotateX(x);
  scale(120);
  beginShape(QUADS);

  fill(0, 1, 1);
  vertex(-1,  1,  1);
  fill(1, 1, 1);
  vertex( 1,  1,  1);
  fill(1, 0, 1);
  vertex( 1, -1,  1);
  fill(0, 0, 1);
  vertex(-1, -1,  1);

  fill(1, 1, 1);
  vertex( 1,  1,  1);
  fill(1, 1, 0);
  vertex( 1,  1, -1);
  fill(1, 0, 0);
  vertex( 1, -1, -1);
  fill(1, 0, 1);
  vertex( 1, -1,  1);

  fill(1, 1, 0);
  vertex( 1,  1, -1);
  fill(0, 1, 0);
  vertex(-1,  1, -1);
  fill(0, 0, 0);
  vertex(-1, -1, -1);
  fill(1, 0, 0);
  vertex( 1, -1, -1);

  fill(0, 1, 0);
  vertex(-1,  1, -1);
  fill(0, 1, 1);
  vertex(-1,  1,  1);
  fill(0, 0, 1);
  vertex(-1, -1,  1);
  fill(0, 0, 0);
  vertex(-1, -1, -1);

  fill(0, 1, 0);
  vertex(-1,  1, -1);
  fill(1, 1, 0);
  vertex( 1,  1, -1);
  fill(1, 1, 1);
  vertex( 1,  1,  1);
  fill(0, 1, 1);
  vertex(-1,  1,  1);

  fill(0, 0, 0);
  vertex(-1, -1, -1);
  fill(1, 0, 0);
  vertex( 1, -1, -1);
  fill(1, 0, 1);
  vertex( 1, -1,  1);
  fill(0, 0, 1);
  vertex(-1, -1,  1);

  endShape();

  popMatrix();
}

float[] sensorValues = new float[sensorCount];  // array to hold the incoming values

void serialEvent(Serial myPort) {
  // read incoming data until you get a newline:
  String serialString = myPort.readStringUntil('\n');
  // if the read data is a real string, parse it:

  if (serialString != null) {
    // println(serialString);
    // println(serialString.charAt(serialString.length()-3));
    // println(serialString.charAt(serialString.length()-2));
    // split it into substrings on the DELIM character:
    String[] numbers = split(serialString, DELIM);
    // convert each subastring into an int
    if (numbers.length == sensorCount) {
      for (int i = 0; i < numbers.length; i++) {
        // make sure you're only reading as many numbers as
        // you can fit in the array:
        if (i <= sensorCount) {
          // trim off any whitespace from the substring:
          numbers[i] = trim(numbers[i]);
          sensorValues[i] =  float(numbers[i]);
        }
        // Things we don't handle in particular can get output to the text window
        // print(serialString);
      }
    }
  }
}

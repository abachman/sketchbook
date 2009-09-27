/**
 * wii controlled
 * RGB Cube.
 *
 * The three primary colors of the additive color model are red, green, and blue.
 * This RGB color cube displays smooth transitions between these colors.
 */

float xmag, ymag = 0;
float newXmag, newYmag = 0;
int sensorCount = 5;                        // number of values to expect

import processing.serial.*;
Serial myPort;                // The serial port

int BAUDRATE = 115200;
char DELIM = ','; // the delimeter for parsing incoming data

void setup()
{
  size(200, 200, P3D);
  noStroke();
  colorMode(RGB, 1);
  myPort = new Serial(this, Serial.list()[0], BAUDRATE);
  // clear the serial buffer:
  myPort.clear();

}
float x, z;

void draw()
{
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
    z = sensorValues[0] / 180 * PI ;
    x = sensorValues[1] / 180 * PI;
 // }

   rotateZ(z);
   rotateX(x);
  scale(50);
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
    println(serialString);
    //println(serialString.charAt(serialString.length()-3));
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
        print(serialString);
      }
    }
  }
}

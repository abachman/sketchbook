// Dimmer - sends bytes over a serial port
// by David A. Mellis
//This example code is in the public domain.

import processing.serial.*;
Serial port;

void setup() {
 size(512, 300);

 println("Available serial ports:");
 println(Serial.list());

 // Uses the first port in this list (number 0).  Change this to
 // select the port corresponding to your Arduino board.  The last
 // parameter (e.g. 9600) is the speed of the communication.  It
 // has to correspond to the value passed to Serial.begin() in your
 // Arduino sketch.
 port = new Serial(this, Serial.list()[0], 9600);

 // If you know the name of the port used by the Arduino board, you
 // can specify it directly like this.
 //port = new Serial(this, "COM1", 9600);
}

void draw() {
 // draw a gradient from black to white
 for (int i = 0; i < 256; i++) {
   stroke(i);
   line(i, 0, i, 150);
 }

 // write the current X-position of the mouse to the serial port as
 // a single byte
 port.write(mouseX);
}

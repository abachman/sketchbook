import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import oscP5.*; 
import netP5.*; 
import processing.video.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class portraits extends PApplet {




/**
 * Getting Started with Capture.
 *
 * Reading and displaying an image from an attached Capture device.
 */




Capture cam;
boolean spaced, reverse;
static int FLEN = 120;
PImage[] film;

int idx;
int pidx;

OscP5 oscP5;
NetAddress myRemoteLocation;
OscP5 oscLogClient;

public void log_message(String message) {
  OscMessage logOut = new OscMessage("/log");
  logOut.add(message);
  oscLogClient.send(logOut);
  println(message);
}

public void setup() {
  spaced = false;
  reverse = true;
  noStroke();
  size(640, 360);
  film = new PImage[FLEN];

  oscP5 = new OscP5(this, 53000);

  oscLogClient = new OscP5(this, "localhost", 5300);

  oscP5.plug(this,"triggerOn","/go");
  oscP5.plug(this,"triggerOff","/stop");
  oscP5.plug(this,"triggerClear","/clear");
  oscP5.plug(this,"triggerFlip","/flip");
  oscP5.plug(this,"triggerToggle","/toggle");
  oscP5.plug(this,"triggerFrame","/frame");

  idx = 0;
  pidx = 0;
  frameRate(16);

  String[] cameras = Capture.list();

  log_message("Available cameras:");
  for (int i = 0; i < cameras.length; i++) {
    log_message(cameras[i]);
  }

  // The camera can be initialized directly using an element
  // from the array returned by list():
  // cam = new Capture(this, cameras[0]);
  // Or, the settings can be defined based on the text in the list
  cam = new Capture(this, 640, 360, "FaceTime HD Camera (Built-in)", 30);

  // Start capturing the images from the camera
  cam.start();
}

public void triggerOn() {
  spaced = true;
}

public void triggerOff() {
  spaced = false;
}

public void triggerToggle() {
  spaced = !spaced;
}

public void triggerFlip() {
  reverse = !reverse;
}

public void triggerClear() {
  film = new PImage[FLEN];
}

public void triggerFrame(int f) {
  if (f >= 0 && f < FLEN) {
    pidx = f;
  }
}

PImage frame;

public void draw() {
  background(0);

  frame = film[119 - pidx];
  if (frame != null) {
    image(frame, 0, 0, width, height);
  }
  pidx = (pidx + 1) % FLEN;

  if (spaced) {
    if (cam.available() == true) {
      log_message("Capture frame " + idx);
      cam.read();
      PImage newFrame = cam.get();
      film[idx] = newFrame;
      idx = (idx + 1) % FLEN;

      image(newFrame, 20, 20, 213, 120);
    }
    fill(255, 0, 0);

    ellipse(20, 20, 20, 20);
  }
}

public void keyPressed() {
  if (keyCode == ENTER || keyCode == RETURN) {
    spaced = true;
  }
}

public void keyReleased() {
  if (keyCode == ENTER || keyCode == RETURN) {
    spaced = false;
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "portraits" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}

import oscP5.*;
import netP5.*;

/**
 * Getting Started with Capture.
 * 
 * Reading and displaying an image from an attached Capture device. 
 */
 

import processing.video.*;

Capture cam;
boolean spaced, reverse; 
static int FLEN = 120;
PImage[] film;

int idx;
int pidx;

OscP5 oscP5;
NetAddress myRemoteLocation;

void setup() {
  spaced = false;
  reverse = false;
  size(1080, 600);
  film = new PImage[FLEN];
  
  oscP5 = new OscP5(this, 53000);
  
  oscP5.plug(this,"triggerOn","/go");
  oscP5.plug(this,"triggerOff","/stop");
  oscP5.plug(this,"triggerClear","/clear");
  oscP5.plug(this,"triggerFlip","/flip");
  oscP5.plug(this,"triggerToggle","/toggle");
  
  idx = 0;
  pidx = 0;
  frameRate(16);
  
  String[] cameras = Capture.list();

  if (cameras == null) {
    println("Failed to retrieve the list of available cameras, will try the default...");
    cam = new Capture(this, 640, 480);
  } if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }

    // The camera can be initialized directly using an element
    // from the array returned by list():
    // cam = new Capture(this, cameras[0]);
    // Or, the settings can be defined based on the text in the list
    cam = new Capture(this, 640, 360, "FaceTime HD Camera (Built-in)", 30);
    
    // Start capturing the images from the camera
    cam.start();
  }
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


PImage frame;

void draw() {
  background(0);

  frame = film[119 - pidx];
  if (frame != null) {
    image(frame, 0, 0, width, height);
  }
  pidx = (pidx + 1) % FLEN;
  
  if (spaced) {
    if (cam.available() == true) {
      cam.read();
      PImage newFrame = cam.get();
      film[idx] = newFrame;
      idx = (idx + 1) % FLEN;
    }
    fill(255, 0, 0);
    ellipse(20, 20, 20, 20);
  }
}

void keyPressed() {
  if (keyCode == ENTER || keyCode == RETURN) {
    spaced = true;
  }
}

void keyReleased() {
  if (keyCode == ENTER || keyCode == RETURN) {
    spaced = false;
  }
}

//import oscP5.*;
//import netP5.*;

import processing.video.*;

Capture cam;
boolean spaced, reverse;
static int FLEN = 120;
PImage[] film;


int idx;
int pidx;

/* OscP5 oscP5;
NetAddress myRemoteLocation;
OscP5 oscLogClient; */

void log_message(String message) {
  /*
  OscMessage logOut = new OscMessage("/log");
  logOut.add(message);
  oscLogClient.send(logOut); */
  println(message);
}

void setup() {
  size(640, 360);
  pixelDensity(1);

  spaced = false;
  reverse = true;
  noStroke();

  film = new PImage[FLEN];

/*
  oscP5 = new OscP5(this, 53000);

  oscLogClient = new OscP5(this, "localhost", 5300);

  oscP5.plug(this,"triggerOn","/go");
  oscP5.plug(this,"triggerOff","/stop");
  oscP5.plug(this,"triggerClear","/clear");
  oscP5.plug(this,"triggerFlip","/flip");
  oscP5.plug(this,"triggerToggle","/toggle");
  oscP5.plug(this,"triggerFrame","/frame");
*/
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
  cam = new Capture(this, 640, 360, "FaceTime HD Camera", 30);

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

int c = 0, fr = 63, ne = 81;
float rr = 1.0;

void draw() {
  background(0);

  if (jitter) {
    frame = film[(int)random(120)];
  } else {
    frame = film[119 - pidx];
  }
  if (frame != null) {
    c++;
    image(frame, 0, 0, width, height);
    
    if (c % fr == 0) {
      filter(GRAY);
    }
    
    if (c % ne == 0) {
      filter(INVERT);
    }
  }
  
  pidx = (pidx + 1) % FLEN;
  if (pidx == 0) {
    fr = (int)random(60) + 1;
    ne = (int)random(60) + 1;
    rr = random(1.0);
    log_message("fr = " + fr + "; ne = " + ne + "; rr = " + rr);
  }

  if (spaced) {
    if (cam.available() == true) {
      //log_message("Capture frame " + idx);
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

boolean jitter = false;

HashMap<String, Boolean> keys = new HashMap();

void keyPressed() {
  if (keyCode == ENTER || keyCode == RETURN) {
    spaced = true;
  } else if (key == ' ') {
    jitter = true;
  } else if (key >= '1' && key <= '9') {
    log_message("char " + Character.getNumericValue(key));
    pidx = Character.getNumericValue(key) * 11;
  }
}

void keyReleased() {
  if (keyCode == ENTER || keyCode == RETURN) {
    spaced = false;
  } else if (key == ' ') {
    jitter = false;
  }
}
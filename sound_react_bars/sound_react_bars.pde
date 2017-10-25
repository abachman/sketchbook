import ddf.minim.*;
import ddf.minim.analysis.*;
/* import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*; */

PImage b;
float w,h,c, hw, hh;

Minim minim;
AudioInput in;

  
void setup() {
  size(640, 480, OPENGL); 
  noStroke();
  b=loadImage("f4.jpg");
  w=width;
  h=height;
  frameRate(30);
  
  hw = width /2;
  hh = height /2;
  minim = new Minim(this);
  
  // use the getLineIn method of the Minim object to get an AudioInput
  in = minim.getLineIn(Minim.MONO);
}

// cube
boolean spaceOn = false;
float xd = 0, yd = 0, xr = 0.009, yr = 0.03;

// bars
int step = 16;
int boost = 700;
float t;

// sampling levels
int samps;
float samp, sum, avg;

void draw() {
  lights();
  // background(0);
  fill(0, 20);
  rect(0, 0, w, h);
  fill(255);
  
  samps = 0;
  sum = 0;
  
  fill(0, 220, 0);
  
  // draw the waveforms so we can see what we are monitoring
  for(int i = 0; i < in.bufferSize() - step; i += step) {
    samp = abs(in.left.get(i));
    t = samp * boost;

    sum += samp;
    samps++;


    // pick random
    // fill(b.get(int(random(640)), int(random(480))));
    rect(i, hh, step, t);     
  }  
  
  avg = sum / samps;
  
  /*
  pushMatrix();
  rotate(-0.25*PI); 
  for (float x=-w; x<w; x+=c) {
    c=random(4,34); 
    fill(b.get(int(random(640)), int(random(480))));
    rect(x,-20,c,h*1.5);
  } 
  popMatrix();
  */  
  
  xd += xr; // .23;
  yd += yr; // .17;
  
  /* 
  if (random(1.0) > 0.8) {
    xr = random(0.1, 0.5);
  } else if (random(1.0) > 0.8) {
    yr = random(0.1, 0.5);
  } else if (random(1.0) > 0.8) {
    xr = -xr;
  } else if (random(1.0) > 0.8) {
    yr = -yr;
  }
  */
  
  fill(100,200,200);
  pushMatrix();
    translate(hw, 20 + hh / 2, 100);
    rotateX(noise(xd) * PI);
    rotateY(noise(yd) * PI);
    // translate(100, 100, 0);
    box(map(avg, 0, 1.0, 20, 300));
    /* if (spaceOn) { 
      box(random(200) + 50);
    } else {
      box(100);
    } */
  popMatrix();

}

void keyPressed() {
  if (key == ' ') {
    spaceOn = true;
  }
}

void keyReleased() {
  if (key == ' ') {
    spaceOn = false;
  } 
}
/* void mousePressed() {
  saveFrame("bg.png");
  exit();
} */
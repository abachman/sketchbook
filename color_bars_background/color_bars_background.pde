import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

PImage b;
float w,h,c, hw, hh;

Minim minim;
AudioInput in;


void setup() {
  size(1024, 768, OPENGL); 
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
boolean spaceOn = false;
void draw() {
  lights();
  background(0);
  stroke(255);
  
  println(in.bufferSize());
  
  int yo = 50;
  
  int step = 10;
  
  // draw the waveforms so we can see what we are monitoring
  for(int i = 0; i < in.bufferSize() - step; i += step) {
    println(i, in.left.get(i));
    line( i, yo + in.left.get(i) * 100, i+1, yo + in.left.get(i + step)*50 );
    // line( i, 150 + in.right.get(i)*50, i+1, 150 + in.right.get(i+1)*50 );
  }
  
  return; 

  /*
  pushMatrix();
  rotate(-0.25*PI); 
  for (float x=-w; x<w; x+=c) {
    c=random(4,34); 
    fill(b.get(int(random(640)), int(random(480))));
    rect(x,-20,c,h*1.5);
  } 
  popMatrix();
  
  fill(100,200,200);
  pushMatrix();
    translate(hw, hh, 100);
    rotateX(map(mouseX, 0, width, 0, 2*PI));
    rotateY(map(mouseY, 0, height, 0, 2*PI));  
    // translate(100, 100, 0);
    if (spaceOn) { 
      box(random(200) + 50);
    } else {
      box(100);
    }
    popMatrix();
    */
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
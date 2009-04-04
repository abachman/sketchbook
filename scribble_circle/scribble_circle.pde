import processing.opengl.*;
import traer.physics.*;

float x, y, z;
float rad = 80;
float px = 0,py = 0, pz = 0;
float rotinc = 0.1;
float ang = 0;
float scribble = 4;
void setup() {
  size(400,400,OPENGL);
  //noStroke();
  smooth();
  frameRate(30);
  printMatrix();
}


void draw() {

  background(200);
  
//  translate(width/2, height/2, -10);
  //rotateX(ang / 10);
  for (int s = 0;s < 100; s++) {
    x = rad * sin(ang) + random(-scribble,scribble) + (width/2);
    y = rad * -cos(ang) + random(-scribble,scribble) + (height/2);
    ang += rotinc;
    if (px!=0) line(px,py,x,y);
    px = x;
    py = y;  
  }
  

  //ellipse(x, y, 10, 10);
  //if (random(1000) > 800) ellipse(x,y,10,10);

}

import processing.opengl.*;

float a; 

void setup() {
  size(800, 600, OPENGL);
  fill(0, 153);
  noStroke();
}

void draw() {
  background(255);
  translate(width/2, height/2);
  rotateX(mouseY / -200.0);
  rotateY(mouseX / -150.0);
  
  translate(0,0,-50);
  rect(-200, -200, 400, 400);
  translate(0,0,50);
  rect(-200, -200, 400, 400);
  rotateX(PI/2);
  rect(-200, -200, 400, 400);
  translate(20,20,20);
  sphere(30);
  a += 0.01;
}

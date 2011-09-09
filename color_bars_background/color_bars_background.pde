PImage b;
float w,h,c;

void setup() {
  size(800,800,P2D); 
  noStroke();
  b=loadImage("f4.jpg");
  w=width;
  h=height;
  frameRate(1);
}

void draw() {
  rotate(-0.25*PI); 
  for (float x=-w; x<w; x+=c) {
    c=random(4,34); 
    fill(b.get(int(random(640)), int(random(480))));
    rect(x,-20,c,h*1.5);
  } 
}
void mousePressed() {
  saveFrame("bg.png");
  exit();
}



import processing.opengl.*;

PFont fon;
PImage cur;

float cx = 0, hw, hh;
int x,y,b,step=10,count,counter,xstep,ystep;

void setup() {
  size(640, 480, OPENGL);
  background(0);
  // 640 x 480 image
  cur = loadImage("3175092697_2f98d3c1f7_b.jpg");
  fon = loadFont("DejaVuSans-10.vlw");
  textFont(fon, 10);
  noStroke();
  xstep = width / 20;
  ystep = height / 32;
  hw = width /2;
  hh = height /2;
}

void draw() {
    
  lights();
  background(0);
  fill(100,200,200);

  pushMatrix();
    translate(hw, hh, 0);
    rotateX(map(mouseX, 0, width, 0, 2*PI));
    rotateY(map(mouseY, 0, height, 0, 2*PI));  
    //translate(100, 100, 0);
    box(50);
  popMatrix();
  pushMatrix();
    translate(hw, hh, -40);
    //fill(0, 250, 100);
    //ellipse(0, 0,  100, 100);
  popMatrix();
  
  cx += 1;
  
  // Loop through every `c_step` pixel.
  b = 0;
  // get line
  if (count >= height || count <= 0) {
    counter = count < 0 ? step : -step;
    count = count < 0 ? 1 : height - 1;
  }  
   
  // draw
  b = 0;
  x = 0;
  while (x < cur.width) {
    y = 0;
    while (y < cur.height) {
      fill(cur.get(b, count));
       y+= ystep;
       b += 1;
    }
    x+=xstep;
  }
}


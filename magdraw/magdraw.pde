PImage cur;
int x, y, step, big_step;
color c;
Magnifier m;

void setup() {
  size(640, 480);
  cur = loadImage("3175092697_2f98d3c1f7_b.jpg");
  //noLoop();
  noStroke();
  frameRate(10);
  step = 2;
  big_step = step * 10;
  m = new Magnifier();
}

int c_step;
void draw() {
  x = 0;
  while (x < cur.width) {
    y = 0;
    while (y < cur.height) {
      if (m.covers(x, y)) {
        c_step = big_step;
        fill(cur.get(x, y));
        rect(x, y, 10, 10); 
      }
      else {
        c_step = step;
      }
      y+= c_step;
    }
    x+=c_step;
  }
  m.cx = mouseX;
  m.cy = mouseY;
  //step = int(map(mouseX, 0, width, 1, 20));
  //println(step);
}

void boxify() {
  for (int i = 0; i < 20; i++) { 
    x = int(random(cur.width));
    y = int(random(cur.height));
    c = cur.get(x, y);
    fill(c, 128);
    rect(x, y, 10, 10);  
  }
}

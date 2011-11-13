
// circles go here
PGraphics surface;
// each color of circles
PGraphics[] circles = {null, null, null};

int hw,
    global_d  = 40,
    global_dx = 4,
    global_dy = 4;

class Circle {
  int x,y,dx,dy, d;
  Circle() {
    x = (int)random(width) - hw;
    y = (int)random(height) - hw;
    dx = global_dx * (random(1) > 0.5 ? 1 : -1) + (int)random(-2,2);
    dy = global_dy * (random(1) > 0.5 ? 1 : -1) + (int)random(-2,2);
    d  = global_d + (int)random(-20, 20);
  }

  // simple bouncing
  void update(){
    x += dx;
    y += dy;
    if (x >= hw || x <= -hw) { dx *= -1; }
    if (y >= hw || y <= -hw) { dy *= -1; }
  }

  void draw(PGraphics surface){
    surface.ellipse(x, y, d, d);
  }
}

final int ccount = 200;
Circle[] cc = new Circle[ccount];

void setup() {
  size(400, 400);
  background(0);
  noStroke();
  smooth();
  frameRate(30);
  hw = width / 2;
  for (int i=0; i<ccount; i++) {
    cc[i] = new Circle();
  }
  surface = createGraphics(width, height, P2D);
  surface.beginDraw();
  surface.fill(255);
  surface.smooth();
  surface.noStroke();
  surface.endDraw();
}

void draw() {
  background(0);

  surface.beginDraw();
  surface.background(0);
  // push 0,0 to center of view so I can rotate it later
  surface.translate(hw, hw);
  for (int i=0; i<ccount; i++) {
    cc[i].update();
    cc[i].draw(surface);
  }
  surface.endDraw();

  draw_circles(surface);
}

void draw_circles(PGraphics surface) {
  circles[0] = createGraphics(width, height, P2D);
  circles[1] = createGraphics(width, height, P2D);
  circles[2] = createGraphics(width, height, P2D);

  circles[0].beginDraw();
  circles[0].translate(hw, hw);
  circles[0].rotate(HALF_PI);
  circles[0].tint(255, 0, 0);
  circles[0].image(surface, -hw, -hw);
  circles[0].endDraw();

  circles[1].beginDraw();
  circles[1].translate(hw, hw);
  circles[1].rotate(PI);
  circles[1].tint(0, 255, 0);
  circles[1].image(surface, -hw, -hw);
  circles[1].endDraw();

  circles[2].beginDraw();
  circles[2].translate(hw, hw);
  circles[2].rotate(PI + HALF_PI);
  circles[2].tint(0, 0, 255);
  circles[2].image(surface, -hw, -hw);
  circles[2].endDraw();

  blend(circles[0], 0, 0, width, height, 0, 0, width, height, ADD);
  blend(circles[1], 0, 0, width, height, 0, 0, width, height, ADD);
  blend(circles[2], 0, 0, width, height, 0, 0, width, height, ADD);
}

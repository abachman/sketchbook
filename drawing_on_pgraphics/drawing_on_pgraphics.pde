
// circles go here
PGraphics surface;
// each color of circles
PGraphics[] circles = {null, null, null};

int half_width, half_height,
    global_d  = 40,
    global_dx = 4,
    global_dy = 4;

class Circle {
  int x,y,dx,dy, d, hd;
  Circle() {
    dx = global_dx * (random(1) > 0.5 ? 1 : -1) + (int)random(-2,2);
    dy = global_dy * (random(1) > 0.5 ? 1 : -1) + (int)random(-2,2);

    d  = global_d + (int)random(-20, 30);
    hd = d/2 + 4;

    x = (int)random(-(half_width - hd), half_width - hd);
    y = (int)random(-(half_height - hd), half_height - hd);
  }

  // simple bouncing
  void update(){
    x += dx;
    y += dy;
    if (x >= (half_width - hd) || x <= -(half_width - hd)) { dx *= -1; }
    if (y >= (half_height - hd) || y <= -(half_height - hd)) { dy *= -1; }
  }

  void draw(PGraphics surface){
    surface.ellipse(x, y, d, d);
  }
}

final int ccount = 3000;
Circle[] cc = new Circle[ccount];

void setup() {
  size(2000, 2000);
  background(0);
  noStroke();
  smooth();
  frameRate(30);
  half_width  = width / 2;
  half_height = height / 2;
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
  surface.translate(half_width, half_height);
  for (int i=0; i<ccount; i++) {
    cc[i].update();
    cc[i].draw(surface);
  }
  surface.endDraw();

  draw_circles(surface);

  save("circles.png");
  exit();
}

void draw_circles(PGraphics surface) {
  circles[0] = createGraphics(width, height, P2D);
  circles[0].beginDraw();
  circles[0].translate(half_width, half_height);
  circles[0].rotate(HALF_PI);
  circles[0].tint(255, 0, 0);
  circles[0].image(surface, -half_width, -half_height);
  circles[0].endDraw();
  blend(circles[0], 0, 0, width, height, 0, 0, width, height, ADD);

  circles[1] = createGraphics(width, height, P2D);
  circles[1].beginDraw();
  circles[1].translate(half_width, half_height);
  circles[1].rotate(PI);
  circles[1].tint(0, 255, 0);
  circles[1].image(surface, -half_width, -half_height);
  circles[1].endDraw();
  blend(circles[1], 0, 0, width, height, 0, 0, width, height, ADD);

  circles[2] = createGraphics(width, height, P2D);
  circles[2].beginDraw();
  circles[2].translate(half_width, half_height);
  circles[2].rotate(PI + HALF_PI);
  circles[2].tint(0, 0, 255);
  circles[2].image(surface, -half_width, -half_height);
  circles[2].endDraw();
  blend(circles[2], 0, 0, width, height, 0, 0, width, height, ADD);
}

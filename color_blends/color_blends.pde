int d = width / 2;
int hd = d / 2;
int hw = width / 2;
int top = d / 4;
int cmax = 255;
int cstart = 0;
int alpha = 255;
PGraphics[] circles = {null, null, null};
PGraphics surface;

void setup() {
  colorMode(RGB);
  size(400, 400);
  noStroke();
  smooth();
  background(0);
  frameRate(20);

  d = width / 2;
  hd = d / 2;
  hw = width / 2;
  top = d / 4;
  cmax = 255;
}

int current_mode = 0;
int[] modes = {BLEND, ADD, SUBTRACT, DARKEST, LIGHTEST,
               DIFFERENCE, EXCLUSION, MULTIPLY, SCREEN,
               OVERLAY, HARD_LIGHT, SOFT_LIGHT};

String[] mode_names = {"BLEND", "ADD", "SUBTRACT", "DARKEST", "LIGHTEST",
                       "DIFFERENCE", "EXCLUSION", "MULTIPLY", "SCREEN",
                       "OVERLAY", "HARD_LIGHT", "SOFT_LIGHT"};

PGraphics circle;

void draw() {
  background(0);
  alpha = int(map(0, 255, 0, width, mouseX));

  // circle = createGraphics(width, height, P2D);
  // circle.beginDraw();
  // circle.fill(128, alpha);
  // circle.ellipse(hw, hd + top, d, d);
  // circle.endDraw();

  // tint(255, 0, 0);
  // image(circle, 0, 0);
  // // blend(circle, 0, 0, width, height, 0, 0, width, height, modes[current_mode]);

  // pushMatrix();
  // translate(width/2, height/2);
  // rotate(HALF_PI);
  // translate(-width/2, -height/2);
  // tint(255, 255, 0);
  // // image(circle, 0, 0);
  // blend(circle, 0, 0, width, height, 0, 0, width, height, modes[current_mode]);
  // popMatrix();
  // // tint(255, 0, 0);

  multi_circles();
}

// three PGraphics drawing mode, one per color
void multi_circles() {
  for(int n=0;n<3;n++) {
    circles[n] = createGraphics(width, height, P2D);
    circles[n].noStroke();
    circles[n].smooth();
  }

  circles[0].beginDraw();
  circles[0].fill(255, 0, 0, alpha);
  circles[0].ellipse(hw, hd + top, d, d);
  circles[0].endDraw();

  circles[1].beginDraw();
  circles[1].fill(0, 255, 0, alpha);
  circles[1].ellipse(hw - (hd / 2), hd + hd + top, d, d);
  circles[1].endDraw();

  circles[2].beginDraw();
  circles[2].fill(0, 0, 255, alpha);
  circles[2].ellipse(hw + (hd / 2), hd + hd + top, d, d);
  circles[2].endDraw();

  blend(circles[0], 0, 0, width, height, 0, 0, width, height, modes[current_mode]);
  blend(circles[1], 0, 0, width, height, 0, 0, width, height, modes[current_mode]);
  blend(circles[2], 0, 0, width, height, 0, 0, width, height, modes[current_mode]);
}

void keyPressed() {
  if (keyCode == LEFT) { changeMode(-1); }
  else if (keyCode == RIGHT) { changeMode(1); }
}

void changeMode(int incr) {
  current_mode = abs((current_mode + incr) % modes.length);
  println("currently in " + mode_names[current_mode] + " mode");
}

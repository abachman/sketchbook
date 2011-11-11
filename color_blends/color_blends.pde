int d = width / 2;
int hd = d / 2;
int hw = width / 2;
int top = d / 4;
int cmax = 255;
int cstart = 0;
int alpha = 255;
PGraphics[] circles = {null, null, null};

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

void draw() {
  background(0);

  alpha = int(map(0, 255, 0, width, mouseX));

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
  if (keyCode == LEFT) {
    current_mode = abs((current_mode - 1) % modes.length);
  } else if (keyCode == LEFT) {

  } else {
    current_mode = (current_mode + 1) % modes.length;
  }
  println("currently in " + mode_names[current_mode] + " mode");
}

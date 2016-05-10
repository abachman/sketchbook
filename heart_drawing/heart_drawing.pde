static int CMAX = 100;

void setup() {
  size(800, 800, P2D);
  background(0);
  noFill();
  frameRate(30);
  colorMode(HSB, CMAX);
}

int mx = 0, c = 0;
int sc = 75;

void draw() {
  // c = (c + 1) % CMAX;
  c = int(CMAX * ((mouseY * 1.0) / height));
  stroke(c, CMAX, CMAX * 0.75);

  // if (mx != mouseX) {
    // background(0);
    strokeWeight(150 * ((mouseX * 1.0) / width));
    line(width/2, height - sc, sc, height/2);
    line(sc, height/2, width/4, sc);
    line(width/4, sc, width/2, height/2);
    line(width/2, height/2, width/4 * 3, sc);
    line(width/4 * 3, sc, width - sc, height/2);
    line(width - sc, height/2, width/2, height - sc);
    mx = mouseX;
  // }
}

void keyPressed() {
  switch(key) {
    case ' ':
      save(millis() + ".png");
      break;
  }
}

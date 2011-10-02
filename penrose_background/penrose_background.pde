/**
 * While it's running, use the up and down arrows to change the distance 
 * between the bars, and the left and right arrows to change the 
 * thickness of the bars.
 *
 * Spacebar saves a copy of the current image in the sketch file and names
 * it "background.png". It will also spit out the current BAR_WIDTH and STEP
 * values in the print area below the sketch. 
 *
 * To generate the current background, I played with the settings until
 * I found something I liked, plugged those in, and set IMAGEX to 1800 and
 * ONEPASS to true. This let me generate a background image that never repeats,
 * without trying to run a huge processing sketch for a long time.
**/

int BAR_WIDTH = 3; // width of each bar
int STEP = 0;      // space between bars
int IMAGEX = 2200; // width of image (should be real big for use as background, like 1800+)
boolean ONEPASS = false; // set this to true to generate rectangles one time, 
                        // save a pic, and quit.
int BAR_MIN = 50;  // how short can a bar be?                         
boolean DOUBLE_BARS = true; // draw two in a stack?
float FLOAT_MIN = 2.0;

class Rectangle {
  int x;
  Rectangle(int _x) {
    x = _x;
  }
  void draw() {
    fill(30);
    float height_1 = random(BAR_MIN, height/2);
    rect(this.x, 0, BAR_WIDTH, height_1);
    if (DOUBLE_BARS) {
      rect(this.x, height_1 + BAR_WIDTH, BAR_WIDTH, random(FLOAT_MIN, height/4));
    }
  }
}

Rectangle[] rects;

void setup() {
  size(IMAGEX, 500, P2D);
  background(51);
  noStroke();
  noSmooth();
  frameRate(2);
  reRect();
}

void reRect() {
  int COUNT = (IMAGEX / (BAR_WIDTH + STEP)) + 1;
  rects = new Rectangle[COUNT];
  for (int n=0; n < rects.length; n++) {
    rects[n] = new Rectangle((BAR_WIDTH + STEP) * n);
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      STEP += 1;
    } else if (keyCode == DOWN && STEP > 0) {
      STEP -= 1;
    } else if (keyCode == RIGHT) {
      BAR_WIDTH += 1;
    } else if (keyCode == LEFT && BAR_WIDTH > 1) {
      BAR_WIDTH -= 1;
    } 
  
    // regenerate rectangles if the parameters were modified.
    if (keyCode == UP || keyCode == DOWN || keyCode == LEFT || keyCode == RIGHT) {
      reRect();
    }
  } else if (key == ' ') {
    println("BAR_WIDTH:" + BAR_WIDTH + "; STEP:" + STEP);
    printme();
  }
}

void draw() {
  background(51);
  for (int n=0; n < rects.length; n++) {
    rects[n].draw();
  }
  if (ONEPASS) printme(); // print and exit
}

void printme() {
  saveFrame("background.png"); // png instead of jpg to avoid compression effects.
  exit();
}

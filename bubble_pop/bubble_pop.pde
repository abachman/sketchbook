/*
The one with the QuadTree.  Less flicker when you run against 
2000 dots.
*/
int MAXDOTS = 60;
int MAXBULLETS = 3000;
int MAXTURRETS = 4;
int CG = 0;
int STARTRAD = 10, MAXRAD = 15, BULLETPOWER = 6;

Dot[] dots = new Dot[MAXDOTS];
Bullet[] bullets = new Bullet[MAXBULLETS];
boolean[] keysPressed = new boolean[256];
Gun g;
QuadTree screen;
	
Gun[] guns = new Gun[MAXTURRETS];

void setup() {
  size(800, 600);
  background(255);
  //smooth();
  frameRate(30);  
  PFont font;
  font = loadFont("BitstreamVeraSansMono-Roman-20.vlw");
  textFont(font,10);
  g = new Gun();
  for (int i = 0; i < keysPressed.length; i++) {
    keysPressed[i] = false;
  }  
}

int CLICKED = 0;
int CURRENTBULLET = 0;
int COUNT = 0;
float DEPFREQ = .99;
public void draw() {
  background(255);
  screen = new QuadTree(0, 0, height, width, 0);
  // Score
  noStroke();
  fill(200);
  rect(10, 10, CLICKED / 2, CLICKED);

  // Dots 
  stroke(0);
  noFill();
  for (int i = 0; i < dots.length; i++) {
    if ((dots[i] == null || !dots[i].drawable) && random(1) > DEPFREQ) {
      float x, y;
      if (random(1) > .5f) {
        x = random(width);
        y = random(1) > .5f ? 0 : height;
      } else {
        x = random(1) > .5f ? 0 : width;
        y = random(height);
      }
      dots[i] = new Dot(x, y, STARTRAD,
        random(.5f, 2) * random(1) > .5f ? -1 : 1, random(.5f,2)
        * random(1) > .5f ? -1 : 1);
    }
    if (!(dots[i] == null)) {
      dots[i].update();
      dots[i].drawme();
      screen.insert(dots[i]);
      //text(dots[i].t, 10, 10);
      //text(dots[i].b, 10, 20);
      //text(dots[i].l, 10, 30);
      //text(dots[i].r, 10, 40);
    }
  }

  // Bullets
  noStroke();
  fill(0);
  for (int a = 0; a < MAXBULLETS; a++) {
    Bullet b = bullets[a];
    if (b != null && b.drawable) {
      if (b.update())
        b.drawme();
    }
  }

  // Guns
  stroke(0);
  noFill();
  strokeWeight(4);
  g.update(mouseX, mouseY);
  g.drawme();

  for (int gu = 0; gu < guns.length; gu++) {
    if (guns[gu]!=null) {
      guns[gu].update(dots);
      guns[gu].drawme();
    }
  }
  strokeWeight(1);
  CLOSESTDOT = null;
}

void pointer(float x, float y, float ox, float oy) {
  x -= ox;
  y -= oy;
  float d, r = 30;
  d = getAngle(x, y);
  line(ox, oy, r*sin(d)+ox,  r*cos(d)+oy);
}

float getAngle(float x, float y) {
  // Get the angle in radians for point (x,y) for rectangular to polar conversion.
  return y <= 0 ? PI + atan(x/y) : atan(x/y);
}
  
void keyPressed() {
  if (key < keysPressed.length)
    keysPressed[key] = true;
  if (key == ENTER || key == RETURN) {
    for (int cg=0;cg < guns.length;cg++) {
      if (guns[cg]==null){
        println("activate turret. " + cg);
        guns[cg] = new Gun(false, g.x, g.y);
        break;
      }
    }
  }
}

void keyReleased() {
  if (key < keysPressed.length)  
    keysPressed[key] = false;
}

int MAXDOTS = 40;
Dot[] dots = new Dot[MAXDOTS];

void setup() {
  size(200, 400);
  background(255);
  //smooth();
  frameRate(30);  
  PFont font;
  font = loadFont("BitstreamVeraSansMono-Roman-20.vlw");
  textFont(font,10);
}
int CLICKED = 0;
void draw() {
  background(255);
  for (int i=0; i < dots.length; i++) {
    if ((dots[i] == null || !dots[i].drawable) && random(1) > .9) {
      dots[i] = new Dot(random(width), 0, random(5, 12), 0, random(.5, 2));  
    }
    if (!(dots[i] == null)) {
      dots[i].update();
      dots[i].drawme();
    }
  }
  text(CLICKED, width-50,height-20);
}

void mousePressed(){
  for (int i=0; i < dots.length; i++) {
    if (!(dots[i] == null)) {
      dots[i].isHitting(mouseX, mouseY);
    }
  }
}

class Gun {
  
}

class Dot {
  float x,y,rad;
  float l,r,t,b;
  float vx,vy;
  boolean drawable, hit=false;
  Dot(float _x, float _y, float _rad, float _vx, float _vy) { 
    x = _x;
    y = _y;
    rad = _rad;
    vx = _vx;
    vy = _vy;
    drawable = true;
  }  
 
  boolean update() {
    x += vx;
    y += vy;
    if (y < 0 || y > height) {
      if (hit) 
        CLICKED++;
      drawable = false;
      hit = false;
      return false;
    }
    return true;    
  } 
  
  boolean isHitting(float hx, float hy) {
    if (((hx - x)*(hx - x) + (hy - y)*(hy - y)) < rad*rad) {
      hit = !hit;
      return true;
    }
    return false;
  }
  
  void drawme() {
    if (drawable) {
      stroke(0);
      if (hit) {
        fill(0);
      }
      else {
        noFill();
      }
      ellipse(x,y,2*rad,2*rad);
    }
  }
}

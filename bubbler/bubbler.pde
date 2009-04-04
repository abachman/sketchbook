
int MAXDOTS = 30;
int MAXPOSTS = 10;
float[] SPEED = new float[] {1, 4};
float[] RADIUS = new float[] {23, 50};
Dot[] dots;
Dot[] posts;
Button[] buttons = new Button[7];

void _init() {
  dots = new Dot[MAXDOTS];
  posts = new Dot[MAXPOSTS];
  for (int f=0;f<MAXPOSTS;f++) {
    posts[f] = new Dot(random(width),random(height),random(RADIUS[0],RADIUS[1]),0,0);
  }
  for (int f=0;f<MAXDOTS;f++) {
    dots[f] = new Dot(random(RADIUS[1], width-RADIUS[1]), random(RADIUS[1], height-RADIUS[1]), 
                      random(RADIUS[0],RADIUS[1]),
                      random(SPEED[0], SPEED[1]) * (random(1) > .5 ? -1 : 1), 
                      random(SPEED[0], SPEED[1]) * (random(1) > .5 ? -1 : 1));
  }
}

void setup() {
  size(400, 300);
  frameRate(30);
  smooth();
  _init();
  
  // wireframe view controls
  buttons[0] = new Button(5, height - 15);
  buttons[1] = new Button(20, height - 15);
  
  // dotval controls
  buttons[2] = new Button(width - 10, height - 10);
  buttons[3] = new Button(width - 10, height - 20);
  buttons[4] = new Button(width - 10, height - 30);
  buttons[5] = new Button(width - 10, height - 40);
  
  // quality control
  buttons[6] = new Button(35, height - 15);
  buttons[6].state = true;
  
  PFont font;
  font = loadFont("LucidaSans-11.vlw"); 
  textFont(font, 11); 
}

boolean SHOWDOTS = false, SHOWPOSTS = false, QUAL = true;
void draw() {
  background(0);
  fill(255);
  noStroke();
  for (int f=0;f<dots.length;f++) {
    dots[f].update(posts);
  }
  if (SHOWDOTS){
    for (int f=0;f<dots.length;f++) {
      dots[f].drawme();
    }
  }
  if (SHOWPOSTS) {
    for (int f=0;f<posts.length;f++) {
      posts[f].drawme();
    }
  }
  // Simple controls
    
  buttons[0].drawme();
  buttons[1].drawme();
  buttons[2].drawme(); buttons[2].state = false;
  buttons[3].drawme(); buttons[3].state = false;
  buttons[4].drawme(); buttons[4].state = false;
  buttons[5].drawme(); buttons[5].state = false;
  buttons[6].drawme();
  fill(255);
  text(MAXPOSTS, width-30, height-7);
  text(MAXDOTS, width-30, height-26);
}

void mousePressed() {
  if (buttons[0].update(mouseX, mouseY)) {
    SHOWDOTS = !SHOWDOTS;
  }
  else if (buttons[1].update(mouseX, mouseY)) {
    SHOWPOSTS = !SHOWPOSTS;
  }
  else if (buttons[2].update(mouseX, mouseY)) {
    MAXPOSTS = MAXPOSTS >= 0 ? MAXPOSTS-1 : 0;
  }
  else if (buttons[3].update(mouseX, mouseY)) {
    MAXPOSTS++;
  }
  else if (buttons[4].update(mouseX, mouseY)) {
    MAXDOTS = MAXDOTS >= 0 ? MAXDOTS-1 : 0;
  }
  else if (buttons[5].update(mouseX, mouseY)) {
    MAXDOTS++;
  }
  else if (buttons[6].update(mouseX, mouseY)) {
    if (buttons[6].state) {
      smooth();
      QUAL = true;
    }
    else {
      noSmooth();
      QUAL = false;
    }
  }
}

void keyPressed() {
  if (keyCode == ENTER || keyCode == RETURN) {
    _init();
  } 
}

class Dot {
  float x,y,rad;
  float l,r,t,b;
  float vx,vy;
  Dot(float _x, float _y, float _rad, float _vx, float _vy) { 
    x = _x;
    y = _y;
    rad = _rad;
    vx = _vx;
    vy = _vy;
    l = x-rad;
    r = x+rad;
    t = y-rad;
    b = y+rad;
  }  
  boolean update(Dot[] targs) {
    x += vx;
    y += vy;
    l = x-rad;
    r = x+rad;
    t = y-rad;
    b = y+rad;
    
    //if(false) {
      for (int f=0;f<targs.length;f++) {
        Dot d = targs[f];
        if (d == this || r < d.l || l > d.r || b < d.t || t > d.b) {
          continue;
        }
        //println(this.toString() + " checking " + d.toString());
        float da = (x-d.x), db = (y-d.y), dc = d.rad+rad; 
        float sides = (da*da + db*db), rads = (dc*dc);
        if (sides < rads) {
          float r = (sides - rads) / 100;
          if (QUAL)
            fill(255,80);
          else
            fill(175);
          ellipse((x+d.x)/2, (y+d.y)/2, r, r);

          //vx = -vx;
          //vy = -vy;
          //return true;
        }
      }
    //}
    
    if (l < 0 || r > width) vx = -vx;
    if (t < 0 || b > height) vy = -vy;
    return false;
  }  
  void drawme() {
    if (QUAL)
      stroke(255, 50);
    else
      stroke(255);
    noFill();
    ellipse(x,y,2*rad,2*rad);
    //line(l,0,l,height);
    //line(0,t,width,t);
  }
}

class Button {
  int x,y,r,b;
  int hw;
  boolean state;
  Button(int px, int py) {
    x = px;
    y = py;
    hw = 8;
    r = x + hw;
    b = y + hw;
    state = false;
  }
  void drawme() {
    stroke(255);
    if (state) fill(255);
    else noFill();
    rect(x,y,hw,hw);
  }
  boolean update(float cx, float cy) {
    if (cx > x && cx < r && cy > y && cy < b) {
      state = !state;
      return true;
    }
    return false;
   
  }
}

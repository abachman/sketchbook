int MAXDOTS = 40;
int MAXBULLETS= 300;
Dot[] dots = new Dot[MAXDOTS];
Bullet[] bullets = new Bullet[MAXBULLETS];
Gun g;

void setup() {
  size(600, 600);
  background(255);
  smooth();
  frameRate(30);  
  g = new Gun();
}

int CLICKED = 0;
int CURRENTBULLET = 0;
void draw() {
  background(255);
  for (int i=0; i < dots.length; i++) {
    if ((dots[i] == null || !dots[i].drawable) && random(1) > .9) {
      float x, y;
      if (random(1) > .5) { 
        x = random(width);
        y = random(1) > .5 ? 0 : height;
      } else {
        x = random(1) > .5 ? 0 : width;
        y = random(height);
      }
      dots[i] = new Dot(x, y, random(5, 12), 
        random(.5, 2) * random(1) > .5 ? -1 : 1, 
        random(.5, 2) * random(1) > .5 ? -1 : 1);  
    }
    if (!(dots[i] == null)) {
      dots[i].update();
      dots[i].drawme();
    }
  }
  for (int a = 0; a < MAXBULLETS; a++) {
    Bullet b = bullets[a];
    if (b != null && b.drawable) {
      if (b.update())
        b.drawme();
    }
  }
  int step = 4;
  if (keyPressed) {
    if (key == 'w')
      g.y -= step;
    if (key == 's')
      g.y += step;
    if (key == 'a')
      g.x -= step;
    if (key == 'd')
      g.x += step;
  }
  if (mousePressed){
    bullets[CURRENTBULLET] = new Bullet(g.x, g.y,g.dir,7,bullets[CURRENTBULLET==0 ? MAXBULLETS-1 : CURRENTBULLET-1]);
    CURRENTBULLET = CURRENTBULLET == MAXBULLETS - 1 ? 0 : CURRENTBULLET+1;
  }
  
  g.update(mouseX, mouseY);
  g.drawme();
}


class Gun {
  float dir, x, y, rad, diam;
  float bx, by, brad, bdiam;
  Gun() {
    x = width / 2;
    y = height;
    rad = 10;
    dir = 0;
    diam = rad*2;
    brad = 5;
    bdiam = brad*2;
  }  
  
  void update(float _x, float _y) {
    // make sure the b-line is pointing at the mouse
    float px = _x - x;
    float py = _y - y;
    float prad = rad * 1.5;
    if (py <= 0)
      prad = -prad;
    dir = atan(px/py);
    bx = prad*sin(dir) + x;
    by = prad*cos(dir) + y;
  }
  
  void drawme() {
    stroke(0);
    noFill();
    ellipse(x,y,diam,diam);
    strokeWeight(4);
    line(x,y,bx,by);
    strokeWeight(1);
    // ellipse(bx, by, bdiam, bdiam);
  } 
}

class Bullet {
  float ox,oy,x,y,dir,rad,speed;
  float vx, vy;
  boolean drawable;
  Bullet prev;
  Bullet(float _x, float _y, float _dir, float _spd, Bullet _prev) {
    x = _x;
    y = _y;
    dir = _dir;
    if (g.by <= _y) _spd = -_spd;
    vx = (_spd * sin(dir));
    vy = (_spd * cos(dir));
    drawable = true; 
    prev = _prev;
  } 
  boolean update(){
    x += vx;
    y += vy;
    if (x < 0 || x > width || y < 0 || y > height) {
      drawable = false;
      return false;
    }
    else {
      for (int count = 0; count < dots.length; count++) {
        Dot d = dots[count];
        if (d != null && d.drawable) {
          if (d.isHitting(x, y)) {
            CLICKED++;
            d.drawable = false;
            this.drawable = false;
            return false;
          }
        }
      }
    }
    return true;
  }
  void drawme(){
    noStroke();
    fill(0);
    rect(x,y,3,3);  
    if (prev != null && prev.drawable)
      line(x,y,prev.x,prev.y);
  }
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
    /*
     * Line from dot to a point 
     */
    //float cx = width/2, cy = height/2;
    float cx = g.x, cy = g.y;
    float nx = x - cx, ny = y - cy;
    float nd = atan(nx/ny);
    float nr = -.8;
    if (ny < 0) nr = -nr;
    nx = nr * sin(nd) + x;
    ny = nr * cos(nd) + y;
    //println((x-nx) + ", " + (y-ny));
    vx = nx - x;
    vy = ny - y;
    //line(x,y,nx,ny);

    
    x += vx;
    y += vy;
    if (y < 0 || y > height) {
      vy = -vy;
    }
    else if (x < 0 || x > width) {
      vx = -vx;
    }
    return true;    
  } 
  
  boolean isHitting(float hx, float hy) {
    if (dist(hx,hy,x,y) < rad) {   
      //(sq(hx - x) + sq(hy - y)) < sq(rad)) {
      hit = !hit;
      return true;
    }
    return false;
  }
  
  void drawme() {
    if (drawable) {
      stroke(0);
      ellipse(x,y,2*rad,2*rad);
    }
  }
}

Dot CLOSESTDOT = null;
class Gun {
  float dir, x, y, rad, diam;
  float t,b,l,r;
  float bx, by, brad, bdiam;
  boolean mobile;
  int step = 0, speed = 4;
  int freq = 4;
  
  Gun() {
    x = width / 2;
    y = height / 2;
    rad = 10;
    dir = 0;
    diam = rad*2;
    brad = 5;
    bdiam = brad*2;
    mobile = true;
  }  
  
  Gun(boolean m, float _x, float _y) {
    x = _x;
    y = _y;
    rad = 10;
    dir = 0;
    diam = rad*2;
    brad = 5;
    bdiam = brad*2;
    mobile = m;
    freq = 7;
  }

  void update(Dot[] dots) {
    // TURRET
    // make sure the b-line is pointing at the mouse
    float mindist = 1000, curdist;
    float _x=0, _y=0;
    if (CLOSESTDOT == null) {
      for (int d=0; d<dots.length;d++) {
        if (dots[d]!=null && dots[d].drawable) {
          curdist = dist(g.x,g.y,dots[d].x,dots[d].y);
          if (curdist < mindist) {
            CLOSESTDOT = dots[d];
            mindist = curdist;
          }
        }
      }
    }
            
    float px = CLOSESTDOT.x - x;
    float py = CLOSESTDOT.y - y;
    float prad = rad * 1.5;
    dir = getAngle(px,py);
    bx = prad*sin(dir) + x;
    by = prad*cos(dir) + y;
    // Add to the global bullet barrage
    if (step < freq) step++;
    else {
      step = 0;
      bullets[CURRENTBULLET] = new Bullet(3,bullets[CURRENTBULLET==0 ? MAXBULLETS-1 : CURRENTBULLET-1],
                                          bx, by, x, y);
      CURRENTBULLET = CURRENTBULLET == MAXBULLETS - 1 ? 0 : CURRENTBULLET+1;
    }
  }
  
  void update(float _x, float _y) {
    // TANK
    // _x and _y are the coordinates of the aiming point
    if (keysPressed['w'] || keysPressed['5'])
      y -= speed;
    if (keysPressed['s'] || keysPressed['2'])
      y += speed;
    if (keysPressed['a'] || keysPressed['1'])
      x -= speed;
    if (keysPressed['d'] || keysPressed['3'])
      x += speed;

    if (x < 0) x = 0;
    else if (x > width) x = width;
    if (y < 0) y = 0;
    else if (y > height) y = height;
    
    t = y-rad;
    b = y+rad;
    l = x-rad;
    r = x+rad;
  }
  
  void drawme() {
    ellipse(x,y,diam,diam);
    if (!mobile)
      line(x,y,bx,by);
    // ellipse(bx, by, bdiam, bdiam);
  } 
}

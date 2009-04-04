class Bullet {
  float ox,oy,x,y,dir,rad,speed;
  float vx, vy;
  boolean drawable;
  Bullet prev;
  Bullet(float _spd, Bullet _prev, float _x, float _y, float _ox, float _oy) {
    x = _x;
    y = _y;
    vx = _x - _ox;
    vy = _y - _oy;
    rad = 0;
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
        if (d != null && d.drawable && !d.hit) { 
          if (d.isHitting(x, y)) {
            if (d.rad > MAXRAD) {
              CLICKED++;
              d.drawable = false;
            }
            else {
              d.rad += BULLETPOWER;
            }
            this.drawable = false;
            return false;
          }
        }
      }
    }
    return true;
  }
  void drawme(){

    rect(x,y,3,3); 
  }
}

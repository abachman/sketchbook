/*
Unit is the base class for all dots, tanks and turrets.  

QuadTree holds units, so they can all "see" each other.

Subclasses should implement:
  update
  drawme
*/
class Unit {
  float x, y, rad, diam;
  float vx, vy, dir, speed;
  float t, b, l, r;
  color cstroke, cfill;
  boolean drawable, isstroked, isfilled;
  QuadTree region = null;
  
  Unit(float _x, float _y, float _rad) {
    // Basic unit is a circle with a location and a size.
    x = _x;
    y = _y;
    rad = _rad;
    diam = rad * 2;
    t = y-rad;
    b = y+rad;
    r = x+rad;
    l = x-rad;
    drawable=true;
    isstroked=true;
    isfilled=false;
  }
  
  void setStroke(boolean _isstroked, color _stroke) {
    isstroked = _isstroked;
    cstroke = _stroke;    
  }
  
  void setFill(boolean _isfilled, color _fill) {
    isfilled = _isfilled;
    cfill = _fill;    
  }
  
  void setSpeed(float _speed) {
    speed = _speed;
  }
  
  void setVelocity(float _vx, float _vy) {
    vx=_vx;
    vy=_vy;  
  }
  
  void setDirection(float _dir) {
    dir = _dir;  
  }

  void setDirection(float nx, float ny) {
    // "look at" another point
    dir = atan2(ny-y, nx-x);
  }
   
  void moveTo(float _x, float _y) {
    x = _x;
    y = _y;
    t = y-rad;
    b = y+rad;
    r = x+rad;
    l = x-rad;
  }
   
  public boolean isHitting(float hx, float hy, float hrad) {
    // is in contact with another circle?
    if (dist(hx, hy, x, y) < rad + hrad) {
      return true;
    }
    return false;
  }

  public boolean isHitting(float hx, float hy) {
    // is in contact with a given point?
    if (dist(hx, hy, x, y) < rad) {
      return true;
    }
    return false;
  }
   
  void drawme() {
    if (drawable) {
      if (isstroked) stroke(cstroke);
      else noStroke();
      if (isfilled) fill(cfill);
      else noFill();
      ellipse(x,y,diam,diam);  
      //if (region!=null)
      //  region.drawme();
    }
  }
}

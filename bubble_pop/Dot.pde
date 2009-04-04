class Dot {
  float x, y, rad;
  float l, r, t, b;
  float vx, vy, dir, speed;
  boolean drawable, hit = false;
  QuadTree region;
  
  Dot(float _x, float _y, float _rad, float _vx, float _vy) {
    x = _x;
    y = _y;
    rad = _rad;

    l = x-rad;
    r = x+rad;
    t = y-rad;
    b = y+rad;
    
    vx = _vx;
    vy = _vy;
    drawable = true;
    speed = random(.7f, 2);
  }

  public boolean update() {
    if (!drawable)
      return false;

    /* gun impact */
    for (int gu = 0; gu < guns.length; gu++) {
      if (guns[gu] == null) continue;
      Gun _g = guns[gu];
      if (isHitting(_g.x, _g.y, _g.rad)) {
        guns[gu]=null;
        return false;
      }
    }

    if (isHitting(g.x, g.y, g.rad)) {
      CLICKED = 0;
      background(255, 0, 0);
      return false;
    }

    float nx = g.x - x, ny = g.y - y;
    dir = getAngle(nx, ny);
    vx = speed * sin(dir);
    vy = speed * cos(dir);

    x += vx;
    l += vx;
    r += vx;
    y += vy;
    t += vy;
    b += vy;

    if (y < 0 || y > height) {
      vy = -vy;
    } else if (x < 0 || x > width) {
      vx = -vx;
    }
    return true;
  }

  public boolean isHitting(float hx, float hy, float hrad) {
    if (dist(hx, hy, x, y) < rad + hrad) {
      return true;
    }
    return false;
  }

  public boolean isHitting(float hx, float hy) {
    if (dist(hx, hy, x, y) < rad) {
      return true;
    }
    return false;
  }

  public void drawme() {
    if (drawable) {
      ellipse(x, y, 2 * rad, 2 * rad);
      //				if (region != null) {
      //					region.drawme();
      //				}
    }
  }
}

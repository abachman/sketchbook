class Turret extends Unit {
  // Ammo
  int ammo=50;
  int maxammo=ammo;
  int step=0, freq=4;
  float reload=0, reloadrate=.005;
  
  // Targeting
  float aimx,aimy,maxrange;
  
  Turret(float _x, float _y) {
    super(_x, _y, 5);
    setStroke(false, color(0));
    setFill(true, color(0));
    maxrange = 300;
    aimx = x;
    aimy = y-10;
  }
  
  void update(Dot[] dots) {
    if (!drawable)
      return;
    
    float mindist = 10000, curdist;
    Unit targ = null;
    for (int d=0; d <dots.length; d++) {
      if ((dots[d]!=null && dots[d].drawable)) {
        curdist = dist(x,y,dots[d].x,dots[d].y);
        if (curdist < mindist && curdist < maxrange) {
          if (curdist < rad + dots[d].rad) {
            drawable = false;
            return;
          }
          targ = dots[d];
          mindist = curdist;
        }
      }
    }
    
    if (ammo > 0 && targ != null && step == freq) {
      setDirection(targ.x, targ.y);
      aimx = (rad+2) * cos(dir) + x;
      aimy = (rad+2) * sin(dir) + y;
      bullets[CURRENTBULLET] = new Bullet(3,bullets[CURRENTBULLET==0 ? MAXBULLETS-1 : CURRENTBULLET-1],
                                          aimx, aimy, x, y);
      CURRENTBULLET = CURRENTBULLET == MAXBULLETS - 1 ? 0 : CURRENTBULLET+1;
      ammo--;
      reload = 0;
      step = 0;
    }
    else if (ammo > 0) {
      step++;
    }
    else {
      if (reload < 1) {
        reload += reloadrate;
      }
      else {
        ammo = maxammo;
        reload = 0;
      }
    }
  }
  
  void drawme() {
    if (drawable) {
      super.drawme();
      stroke(1);
      line(x,y,aimx,aimy);
      noFill();
      //ellipse(x,y,maxrange*2,maxrange*2);
      if (ammo == 0) {
        line(x-20,y+10,(x-20) + (40 * reload),y+10);
      }
      else {
        line(x-20,y+10,(x-20) + (40 * ((float)ammo/maxammo)),y+10);
      }
      //range.drawme();
    }
  }
}

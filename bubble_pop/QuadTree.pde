int QUADDEPTH = 4;
class QuadTree {
  float cw, ch;
  float x, y, bx, by, h, w;
  QuadTree nw, ne, se, sw;
  int level;
  boolean isBottom = false;
  Dot[] leaves;
  Gun gunleaf;
  int nextLeaf=0;

  public QuadTree(float px, float py, float ph, float pw, int plevel) {
    x = px;
    y = py;
    h = ph;
    w = pw;
    bx = x+w;
    by = y+h;
    cw = (x + bx) / 2;
    ch = (y + by) / 2;
    leaves = new Dot[MAXDOTS];
    level = plevel;
    if (level == (QUADDEPTH-1)) isBottom = true;	
  }

  public void insert(Dot d) {
    if (isBottom) {
      add(d);
      return;
    }

    if (d.b < ch) {
      if (d.r < cw) {
        if (nw==null) {
          nw = new QuadTree(x,y,h/2,w/2,level+1);
        }
        nw.insert(d);
      } else if (d.l > cw) {
        if (ne == null) {
          ne = new QuadTree(cw,y,h/2,w/2,level+1);
        }
        ne.insert(d);
      } else {
        add(d);
      }
    } else if (d.t > ch) {
      if (d.r < cw) {
        if (sw == null) {
          sw = new QuadTree(x,ch,h/2,w/2,level+1);	
        }
        sw.insert(d);
      } else if (d.l > cw) {
        if (se == null) {
          se = new QuadTree(cw,ch,h/2,w/2,level+1);
        }
        se.insert(d);
      } else {
        add(d);
      }
    } else {
      add(d);
    }
  }

  public void add(Dot d) {
    leaves[nextLeaf++] = d;
    d.region = this;
  }
  
  public void Debug(Dot d) {
    stroke(0);
    fill(0);
    // text("Inserting " + d + " at level " + level, width/2, 10);
    text("d.t = " + d.t + "; d.b = " + d.b + "; d.l = " + 
         d.l + "; d.r = " + d.r, width/2, 20);
    text("x = " + x + "; y = " + y + "; cw = " + cw + "; ch = " +
         ch + "; h = " + h + "; w = " + w, width/2, 30);
    }

  public Dot isHitting(Bullet b) {
    int i = 0;
    while (leaves[i] != null) {
      if (leaves[i].isHitting(b.x, b.y))
        return leaves[i];
      i++;
    }
    if (isBottom) return null;

    if (b.y < ch) {
      if (b.x < cw)
        return nw==null ? null : nw.isHitting(b);
      else
        return ne==null ? null : ne.isHitting(b);
    } else {
      if (b.x < cw)
        return sw==null ? null : sw.isHitting(b);
      else
        return se==null ? null : se.isHitting(b);
    }
  }

  public void drawme() {
    //println("Now at level " + level);
    noStroke();
    fill(0, 66, 99, 50);
    rect(x, y, w, h);
    fill(0);
    ellipse(cw,ch,3,3);
  }
}

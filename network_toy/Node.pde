class NearNode {
  Node n;
  float d, i;
  NearNode (Node _n, float _d) {
    n=_n;
    d=_d;
    i=0;
  }
}

color INFECTION = color(79,180,29);
int MAXNEIGHBORS = 30;
class Node {
  float x,y,hw,cx,cy;
  float hitx, hity;
  float range;
  float infect_stren;
  boolean is_infected, is_mobile;
  boolean clicked;
  int id;
  color fil;
  NearNode[] cons;
  
  Edge[] edges;
  
  Node (float _x, float _y, float _hw) {
    x=_x;
    y=_y;
    hw = _hw;
    cx = x + hw/2;
    cy = y + hw/2;
    clicked = false;
    range = (height + width / 2) / 4;
    is_infected = false;
    is_mobile = true;
    id = this.hashCode();
    cons = new NearNode[MAXNEIGHBORS];
  }
  
  boolean isHitting(float nx, float ny) {
    if (nx <= x+hw && nx >= x && ny >= y && ny <= y + hw) {
      hitx = nx - x;
      hity = ny - y;
      return true;  
    }
    return false;
  }
  
  float getDist(float nx, float ny) {
    return dist(cx,cy,nx,ny);
  }  
  
  float getDist(Node on) {
    return dist(cx,cy,on.cx,on.cy);
  }  
  
  void evaluate(Node on) {
    for (int c=0;c<cons.length;c++) {
      if (cons[c] != null && cons[c].n == on) {
        cons[c].d = getDist(on);
        if (cons[c].d > range) {
          cons[c] = null;
        }
        else {
          // is an obstacle blocking?
        }
        return;
      }
    }
  }
  
  void disconnect(Node on) {
    for (int c=0;c<cons.length;c++) {
      if (cons[c] != null && cons[c].n == on) {
        cons[c] = null;
      }
    }
  }
  
  void update(Network net){
    // let the node at the other end of the connection drop if this node is 
    // out of range.
    for (int o=0;o<cons.length;o++) {
      if (cons[o] == null) continue;
      cons[o].n.evaluate(this);       
    }
    
    // Find neighbors
    cons = new NearNode[MAXNEIGHBORS];
    for (int n=0;n<net.nodes.size();n++) {
      Node nod = (Node)net.nodes.get(n);
      float nd = nod.getDist(cx,cy);
      if (nd < range) {
        addNeighbor(nod, nd);
      }        
    }
  }
    
  void addNeighbor(Node n, float d) {
    for (int c=0;c<cons.length;c++) {
      if (cons[c] == null) {
        cons[c] = new NearNode(n, d);
        return;
      }
    }
  }
  
  void move(float nx, float ny) {
    if (is_mobile) {
      x = nx - hitx;
      y = ny - hity;  
      cx = x + hw/2;
      cy = y + hw/2;
      
      // Draw range reminder
      // stroke(0,50);
      // noFill();
      // ellipse(cx,cy,range*2,range*2);
    }
  }
  
  void drawnode() {
    strokeWeight(3);
    stroke(0);
    if (clicked) fill(255,100,100);
    else fill(100);
    rect(x,y,hw,hw);
  }
  
  void drawconnections() {
    strokeWeight(1);
    noFill();
    stroke(0);
    //ellipse(cx,cy,range,range);
    for (int c=0;c<cons.length;c++) {
      if (cons[c]!=null) {
        //strokeWeight(250/(cons[c].d > 10 ? cons[c].d : 10));
        strokeWeight((cons[c].d - (range + 5)) / -20);
        line(cx,cy,cons[c].n.cx, cons[c].n.cy);
      }
    }
  }

  /*
  void drawinfections() {
    if (is_infected) {
      stroke(INFECTION);
      float nx, ny, dir;
      for (int c=0;c<cons.length;c++) {
        if (cons[c]!=null) {
          strokeWeight(((cons[c].d - (range + 5)) / -20) + 1);
          if (infect_stren < cons[c].d) {
            dir = atan2(cons[c].n.cy - cy, cons[c].n.cx - cx);
            nx = (infect_stren * cos(dir)) + cx;
            ny = (infect_stren * sin(dir)) + cy;
          }
          else {
            nx = cons[c].n.cx;
            ny = cons[c].n.cy;
            cons[c].n.is_infected = true;
          }
          line(cx,cy,nx,ny);
        }
      }
      infect_stren += INFECTRATE;
    }
  }
  */
  
  void drawme() {
    drawconnections();
    drawnode();
  }  
}

class NearNode {
  Node n;
  float d;
  NearNode (Node _n, float _d) {
    n=_n;
    d=_d;
  }
}

int MAXNEIGHBORS = 30;
class Node {
  float x,y,hw,cx,cy;
  float hitx, hity;
  float range;
  color fil;
  NearNode[] cons;
  Node (float _x, float _y, float _hw) {
    x=_x;
    y=_y;
    hw = _hw;
    cx = x + hw/2;
    cy = y + hw/2;
    setColor(false);
    range = 140;
    cons = new NearNode[MAXNEIGHBORS];
  }
  void setColor(boolean clicked) {
    if (clicked) {
      fil = color(255,100,100);
    }
    else
      fil = color(100);
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
  void setNearest(ArrayList nodes, int starting_at) {
    cons = new NearNode[MAXNEIGHBORS];
    float maxmin = 0;
    for (int n=starting_at;n<nodes.size();n++) {
      Node nod = (Node)nodes.get(n);
      float nd = nod.getDist(cx,cy);
      if (nd < range) {
        if (nod.addNeighbor(this, nd)) {
          addNeighbor(nod, nd);
        }
      }        
    }
  }  
  
  boolean addNeighbor(Node n, float d) {
    // Simple bubble sort to find nearest 4 neighbors.
    NearNode _temp;
    boolean isAdded = false;
    for (int c=0;c<cons.length;c++) {
      if (cons[c] == null) {
        cons[c] = new NearNode(n, d);
        return true;
      }
      else {
        if (d < cons[c].d) {
          _temp = cons[c];
          cons[c] = new NearNode(n, d);
          n = _temp.n;
          d = _temp.d;
          isAdded = true;
        }
      }
    }
    return isAdded;
  }
  
  void move(float nx, float ny) {
    x = nx - hitx;
    y = ny - hity;  
    cx = x + hw/2;
    cy = y + hw/2;
  }
  void drawme() {
    stroke(0);
    
    strokeWeight(1);
    noFill();
    //ellipse(cx,cy,range,range);
    for (int c=0;c<cons.length;c++) {
      if (cons[c]!=null) {
        //strokeWeight(250/(cons[c].d > 10 ? cons[c].d : 10));
        strokeWeight((cons[c].d - (range + 5)) / -20);
        line(cx,cy,cons[c].n.cx, cons[c].n.cy);
      }
    }
    
    strokeWeight(3);
    fill(fil);
    rect(x,y,hw,hw);
    
  }  
}

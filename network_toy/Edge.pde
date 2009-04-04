class Edge {
  // Start, Finish
  Node s, f;
  float len,range,infect_level;
  boolean is_infected;

  Edge (Node a, Node b, float _len) {
    s=a;
    f=b;
    len=_len;
    range=(height + width / 2) / 4;
    is_infected = false;
  }
  
  void drawedge() {
    noFill();
    stroke(0);
    strokeWeight((len - (range + 5)) / -20);
    line(s.cx, s.cy, f.cx, f.cy);
  }
  
  void update() {
    len=dist(s.cx,s.cy,f.cx,f.cy);
    if (is_infected) {
      float nx,ny;
      // current infection length as a percentage of `len`
      if (infect_level < 100) {
        float infect_stren = (len/100) * infect_level;
        float dir = atan2(f.cy - s.cy, f.cx - s.cx);
        nx = (infect_stren * cos(dir)) + s.cx;
        ny = (infect_stren * sin(dir)) + s.cy;
        infect_level += INFECTRATE;
      }
      else {
        nx = f.cx;
        ny = f.cy;  
      }
    }
  }
  
  void drawinfection() {
    if (is_infected) {}
  }
  void drawme() {
    drawedge();
    drawinfection();
  }
}

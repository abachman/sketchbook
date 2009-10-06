class Magnifier {
  int cx, cy;
  int r;
  
  Magnifier() {
    r = 70;
  }
  
  boolean covers(int px, int py) {
    return dist(cx, cy, px, py) < r;
  }
  
  void update(int mx, int my) {
    cx = mx;
    cy = my;
  }
  
}

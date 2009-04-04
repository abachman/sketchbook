class HoverTarget {
  float[][] points;
  color f, d;
  public HoverTarget()
  {
    f = color(250);
  }
  
  public HoverTarget(float[][] _points, color _f){
    points = _points; 
    f = _f;
    d = _f;
  }
  
  public boolean check(int x, int y) {
    return pixels[y * width + x] == f;
  }
}

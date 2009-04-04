class Wall {
  // A rect centered at (x,y)
  
  float l,r,t,b;
  float h,w;
  float x,y;
  
  // enclosing circle
  float rad;
  
  Wall(float px,float py,float ph, float pw) {
    x=px;
    y=py;
    h=ph;
    w=pw;
    l = x - (w/2);
    r = x + (w/2);
    t = y - (h/2);
    b = y + (h/2);
    rad = sqrt( (w/2)*(w/2) + (h/2)*(h/2) ) * 2;
  }
  
  void drawme() {
    fill(86,93,131);
    noStroke();
    rect(l,t,w,h);
    
    stroke(86,93,131);
    noFill();
    ellipse(x,y,rad,rad);
  }
  
}
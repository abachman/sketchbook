Square[][] s;

int BLOCKS = 10;

void setup() {
  size(640,480, P2D);
  
  int stepx = width / BLOCKS;
  int stepy = height / BLOCKS;
  
  int x = 0;
  int y = 0;
  
  s = new Square[10][10];
  
  for (int a=0; a < BLOCKS; a++) {
    for (int b=0; b < BLOCKS; b++) {
       s[a][b] = new Square(x + stepx/2, y + stepy/2, stepx);
       x += stepx;
    }
    y += stepy;
    x = 0;
  }
  
  //  s = new Square(width/2, height/2, 50);
}

void draw() {
  background(0);
    
  for (int a=0; a < BLOCKS; a++) {
    for (int b=0; b < BLOCKS; b++) {
      s[a][b].hover(mouseX, mouseY);
      s[a][b].drawme();       
    }
  }
}
  
class Square {
  float tx, ty, w, h, cx, cy;  
  boolean is_over;
  int col, mcol;
  float rot, mrot;
  
  Square(float _cx, float _cy, int hw) {
    mrot = rot = 0;
    mcol = col = 51;
    w = hw;
    h = hw;
    cx = _cx;
    cy = _cy;
    tx = -(w/2);
    ty = -(h/2);
  } 
  
  void hover(int x, int y) {
    if (x > cx-(w/2) && y > cy-(h/2) && x < cx+(w/2) && y < cy+(h/2))
      is_over = true;
    else
      is_over = false;
  }
  
  void drawme() {
    pushMatrix();
    stroke(255);
    translate(cx, cy);
    fill(col);
    rotate(rot);
    
    if (is_over) {
      if (col < 255) col += 3;
      if (rot < PI) rot += .08;
    }
    else {
      if (col > mcol) col--;
      if (rot > 0) rot -= .08;
    }

    rect(tx, ty, w, h);  
    popMatrix();
  }
}

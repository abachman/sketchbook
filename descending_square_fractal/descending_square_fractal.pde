SquareSpace ss;
float _size = 800;

void setup() {
  frameRate(1);
  size(_size, _size, P2D);
  background(0);
  noStroke();

  ss = new SquareSpace(0, 0, width);
}

float hw, hh;

void draw() {
  ss.update();
  ss.drawme();
}

class Square {
  float x, y, d;
  color c;
  Square(float _x, float _y, float _d, color _c) {
    x=_x; y=_y; d=_d; c=_c;
  }
  
  String identity() {
    return String.format("%s %s %s %s,%s,%s", x, y, d, red(c), green(c), blue(c)); 
  }

  void drawme() {
    fill(c);
    rect(x, y, d, d);
    // println("I'm drawing <" + identity() + ">");
  }
}



class SquareSpace {
  float x, y, d;
  Square[] squares;
  color[] cols;
  SquareSpace(float _x, float _y, float _d) {
    x=_x; y=_y; d=_d;
    float hd = d / 2.0;
    cols = new color[] { color(random(255)), color(random(255)) };
    squares = new Square[] {
      new Square(x, y, hd, pick()),
      new Square(x + hd, y, hd, pick()),
      new Square(x, y + hd, hd, pick()),
      new Square(x + hd, y + hd, hd, pick())
    };
  }

  color pick() {
    return cols[(int)random(2)];
  }

  void drawme() {
    for (int n=0; n < squares.length; n++) {
      squares[n].drawme();
    }
  }
}


class Circle {
  int x, y, r;

  Circle(int _x, int _y, int _r) {
    x = _x;
    y = _y;
    r = _r;
  }

  void draw() {
    noStroke();
    fill(random(2) > 1 ? 0 : 255);
    ellipse(x, y, 100, 100);
  }

  void connect(Circle other, int count) {
    stroke(map(count, 0, circles.size(), 0, 255), 0, 0);
    strokeWeight(map(dist(other.x, other.y, x, y), 0, width, 1, 40));
    line(other.x, other.y, x, y);
  }

  void label(float _x, float _y) {
    text(nf(x, 4) + nf(y, 4), _x, _y);
  }
}

ArrayList<Circle> circles;
Circle lcirc, circle;
int rStep;
boolean connect;
PFont mono;
int tx, ty;

void setup () {
  size(600, 400);
  circles = new ArrayList<Circle>();x
  rStep = 0;
  noStroke();
  mono = loadFont("Monaco-14.vlw");
  textFont(mono);
  tx = 10;
  ty = 10;
}

void draw() {
  rStep++;

  if (random(100) > 50) {
    circles.add(new Circle((int)random(width), (int)random(height), rStep));
    background(random(255), random(255), random(255));
    rStep = 0;

    if (circles.size() > 1) {
      connect = true;
      lcirc = circles.get(0);
    }

    /*
    for (int i=0; i < circles.size()-1; i++) {
      circle = circles.get(i);
      circle.draw();
    }

    if (connect) {
      for (int i=0; i < circles.size()-1; i++) {
        circle = circles.get(i);
        circle.connect(lcirc, i);
        lcirc = circle;
      }
    }
    */

    fill(255);
    for (int i=0; i < circles.size()-1; i++) {
      circle = circles.get(i);
      circle.label(tx + random(-4, 4), ty + random(-4, 4));

      ty += 24;

      if (ty > height) {
        tx += 68;
        ty = 10;
      }

      if (tx > width) {
        tx = 10;
        ty = 10;
      }
    }

    tx = 10;
    ty = 10;
  }


}

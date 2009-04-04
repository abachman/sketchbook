
class Point {
  float x,y;
  Point(float px, float py) {
    x=px;
    y=py;
  }
  void drawme() {
    fill(0);
    rect(x,y,2,2); 
  }
}

class Node {
  Node prev, next;
  Point p;
  Node (Point _p) {
    p = _p;
  }
}

class Stack { 
  Node top=null;
  int len;
  Stack() {
    len=0;
  }
  void push(Point p) {
    len++;
    Node n = new Node(p);
    if (top == null) {
      top = n;
      top.prev = null;
    }
    else {
      n.prev = top;
      top = n;
    }
  }
  Point pop() {
    if (top == null) return null;
    len--;
    Node temp = top;
    top = top.prev;
    return temp.p;
  }
}

ArrayList points = new ArrayList();
Stack points2 = new Stack();

size(200, 200);
background(255);
for (int h = 0; h < height; h += 10) {
  for (int w = 0; w < width; w += 10) {
    points.add(new Point(h,w));
    points2.push(new Point(h,w));
  }
}

println(points2.len);
int len = points2.len;
for (int i=0; i < len; i++) {
  //((Point)points.get(i)).drawme();
  points2.pop().drawme();
}
println(points2.len);

/**
 * popsquares - Adam Bachman
 * 
 * 12 June 2007
 */
 
//int barWidth = 5;
int side = 60;
int edge = 12; // squares per side
int h = side*edge, w = side*edge; 
int squarecount = edge * edge;
int[] hue = new int[200];

class Square {
  int r = 0;
  int g = 0;
  int b = 0;
  int x;
  int y;
  int side;
  boolean active = false;
  boolean hold = false;
  
  public Square (int _r, int _g, int _b, int _x, int _y, int _side) {
    setColor(_r, _g, _b);
    this.x = _x;
    this.y = _y;
    this.side = _side;
    this.draw_me();
  }
  
  public Square (int _x, int _y, int _side) {
    this.x = _x;
    this.y = _y;
    this.side = _side;
  }
  
  public void setColor(int _r, int _g, int _b) {
    this.r = _r;
    this.g = _g;
    this.b = _b;
  }
  
  public void draw_me() {
    fill(this.r, this.g, this.b);
    rect(this.x, this.y, this.side, this.side);
  }
  
  public boolean isinside(int _x, int _y) {
    if ((_x > x) && (_x <= x + side) &&
        (_y > y) && (_y <= y + side)) {
      return true;
    }
    else {
      return false;
    }
  }
}

class Node {
  /*
  Square top = null; 
  Square right = null;
  Square bottom = null;
  Square left = null;
  */
  Node next = null;
  Node prev = null;
  Square me = null;
  
  public Node(Square sqr) {
    me = sqr;
  }
}
  
class SquareList {
  Node head;
  Node tail;
  int len = 0;

  public SquareList() {
  }

  public SquareList(Square _root) {
    head = new Node(_root);
    tail = new Node(_root);
    len = 1;
  }

  public void append(Square sqr){
    Node _new = new Node(sqr);
    if (head == null) {
      head = _new;
      tail = _new;
    }
    else {
      _new.prev = tail;
      tail.next = _new;
      tail = _new;    
    }
    len++;
  }
  
  public void draw_all() {
    Node cur = head;
    while (cur != null) {
      cur.me.draw_me();
      cur = cur.next;
    }
  }
} 
    
Square[][] sqs = new Square[edge][edge];
SquareList squares = new SquareList();

void setup() 
{
  size(side*edge, side*edge, P2D);
  colorMode(RGB, 256);  
  noStroke();
  ellipseMode(CENTER);

  for (int x=0; x < (h / side); x++) {
    for (int y=0; y < (w / side); y++) {
      squares.append(new Square(side*x, side*y, side));
    }
  }
  squares.draw_all();

}

void draw() 
{
  Node cur = squares.head;
  while (cur != null) {
    Square s = cur.me;
    if (s.isinside(mouseX, mouseY)) {
      s.active = true;
      if (mousePressed) {
         s.setColor(255,255,255);
         s.hold = !s.hold;
      }
      else if (!s.hold) {
        s.setColor(200,200,200);
      }
      s.draw_me();
    }    
    else {
      if (!s.hold) {
        if (s.active && (s.r >=15 || s.r >=15 || s.r >=15)) {
          s.setColor(s.r-10,s.r-10,s.r-10);
        }
        else if (s.active) {
          s.setColor(0,0,0);
          s.active = false;
        }
      }
      s.draw_me();
    }
    cur = cur.next;
  }
}

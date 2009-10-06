/**
 * popsquares - Adam Bachman
 * 
 * 12 June 2007
 */
 
//int barWidth = 5;
int side = 40;
int edge = 20; // squares per side
int h = side*edge, w = side*edge; 
int squarecount = edge * edge;
int[] hue = new int[200];

class Square {
  int r = 0;
  int g = 0;
  int b = 0;
  int a = 100;
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
  
  public void setColor(int col) {
    this.r = col;
    this.g = col;
    this.b = col;
  }
  
  public void setColor(int _r, int _g, int _b) {
    this.r = _r;
    this.g = _g;
    this.b = _b;
    this.a = 100;
  }
    
  public void draw_me() {
    fill(this.r, this.g, this.b, this.a);
    rect(this.x, this.y, this.side, this.side);
  }
  
  public void update() {
     if (active && (r + b + g > 0)) {
       r -= r > 3 ? 4 : r;
       b -= b > 3 ? 4 : b;
       g -= g > 3 ? 4 : g;
     }
     else if (active) {
       active = false;
     }
     else {
       return;
     }
     draw_me();
  }
  
  public void fade() {
     if (active && a > 0) {
       a -= 5;
       draw_me();
     } 
     else if (active){
       active = false;
     }
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
      sqs[x][y] = new Square(side*x, side*y, side);
      sqs[x][y].draw_me();
      // squares.append(new Square(side*x, side*y, side));
    }
  }
  // squares.draw_all();

}

void draw() 
{
  for (int x=0; x < (h / side); x++) {
    for (int y=0; y < (w / side); y++) {
      sqs[x][y].update();
    }
  }
}

void mouseMoved() {
  Square s = sqs[mouseX / side][mouseY / side];
  s.setColor(200,200,200);
  s.draw_me();
  s.active = true;
}

int gridx = 3, gridy = 3;
int[][] grid = new int[][] {{0,1,0}, {1,0,1}, {0,1,0}};
void mousePressed() {
  explode(mouseX / side, mouseY / side, 0);
  explode(mouseX / side, mouseY / side, 1);
  explode(mouseX / side, mouseY / side, 2);
  explode(mouseX / side, mouseY / side, 3);
  /* 
  int x = mouseX / side + 1;
  int y = mouseY / side + 1;
  // (x-1, y) (x,y-1) (x+1,y) (x,y+1)
  
  for (int a=0;a < gridx;a++) {
    for (int b=0;b<gridy;b++) {
      if (grid[a][b] == 1 && x-a >= 0 && y-b>=0 && x-a < edge && y-b < edge) {
        sqs[x-a][y-b].setColor(150,150,200);
        sqs[x-a][y-b].draw_me();
        sqs[x-a][y-b].active = true;
      }
    }
  }
  */
}

void explode(int x, int y, int dir) {
  if (x >= edge || x < 0 || y >= edge || y < 0) return;
  switch (dir) {
    case 0: // top 
      y -= 1;
      break;
    case 1: // right 
      x += 1;
      break;
    case 2: // bottom 
      y += 1;
      break;
    case 3: // left 
      x -= 1;
      break;  
    default:
      return;
  }
  try {
    sqs[x][y].setColor(150,150,200);
    sqs[x][y].draw_me();
    sqs[x][y].active = true;
    //print(new int[] {x, y});
  }
  catch (Exception ex){
    println(ex.getMessage());
    print(new int[] {x, y});
  }
  explode(x, y, dir);
}

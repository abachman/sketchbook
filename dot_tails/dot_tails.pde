/**
 * popsquares - Adam Bachman
 * 
 * 12 June 2007
 */
 
class Node {
  Node next = null;
  Node prev = null;
  Object data = null;
  int _key;
  
  public Node(Object obj, int __key) {
    data = obj;
    _key = __key;
  }
}

class List {
  Node head = null;
  Node tail = null;
  int len = 0;
  
  public List() {
  }

  public List(Object obj) {
    Node _new = new Node(obj, millis());
    head = _new;
    tail = _new;
    len = 1;
  }

  public void append(Object obj){
    Node _new = new Node(obj, millis());
    if (head == null) {
      head = _new;
      tail = _new;
    }
    else if (head == tail) {
      head.next = _new;
      _new.prev = head;
      tail = _new;
    }
    else {
      _new.prev = tail;
      tail.next = _new;
      tail = _new;    
    }
    len++;
  }

  public void delete(int _key) {
    if (head._key == _key) {
      head = head.next;
      return;
    }
    Node cur = head;
    while (cur != null) {
      if (cur.next == null) break;
      if (cur.next._key == _key) {
        cur.next = cur.next.next;
        len--;
        return;
      }
      cur = cur.next; 
    }
  }
  
  public Object pop() {
    Object ob = tail.data;
    tail.prev.next = null;
    tail = tail.prev;
    return ob;   
  }
} 
    
void setup() 
{
  size(800,400, P2D);
  colorMode(HSB,256);
  noStroke();
  //stroke(255);
  ellipseMode(CENTER);
  background(0);
  smooth();
}

void draw() 
{
  background(0);
  update_ellipses();  
}

List els = new List();
int next_el = 0;
int b = 255;
int x, y;
int diam = 5;
int h = 128, s = 200;
int px = 0, py = 0;
void mouseMoved() {
//  diam = int(random(2,8));
  //int dx = px - mouseX;
  //int dy = py - mouseY;
  //if ((dx > 5 || dx < -5) && (dy > 5 || dy < -5)) {
    px = mouseX;
    py = mouseY;
    place_ellipse();
  //}
}

void place_ellipse() {
  int[] e =  new int[]{mouseX, mouseY, diam, b}; 
  fill(h, s, e[3]);
  //point(e[0],e[1]);
  ellipse(e[0],e[1], e[2], e[2]);
  els.append(e);
}

void update_ellipses() {
  Node el = els.head;
  while(el != null) {
    int[] e = (int[])el.data;
    if (e[3] <= 0) {
      els.delete(el._key);
    }
    else {
      e[3] -= 4;
    }
    fill(h, s, e[3]);
    //e[2] += 2;
    ellipse(e[0],e[1], e[2], e[2]);
    el = el.next;
  }
}
  

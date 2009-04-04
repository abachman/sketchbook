import java.util.*;

Network net;
int NODESIZE = 20;
int NODES = 50;
float INFECTRATE = 1.5;
Button infectbutton;
Wall w;
Wall[] obstacles;
Edge testedge;

void setup() {
  size(700,700);
  background(255);
  PFont f = loadFont("BitstreamVeraSerif-Roman-28.vlw");
  textFont(f, 28);
  smooth();

  infectbutton = new Button(10, height-20);
  net = new Network();
  net.generate(30);
  
  obstacles = new Wall[4];
  for (int o=0;o<obstacles.length;o++) {
    obstacles[o] = new Wall(random(50,width)-50, random(50,height)-50, 100, 100);
  }
  
  frameRate(24);
}

void draw() {
  background(255);
  if (mousePressed && GRABBEDNODE == null) {
    GRABBEDNODE = net.getClicked(mouseX, mouseY);
  }

  //testedge.update();
  //testedge.drawme();
  
  for (int o=0;o<obstacles.length;o++) {
    obstacles[o].drawme();
  }
  
  net.update();
  net.drawme();  
  infectbutton.drawme();
  
  //w.drawme();
}

void pointer(float x, float y, float ox, float oy) {
  x -= ox;
  y -= oy;
  float d, r = 30;
  d = atan2(y, x);
  line(ox, oy, r*cos(d)+ox,  r*sin(d)+oy);
}

void keyPressed() {
  if (key == ' ') {
    net = init_level(net);
  }
}

void mousePressed() {
  infectbutton.update(mouseX, mouseY);
}

Node GRABBEDNODE;
void mouseDragged() {
  if (GRABBEDNODE == null) {
    GRABBEDNODE = net.getClicked(mouseX, mouseY);
  }
  
  if (GRABBEDNODE != null) {
    GRABBEDNODE.move(mouseX, mouseY);
  }
}

void mouseReleased() {
  net.clearClicks();
  if (GRABBEDNODE != null) {
    GRABBEDNODE.clicked = false;
    GRABBEDNODE = null;  
  }
}

// Sample of a generated level
Network init_level(Network n) {
  n.init();
  
  Node s = new Node(15, 15, 30);
  s.is_mobile = false;
  n.nodes.add(s);
  
  float hw = 15;
  for (int m=0;m<5;m++) {
    n.nodes.add(new Node(random(hw, width)-hw,random(hw, height)-hw,hw));
  }
  
  Node f = new Node(width-30, height-30, 30);
  f.is_mobile = false;
  n.nodes.add(f);
  n.initConnections();
  return n;
}

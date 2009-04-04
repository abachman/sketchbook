Network net;
int NODESIZE = 20;
int NODES = 20;

void setup() {
  size(400,400);
  background(255);
  PFont f = loadFont("BitstreamVeraSerif-Roman-28.vlw");
  textFont(f, 28);
  smooth();

  net = new Network();
  net.generate(20);
  frameRate(24);
}

void draw() {
  background(255);
  if (mousePressed && GRABBEDNODE == null) {
    // net.doClick(mouseX, mouseY);
    GRABBEDNODE = net.getClicked(mouseX, mouseY);
  }
  net.update();
  net.drawme();  
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
    GRABBEDNODE.setColor(false);
    GRABBEDNODE = null;  
  }
}

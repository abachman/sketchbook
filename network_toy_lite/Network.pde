class Network {
  ArrayList nodes;
  boolean moving;
  Network() {
    nodes = new ArrayList();
  }  
  void add(Node n) {
    nodes.add(n);  
  }
  Node head() {
    return (Node)nodes.get(0);
  }
  void generate(int node_count) {
    nodes = new ArrayList();

    for (int n=0;n<node_count;n++) {
      add(new Node(random(width-NODESIZE),random(height-NODESIZE),NODESIZE));
    }
    moving = true;
    update();    
    moving = false;
  }
  Node getClicked(float x, float y) {
    for (int i=0;i<nodes.size();i++) {
      Node n = (Node)nodes.get(i);
      if (n.isHitting(x,y)) {
        n.setColor(true);
        moving = true;
        return n;
      }
    }
    return null;
  }
  void clearClicks() {
    moving = false;
    for (int i=0;i<nodes.size();i++) {
      ((Node)nodes.get(i)).setColor(false);
    } 
  }
  void doClick(float x, float y) {
    Node n = getClicked(x,y);
    if (n != null) n.setColor(true);
  }
  void update() {
    if (moving) {
      text("updating...",15,15);
      for (int i=0;i<nodes.size();i++) {
        ((Node)nodes.get(i)).setNearest(nodes, i+1);
      }
    }
  }
  void drawme() {
    for (int i=0;i<nodes.size();i++) {
      ((Node)nodes.get(i)).drawme();
    }
  }  
}

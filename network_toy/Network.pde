// A collection of nodes
class Network {
  ArrayList nodes;
  boolean moving;
  
  Network() {
    init();
  }  
  
  void init() {
    nodes = new ArrayList();
  }
  
  void initConnections() {
    for (int n=0;n<nodes.size();n++) {
      ((Node)nodes.get(n)).clicked = true;
    }
    update();    
    clearClicks();
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
      //((Node)nodes.get(n)).clicked = true;
    }
    initConnections();
    //update();    
    //clearClicks();
  }
  
  
  
  ////////////////
  // Movement
  Node getClicked(float x, float y) {
    for (int i=0;i<nodes.size();i++) {
      Node n = (Node)nodes.get(i);
      if (n.isHitting(x,y)) {
        n.clicked = true;
        if (infectbutton.state) {
          text("infecting " + n, height-10, width-100);
          n.is_infected = true;
        }
        return n;
      }
    }
    return null;
  }
  
  void clearClicks() {
    for (int i=0;i<nodes.size();i++) {
      ((Node)nodes.get(i)).clicked = false;
    } 
  }
  // END Movement
  /////////////////
  
  // Edge Methods
  void addEdge(Node a, Node b) {
    
  }
  
  void update() {
    for (int i=0;i<nodes.size();i++) {
      Node nod = (Node)nodes.get(i);
      if (nod.clicked) {
        text("updating...",15,15);
        nod.update(this);
      }
    }
  }

  void update(Node n) {
    if (moving) {
      for (int i=0;i<nodes.size();i++) {
        //((Node)nodes.get(i)).setNearest(nodes, i);
      }
    }
  }
  
  void drawme() {
    stroke(0);
    for (int i=0;i<nodes.size();i++) {
      ((Node)nodes.get(i)).drawconnections();
    }
/*     for (int i=0;i<nodes.size();i++) {
     ((Node)nodes.get(i)).drawinfections();
    } */
    for (int i=0;i<nodes.size();i++) {
      ((Node)nodes.get(i)).drawnode();
    }
    noFill();
  }  
}
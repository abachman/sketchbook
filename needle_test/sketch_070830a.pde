Needle[] nds = new Needle[10];
void setup() {
  size(300,300);
  background(0);
  smooth();
  strokeWeight(3);
  for (int i=0;i<nds.length;i++){
    nds[i] = new Needle(random(0,TWO_PI));
    println("d: " + nds[i].dir + ", s: " + nds[i].stren);
    println("n: " + nds[i].nx + ", " + nds[i].ny);
    println("o: " + nds[i].ox + ", " + nds[i].oy);
  }
}

void draw() {  
  background(0);
  stroke(255);
  for (int i=0;i<nds.length;i++){
    nds[i].update();
    nds[i].drawme();
  }
}

class Needle {
  float ox, oy, nx, ny;
  float dir, stren;
  float fact;
  Needle (float d) {
    ox = width/2;
    oy = height/2;
    stren = height/2;
    dir = d;
    nx = (stren * cos(dir)) + ox;
    ny = (stren * sin(dir)) + oy;
    fact = 30;
  } 
  void update() {
    if (fact > .1) fact -= .05;
  }
  void drawme() {
    line(ox,oy,(nx+ox)/1,(ny+oy)/1);
  }
}

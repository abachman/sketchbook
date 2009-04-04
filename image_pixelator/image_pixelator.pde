PImage cur;
int x, y, xstep, ystep, big_step;
int step = 2;
int c_step = 40;
int count = 0;
int counter = 1;
boolean[] keys = new boolean[255];
color c;
PFont fon;
int[] rmap;

void setup() {
  size(640, 480);
  // 640 x 480 image
  cur = loadImage("3175092697_2f98d3c1f7_b.jpg");
  fon = loadFont("DejaVuSans-10.vlw");
  textFont(fon, 10);
  //noLoop();
  noStroke();
  frameRate(20);
  xstep = width / 20;
  ystep = height / 32;
  rmap = new int[width];
  for (int i = 0; i < rmap.length; i++) rmap[i] = i;
  shuffle(rmap);
}

void shuffle(int[] c){
  int swap, temp;
  int len = c.length;
  for (int i = 0; i < len; i++) {
    swap = int(random(len));
    temp = c[i];
    c[i] = c[swap];
    c[swap] = temp;
  }
} 

void draw() {
  boxScan();
  //lineScan();
  //boxify();

  // Show current scanline when spacebar is pressed
  if (keys[32]) {
    image(cur, 0, 0);
    stroke(255, 0, 0);
    line(0, count, width, count);
    noStroke();
  }
}

int b = 0;
void boxScan() {
  // Loop through every `c_step` pixel.
  b = 0;
  // get line
  if (count == height || count < 0) {
    counter = count < 0 ? 1 : -1;
    count = count < 0 ? 1 : height - 1;
  }  
  count += counter;
 
  // draw
  x = 0;
  while (x < cur.width) {
    y = 0;
    while (y < cur.height) {
      fill(cur.get(rmap[b], count));
      rect(x, y, xstep, ystep);
       y+= ystep;
       b += 1;
    }
    x+=xstep;
  }
  if (count == height || count < 0) {
    counter = count < 0 ? 1 : -1;
    count = count < 0 ? 1 : height - 1;
  }  
  count += counter;
}

void t(color c, String m, int x, int y){
  fill(c);
  text(m, x, y);
}
void t(color c, int m, int x, int y){
  fill(c);
  text(m, x, y);
}
  
void lineScan() {
  // Horizontal Line Scanning
  if (count == height || count < 0) {
    counter = count < 0 ? 1 : -1;
    count = count < 0 ? 1 : height - 1;
  }  
  count += counter;
  
  for (int p = 0; p < width; p++) {
    stroke(cur.get(p, count));
    line(p,0,p,height);
  }
}

void boxify() {
  // Pick n random piexels and draw them on screen. 
  // Vary alpha by mouseY location.
  int n = 50;
  float alph = map(mouseY, 0, height, 0, 255); 
  for (int i = 0; i < n; i++) { 
    x = int(random(cur.width));
    y = int(random(cur.height));
    c = cur.get(x, y);
    fill(c, alph);
    rect(x, y, 10, 10);  
  }
}

void keyPressed() {
  if (key > 255) return;
  keys[key] = true;
}
void keyReleased(){
  if (key > 255) return;
  keys[key] = false; 
}

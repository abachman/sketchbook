int x, y, xstep, ystep, big_step;
//int step = 2;
int cstep = 40;
int count = 0;
int counter = cstep;
int alph = 0;
int astep;
boolean[] keys = new boolean[255];
// color c;
PImage cur;
PFont fon;
int[] rmap;

void setup() {
  size(640, 480, P2D);
  background(0);
  // 640 x 480 image
  cur = loadImage("3175092697_2f98d3c1f7_b.jpg");
  fon = loadFont("DejaVuSans-10.vlw");
  textFont(fon, 10);
  //noLoop();
  noStroke();
  frameRate(30);
  xstep = width / 20;
  ystep = height / 32;
  astep = 255 / 15;
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

  // Show current scanline when spacebar is pressed
  if (keys[32]) {
    image(cur, 0, 0);
    stroke(255, 0, 0);
    line(0, count, width, count);
    noStroke();
    t(color(255), alph, 10, 10);
  }
}

int b = 0;
void boxScan() {
  // Loop through every `c_step` pixel.
  b = 0;
  // get line
  if (count >= height || count <= 0) {
    counter = count < 0 ? cstep : -cstep;
    count = count < 0 ? 1 : height - 1;
  }  
  
  if (alph >= 255) {
    alph = 0; 
    shuffle(rmap);    
    count += counter;
  }
 
  // draw
  x = 0;
  while (x < cur.width) {
    y = 0;
    while (y < cur.height) {
      fill(cur.get(rmap[b], count), alph);
      rect(x, y, xstep, ystep);
       y+= ystep;
       b += 1;
    }
    x+=xstep;
  }

  alph += astep;
}


void t(color c, String m, int x, int y){
  fill(c);
  text(m, x, y);
}
void t(color c, int m, int x, int y){
  fill(c);
  text(m, x, y);
}
void keyPressed() {
  if (key > 255) return;
  keys[key] = true;
}
void keyReleased(){
  if (key > 255) return;
  keys[key] = false; 
}


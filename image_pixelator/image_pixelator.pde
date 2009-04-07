/** Mar 2009
 * Display each line of a given image as a series of colored boxes (pixels) spread
 * randomly over the canvas.
**/
PImage cur;
int x, y, xstep, ystep, c_xstep, c_ystep;
int step = 2;       
int c_step = 40;
int count = 0;
int counter = 1;
boolean[] keys = new boolean[255];
color c;
PFont fon;
int[] rmap;


void setup() {
  size(1600, 1200);
  // 640 x 480 image
  cur = loadImage("3175092697_2f98d3c1f7_b.jpg");
  fon = loadFont("DejaVuSans-10.vlw");
  textFont(fon, 10);
  //noLoop();
  noStroke();
  frameRate(10);
  // Image split
  xstep = cur.width / 20; 
  ystep = cur.height / 32;
  // Canvas split
  c_xstep = width / 20;
  c_ystep = height / 32;
  
  // Row map, an array of integers representing points on a horizontal
  // line across the image. This is used to choose pixels to sample during
  // pixel drawing.
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
  }
  if (keys[97]) {
    // halt, screen grab, quit
    noLoop();
    saveFrame("grab.jpg"); 
    exit();
  }
}

int b = 0;
void boxScan() {
  // Loop through every `c_step` pixel.
  b = 0;

 
  // draw
  x = 0;
  while (x < width) {
    y = 0;
    while (y < height) {
      fill(cur.get(rmap[b], count));
      rect(x, y, c_xstep, c_ystep);
      y+= c_ystep;
      b += 1;
    }
    x+=c_xstep;
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
  
void keyPressed() {
  if (key > 255) return;
  keys[key] = true;
  t(color(200,200,200), key, 10, 10);
}
void keyReleased() {
  if (key > 255) return;
  keys[key] = false; 
}

int w, h, c, r,
    count = 0, 
    step = 16;

void setup() {
  size(600, 600);
  strokeCap(SQUARE);
  w = width; h = height;
  background(128);
  // frameRate(40);
  c = 0; r = -(step / 2);
}

boolean alt_r=false, alt_c=true;
void draw() {
  if (alt_c) {
    vstripe(c, r); 
    hstripe(c, r); 
  } else { 
    hstripe(c, r); 
    vstripe(c, r); 
  }

  // split the columns / rows
  c += step;
  alt_c = !alt_c;

  // end of row
  if (c >= w) { 
    c = 0; 
    r += step; 
    alt_c = alt_r; 
    alt_r = !alt_r;
  }

  if (r >= h) { 
    // just stop
    noLoop();
  }
}

void keyPressed() {
  noLoop();
}

// solid 
void vstripe(int x) {
  stroke(0); strokeWeight(10);
  line(x, 0, x, h);
  stroke(255); strokeWeight(6);
  line(x, 0, x, h);
}

void hstripe(int y) {
  stroke(0); strokeWeight(10);
  line(0, y, w, y);
  stroke(255); strokeWeight(6);
  line(0, y, w, y);
}

// segmented crossings centered at (x, y)
void vstripe(int x, int y) {
  int t = y - step/2,
      b = y + step/2;
  stroke(0); strokeWeight(10);
  line(x, t, x, b);
  stroke(255); strokeWeight(6);
  line(x, t, x, b);
}

void hstripe(int x, int y) {
  int l = x - step/2,
      r = x + step/2;
  stroke(0); strokeWeight(10);
  line(l, y, r, y);
  stroke(255); strokeWeight(6);
  line(l, y, r, y);
}


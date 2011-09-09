// v1 - http://dl.dropbox.com/u/3147390/pics/2011-09-08-20-39-25_screen_shot_2011-09-08_at_8.31.49_pm.png
int w, h, 
    count = 0, 
    step = 30;
void setup() {
  size(600, 600);
  w = width; h = height;
  background(128);
}

void draw() {
  for (int c=0; c < w; c += step) { vstripe(c); hstripe(c); }
}

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


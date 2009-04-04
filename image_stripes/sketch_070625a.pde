color[] colors;
PImage img;

void setup() {
  size(128, 128);
  img = loadImage("ev.jpg");
  colors = new color[img.width];
  background(0);
  //noStroke();
  smooth();
}

int row = 0;
int dir = 0;
void draw() {
  get_colors(row, dir);
  draw_lines();
  row++; 
  dir = (int)(row / 128) % 2;
}
void get_colors(int r, int dir) {
  switch (dir) {
  case 0:
    for (int x = 0; x < img.width; x++) {
      colors[x] = img.pixels[x + (img.width * (r % img.height))];
    }  
    break;
  case 1:
    for (int x = 0; x < img.width; x++) {
      colors[x] = img.pixels[x + (img.width * ((img.height - 1) - (r % img.height)))];
      //colors[x] = img.pixels[x + (img.height * (r % img.height)) ];
    }  
    break;
  }
}

void draw_lines() {
    for (int col = 0; col < width; col++) {
      stroke(colors[col % img.width]);
      line(col, 0, col, 128);
    }
}

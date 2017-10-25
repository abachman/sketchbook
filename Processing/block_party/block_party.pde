/// THIS IS BLOCK PARTY

int step;
int r = 16;
int grid[][] = new int[10][10];

int cx, cy;

void scramble() {
  for (int y = 0; y < 10; y++) {
    for (int x = 0; x < 10; x++) {
      grid[y][x] = 0;
      if (random(1.0) < 0.2) continue;
      // rect(10 + step * x, 10 + step * y, step - 10, step - 10);
      grid[y][x] = 1;
    }
  }
  
  grid[0][0] = 1;
}

void setup() { 
  size(600, 600);
  noStroke();
  scramble();
  step = (width - 20) / 10;
  
  cx = 10 + step /2;
  cy = 10 + step /2;
}

void draw() {
  background(51);  
  fill(255);
  
  for (int y = 0; y < 10; y++) {
    for (int x = 0; x < 10; x++) {
      if (grid[y][x] == 1) {
        rect(10 + step * x, 10 + step * y, step - 10, step - 10);
      }
    }
  }
  
  fill(255, 100, 100);
  ellipseMode(CENTER);
  ellipse(cx, cy, r, r);    
}

void keyPressed() {
  if (keyCode == 32) {
    scramble();
  }
  
  if (keyCode == LEFT) {
    cx -= step;
    if (cx < 0) {
      cx = 10 + step / 2;
    }
  } else if (keyCode == RIGHT) {
    cx += step;
    if (cx > width) {
      cx = width - step / 2 - 10;
    }
  } else if (keyCode == DOWN) {
    cy += step;
    if (cy > height) {
      cy = height - step / 2 - 10;
    }
  } else if (keyCode == UP) {
    cy -= step;

    if (cy < 0) {
      cy = 10 + step / 2;
    }
  }
  
}
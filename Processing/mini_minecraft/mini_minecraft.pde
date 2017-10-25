// mini-minecraft

void setup() { size(8, 8); background(0); noStroke(); }

void draw() {
  /* 
  fill(0, 10);
  rect(0, 0, width, height);
  */
  
  background(0);
  
  if (mousePressed || keyPressed) {
    fill(0xA4, 0x7A, 0x4B);
    rect(0, 0, width, height);
    fill(0x5C, 0xB8, 0x5C);
    rect(0, 0, width, height / 2 - height / 4);    
    noLoop();
  }
}
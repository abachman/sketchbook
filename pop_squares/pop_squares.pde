int edgex = 4, edgey = 4;
int sidex, sidey;

void setup() {
  size(400,400);
  background(0);
  frameRate(30);
  //smooth();
  noStroke();
  colorMode(HSB);
  sidex = width / edgex;
  sidey = height / edgey;

  for (int x=0; x < edgex; x++) {
    for (int y=0; y < edgey; y++) {
      fill(0);
      rect(x * sidex, y * sidey, sidex, sidey);
    }
  }
}

void draw()
{
  // Create an alpha blended background
  fill(0, 10);
  rect(0,0,width,height);
  for (int x=0; x < edgex; x++) {
    for (int y=0; y < edgey; y++) {
      if (random(0,1.02) > 1) {
        fill(238,82,int(random(100,200)));
        rect(x * sidex, y * sidey, sidex, sidey);
      }
    }
  }

}

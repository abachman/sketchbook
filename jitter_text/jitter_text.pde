PFont fon;

String word;

float d;
float colr;

void setup() {
  size(800, 200);
  
  word = "";
  fon = loadFont("futura.vlw");
  textFont(fon);
  d = 0;
}

void draw() {
  background(0);
  d = map(mouseY, 0, height, 0, 32);
  colr = map(mouseX, 0, width, 0, 255);
  
  float wordLeft = width / 2 - (textWidth(word)/2);
  float wordTop  = height / 2 + (textAscent()/2);
  
  for (int i=0; i < 255; i += 16) {
    fill(colr, 50);
    text(word, wordLeft + random(-d, d), wordTop + random(-d, d));
  }
  fill(colr);
  text(word, wordLeft, wordTop);
}

void keyPressed() {
  if (key == ' ') {
    word = "";
  } else {
    word += key;
  }
}

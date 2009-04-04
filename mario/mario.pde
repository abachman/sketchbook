color[] colors;
String[] pic;
int rows;
int cols;
float h, w;

void setup() {
  size(500,500); 
  background(0);
  // 0 - background
  // 1 - red
  // 2 - yellow 
  // 3 - purple
  // 4 - blue
  colors = new color[] {
    color(0),
    color(254,0,0),
    color(255,255,0),
    color(1,0,128),
    color(51,102,255)
  };

  pic = new String[] {
    "00011111100000",
    "00111111111000",
    "00333223200000",
    "03232223222000",
    "03233222322200",
    "00322223333000",
    "00022222220000",
    "00044144400000",
    "00444144144400",
    "04444111144440",
    "02241011014220",
    "02221111112220",
    "02211111111220",
    "00011100111000",
    "00444000044400",
    "04444000044440"
  };
  
  rows = 16;
  cols = 14;
  
  h = height / (float)rows;
  w = width / (float)cols;
  
  noLoop();
  noStroke();
}

void draw() {
  //background(0);
  for (int row=0; row<pic.length; row++) {
    for (int col=0; col<pic[row].length(); col++) {
      fill(colors[Integer.parseInt(pic[row].substring(col,col+1))]);
      rect(col * h, row * w, h, w);
    }
  }
}



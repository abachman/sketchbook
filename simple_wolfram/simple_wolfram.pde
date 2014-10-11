int WIDTH = 513;
int RULESET = 122;

////////// 1 dimensional cellular automata

int row[], next_row[];
int y;
int TRUTH = 1;
color black = color(0);
color white = color(255);

void setup() {
  size(WIDTH, WIDTH);
  colorMode(HSB, 255);
  noStroke();

  row = new int[width];
  next_row = new int[width];

  randomize_row(); 
  y = 0;
  background(0);
}
 
void randomize_row() {
  // start row with noise
  for (int x=0; x < width; x++) {
    // noise
    row[x] = floor(random(0, 2)) == 1 ? TRUTH : 0;
  }
}


int get_int_from_bits(int a, int b, int c) {
  return (a * 4) + (b * 2) + c;
}


int apply_ruleset(int[] r, int i) {
  int a, b, c;
  
  if (i == 0) {
    a = width - 1;
    b = i;
    c = i + 1;
  } else if (i == width - 1) {
    a = i - 1;
    b = i;
    c = 0;
  } else {
    a = i - 1;
    b = i;
    c = i + 1;
  }

  // convert indecies to values
  a = r[a];
  b = r[b];
  c = r[c];

  int rule_pattern = get_int_from_bits(a, b, c);

  int result = (RULESET & int(pow(2, rule_pattern)));

  // increment by truth value or decrement by 1
  return result >= 1 ? 1 : 0;
}

void draw() {
  // loop to draw and evaluate

  /// DRAW
  
  for (int x=0; x < WIDTH; x++) {
    // draw each pixel on one line
    set(x, y, row[x] == 1 ? white : black);
  }
  
  /// UPDATE
 
  // generate next generation
  for (int x=0; x < WIDTH; x++) {
    next_row[x] = apply_ruleset(row, x);
  }

  // replace current gen with updated gen
  for (int x=0; x < WIDTH; x++) {
    row[x] = next_row[x];
  }

  // step down
  y = (y + 1);
  
  if (y == height) {
    randomize_row();
    y = 0;
  }
}


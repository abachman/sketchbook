int WIDTH = 513;
int RULESET = 90;

////////// 1 dimensional cellular automata

int row[], prev_row[], next_row[];
int y;
int TRUE_VALUE = 1;
color black = color(0);

int color_wheel;
color white_is_now;

int ruleset;

void setup() {
  size(WIDTH, WIDTH);
  colorMode(HSB, 255);
  noStroke();

  row = new int[width];
  next_row = new int[width];

  randomize_row(); 
  y = 0;
  color_wheel = 0;
  white_is_now = color(255);
  background(0);
}

void increment_white() {
  color_wheel  = (color_wheel + 1) % 256;
  white_is_now = color(color_wheel, 255, 255);
}

void randomize_row() {
  // start row with noise
  for (int x=0; x < width; x++) {
    // noise
    row[x] = floor(random(0, 2)) == 1 ? TRUE_VALUE : 0;
  }

  if (RULESET == -1) {
    ruleset = (ruleset + 1) % 256;
  } else {
    ruleset = RULESET;
  }

  rows_since_random = 0;
}

int a, b, c;

int apply_ruleset(int[] r, int i) {
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
  a = (r[a] >= TRUE_VALUE) ? 1 : 0;
  b = (r[b] >= TRUE_VALUE) ? 1 : 0;
  c = (r[c] >= TRUE_VALUE) ? 1 : 0;

  int rule_pattern = get_int_from_bits(a, b, c);

  int result = (ruleset & int(pow(2, rule_pattern)));

  // increment by truth value or decrement by 1
  return result >= 1 ?
    TRUE_VALUE : 
    (r[i] > 0 ? r[i] - 2 : 0);
}

int get_int_from_bits(int a, int b, int c) {
  return (a * 4) + (b * 2) + c;
}

int rows_since_random = 0;

color color_for_value(int v) {
  // color fade when TRUE_VALUE is > 1
  // return color(map(v, 0, TRUE_VALUE, 0, 255));
  // color scroll
  return v >= TRUE_VALUE ? white_is_now : color(map(v, 0, TRUE_VALUE, 0, 255));
}

void draw() {
  // loop to draw and evaluate
  boolean all_0 = true;
  boolean all_1 = true;

  int ox = 0, oy = 0;
  int w = WIDTH / 16, h = WIDTH / 16;
  
  for (int x=0; x < width; x++) {
    // draw each pixel on one line
    set(x, y, color_for_value(row[x]));
  }
 
  // generate
  for (int x=0; x < WIDTH; x++) {
    next_row[x] = apply_ruleset(row, x);
  }
  // exit();
  rows_since_random += 1;

  for (int x=0; x < width; x++) {
    // set row == next row
    row[x] = next_row[x];
  }

  y = (y + 1);
  increment_white();

  if (y == height) {
    // saveFrame("ruleset-" + nf(ruleset, 3) + ".png");
    randomize_row();
    y = 0;
  }
}

void keyPressed() {
  // y = 0;
  randomize_row();
}


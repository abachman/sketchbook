int WIDTH = 1600;
int HEIGHT = 600;
int RULESET = 105; // 0 - 255
boolean FADE = false;
int STEP = 2;
boolean PIC = true;

////////// 1 dimensional cellular automata

int row[], next_row[];
int y;
int TRUTH = 1;
color dead_color = color(0, 0, 0);
color live_color = color(45, 45, 45);

void setup() {
  size(WIDTH, HEIGHT);
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

int co=50;
int dc=2;

void advance_color() {
  co += dc;
  
  if (co >= 255 || co <= 50) {
    if (co > 255) co = 255;
    else if (co < 50) co = 50;
    
    dc = -dc;
  }
  
  live_color = color(co, co % 180, co % 253);
}

color choose_fill(boolean is_alive, int x, int y) {
  color argb = is_alive ? live_color : dead_color;
  
  if (is_alive) {
    int r = (argb >> 16) & 0xFF;  // Faster way of getting red(argb)
    int g = (argb >> 8) & 0xFF;   // Faster way of getting green(argb)
    int b = argb & 0xFF;          // Faster way of getting blue(argb)
  
    return color((r + x) % 255, (g + y) % 255, b);
  } else {
    return argb;
  }
}

void draw() {
  // loop to draw and evaluate

  /// DRAW
  
  for (int x=0; x < WIDTH; x++) {
    // draw each pixel on one line
    fill(choose_fill(row[x] == 1, x, y), FADE ? 50 : 255);
    
    rect(x * STEP, y, STEP, STEP);
    
    if (x * STEP > width) break;
    
    // set(x, y, row[x] == 1 ? live_color : dead_color);
  }

  advance_color();
  
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
  y = (y + STEP);
  
  if (y >= height) {
    noLoop();
    if (PIC) saveFrame("background-" + nf(RULESET, 3) + ".png");
    randomize_row();
    y = 0;
  }
}


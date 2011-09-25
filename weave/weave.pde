// Maybe maze drawing offers a clue?

int w, h, c, r,
    count = 0, 
    cell_height, cell_width;

final int step  = 16,
          steps = 30;

class World {
  HashMap cells;
  World(int w, int h, int step) {
    // gridworld
    cells = new HashMap(w * h);

    for (int y=0; y <= h; y++) {
      for (int x=0; x <= w; x++) {
        Cell c = new Cell(x, y, step);
        cells.put(c.id, c);
      }
    }
  }

  void draw() {
    Iterator i = cells.entrySet().iterator();  // Get an iterator

    while (i.hasNext()) {
      Cell c = (Cell)((Map.Entry)i.next()).getValue();
      c.line_type = (int)random(2) + 2;
      c.draw();
    }
  }
}

final int EW=0, NS=1, EW_NS=2, NS_EW=3;

// a cell knows its neighbors
class Cell { 
  int x, y, grid_x, grid_y, step, line_type; 
  String id;
  boolean n, s, e, w;
  World myworld;

  Cell(int _x, int _y, int _s) {
    // cell coords in grid
    grid_x = _x; grid_y = _y; 

    step = _s;

    x = grid_x * step;
    y = grid_y * step;

    id = String.format("%s,%s", x, y);
  }

  void draw() { 
    switch (line_type) {
      case EW:
        hstripe(x, y);
        break;
      case NS:
        vstripe(x, y);
        break;
      case EW_NS:
        vstripe(x, y);
        hstripe(x, y);
        break;
      case NS_EW:
        hstripe(x, y);
        vstripe(x, y);
        break;
    }
  }
}

World world;

void setup() {
  size(step * steps, step * steps);
  strokeCap(SQUARE);
  w = width; h = height;
  background(128);
  c = 0; r = -(step / 2);

  cell_width = w / step;
  cell_height = h / step;

  // initialize world
  world = new World(cell_width, cell_height, step);

  // initialize cells
}

boolean alt_r=false, alt_c=true;
void draw() {
  // cover(0);
  
  world.draw();

  noLoop();
}

void keyPressed() {
  noLoop();
}

// cover with standard weave
void cover(int r) {
  c = 0;
  while (c < w + step) {
    if (alt_c) {
      vstripe(c, r); 
      hstripe(c, r); 
    } else { 
      hstripe(c, r); 
      vstripe(c, r); 
    }

    c += step;
    alt_c = !alt_c;
  }
  alt_c = alt_r; 
  alt_r = !alt_r;

  if (r < h + step) { 
    cover(r + step);
  }
}

// segmented crossings centered at (x, y)
void vstripe(int x, int y) {
  int t = y - step/2,
      b = y + step/2;
  stroke(0); strokeWeight(10);
  line(x, t, x, b);
  stroke(255); strokeWeight(6);
  line(x, t, x, b);
}

void hstripe(int x, int y) {
  int l = x - step/2,
      r = x + step/2;
  stroke(0); strokeWeight(10);
  line(l, y, r, y);
  stroke(255); strokeWeight(6);
  line(l, y, r, y);
}


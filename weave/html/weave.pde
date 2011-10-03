// Maybe maze drawing offers a clue?

int w, h, c, r, clr,
    count = 0,
    cell_height, cell_width;

// cell drawing types
final int Z=0, EW=1, NS=2, EW_NS=3, NS_EW=4;

final int[][] WORD = {
  {Z,EW_NS,EW_NS,EW_NS,Z,EW_NS,Z,Z    ,Z    ,EW_NS,Z,Z    ,Z,EW_NS,Z    ,EW_NS,Z    ,EW_NS,Z,Z    ,Z}    ,
  {Z,EW_NS,EW_NS,EW_NS,Z,EW_NS,Z,EW_NS,EW_NS,EW_NS,Z,EW_NS,Z,EW_NS,Z    ,EW_NS,Z    ,EW_NS,Z,EW_NS,EW_NS},
  {Z,EW_NS,Z    ,EW_NS,Z,EW_NS,Z,Z    ,Z    ,EW_NS,Z,EW_NS,Z,EW_NS,Z    ,EW_NS,Z    ,EW_NS,Z,Z    ,Z}    ,
  {Z,EW_NS,Z    ,EW_NS,Z,EW_NS,Z,EW_NS,EW_NS,EW_NS,Z,Z    ,Z,EW_NS,Z    ,EW_NS,Z    ,EW_NS,Z,EW_NS,EW_NS},
  {Z,Z    ,Z    ,Z    ,Z,EW_NS,Z,Z    ,Z    ,EW_NS,Z,EW_NS,Z,EW_NS,EW_NS,Z    ,EW_NS,EW_NS,Z,Z    ,Z}
};

final int step  = 16,
          steps = 30;

class World {
  HashMap cells;
  int h, w, step;

  // world w and h are in grid steps, step is pixels.
  World(int _w, int _h, int _step) {
    step = _step;
    w = _w; h = _h;

    // gridworld
    cells = new HashMap(w * h);

    Cell c;
    for (int y=0; y <= h; y++) {
      for (int x=0; x <= w; x++) {
        c = new Cell(x, y, step);
        cells.put(c.id, c);
      }
    }
  }

  // pixel location of cell at grid step
  int[] cell_at(int x, int y) {
    return new int[] {x * step, y * step};
  }

  String cell_id(int x, int y) {
    int[] point = cell_at(x, y);
    int _x = point[0],
        _y = point[1];

    return  _x + "," + _y;
  }

  // draw word starting at (x, y)
  void write(int x, int y, int[][] word) {
    Cell c;
    for (int row=0; row < word.length; row++) {
      for (int col=0; col < word[0].length; col++) {
        if (y + row < h && x + col < w) {
          c = (Cell) cells.get( cell_id(col + x, row + y) );
          c.line_type = word[row][col];
        }
      }
    }
  }

  void draw() {
    Iterator i = cells.entrySet().iterator();  // Get an iterator

    while (i.hasNext()) {
      Cell c = (Cell)((Map.Entry)i.next()).getValue();
      c.draw();
    }
  }
}

final int NORTH=1,
          SOUTH=2,
          EAST=4,
          WEST=8;

class Cell {
  int x, y, grid_x, grid_y, step, line_type;
  String id;
  int dir;

  boolean n, s, e, w;
  World myworld;

  // set default line type
  Cell(int _x, int _y, int _s) {
    line_type = EW_NS;

    dir = EAST & SOUTH & NORTH & WEST;

    // dupe
    grid_x = _x; grid_y = _y;
    step = _s;
    x = grid_x * step;
    y = grid_y * step;
    id = new Integer(x).toString() + ',' + new Integer(y).toString();
  }

  // accept line type as arg
  Cell(int _x, int _y, int _s, int _line_type) {
    line_type = _line_type;

    // dupe
    grid_x = _x; grid_y = _y;
    step = _s;
    x = grid_x * step;
    y = grid_y * step;
    id = new Integer(x).toString() + ',' + new Integer(y).toString();
  }

  void draw() {
    switch (line_type) {
      case Z:
        break;
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
  println(NORTH);
  println(SOUTH);
  println(EAST);
  println(WEST);
  int dir = WEST;
  dir |= NORTH;
  dir |= EAST;
  if ((dir & NORTH) == NORTH) println("north");
  if ((dir & SOUTH) == SOUTH) println("south");
  if ((dir & EAST)  == EAST)  println("east");
  if ((dir & WEST)  == WEST)  println("west");

  colorMode(HSB, 255);
  size(step * steps, step * steps);
  strokeCap(SQUARE);
  w = width; h = height;
  c = 0; r = -(step / 2);
  clr = 0;

  cell_width = w / step;
  cell_height = h / step;

  // initialize world
  world = new World(cell_width, cell_height, step);

  // write something
  world.write(3, 3, WORD);
}

boolean alt_r=false, alt_c=true;
void draw() {
  background(color(clr,255,255));

  world.draw();

  clr = (clr + 1) % 255;
  // noLoop();
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


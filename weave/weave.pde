// Maybe maze drawing offers a clue?

int w, h, c, r, clr,
    count = 0,
    cell_height, cell_width;

final int STEP  = 32, // STEP must be a multiple of 8
          STEPS = 12;

// lines are what knots are made of
class Line {
  ArrayList points;
  World w;

  Line (World _w) {
    points = new ArrayList();
    w = _w;
  }

  Cell last() {
    return points.size() > 0 ?
      (Cell)points.get(points.size() - 1) :
      null;
  }

  Cell first() {
    return (Cell)points.get(0);
  }

  void add(int gx, int gy) {
    Cell c, l;

    println("adding...");

    // first cell
    if (points.size() == 0) {
      c = w.place_cell_at(gx, gy);
      points.add(c);
      return;
    }

    // target can't be on a line
    if (w.get_cell_at(gx, gy) != null) return;

    l = last();

    // can only add points in line with last point
    if (!l.in_line_with(gx, gy)) return;

    // can't run parallel to another line
    // hmmm...

    add_range(l.grid_x, l.grid_y, gx, gy);
  }

  void add_range(int gx1, int gy1, int gx2, int gy2) {
    Cell c = null, prev;
    int p, next;
    if (gx1 == gx2) { // vert
      p = gy1 > gy2 ? -1 : 1;
      for (int ny=1; ny <= abs(gy1 - gy2); ny++) {
        next = gy1 + (ny * p);

        // DON'T RUN PARALLEL
        if (world.get_cell_at(gx1, next) != null) return;
        else {
          c = world.place_cell_at(gx1, next);
          prev = last();

          if (p == 1) { // downwards
            prev.dir |= SOUTH;
            c.dir    |= NORTH;
          } else {      // upwards
            prev.dir |= NORTH;
            c.dir    |= SOUTH;
          }
          points.add(c);
        }
      }
    } else { // vert
      p = gx1 > gx2 ? -1 : 1;
      for (int nx=1; nx <= abs(gx1 - gx2); nx++) {
        next = gx1 + (nx * p);

        // DON'T RUN PARALLEL
        if (world.get_cell_at(next, gy1) != null) return;
        else {
          c = world.place_cell_at(next, gy1);
          prev = last();

          if (p == 1) { // right
            prev.dir |= EAST;
            c.dir    |= WEST;
          } else {      // left
            prev.dir |= WEST;
            c.dir    |= EAST;
          }
          points.add(c);
        }
      }
    }
  }
}

class World {
  HashMap cells;
  int h, w, step;

  // world w and h are in grid steps, step is pixels.
  World(int _w, int _h, int _step) {
    step = _step;
    w = _w; h = _h;

    // gridworld
    cells = new HashMap(w * h);

    // populate
    // for (int y=0; y <= h; y++) {
    //   for (int x=0; x <= w; x++) {
    //     place_cell_at(x, y);
    //   }
    // }
  }

  Cell place_cell_at(int gx, int gy) {
    Cell c = new Cell(gx, gy, step);
    cells.put(c.id, c);
    return c;
  }

  Cell get_cell_at(int gx, int gy) {
    return (Cell)cells.get(cell_id(gx, gy));
  }

  // return pixel location of cell at grid step
  int[] cell_at(int gx, int gy) {
    return new int[] {gx * step, gy * step};
  }

  String cell_id(int x, int y) {
    int[] point = cell_at(x, y);
    int _x = point[0],
        _y = point[1];

    return  _x + "," + _y;
  }

  void draw() {
    Iterator i = cells.values().iterator();  // Get an iterator

    while (i.hasNext()) {
      Cell c = (Cell)i.next();
      c.draw();
    }
  }
}

// cell drawing types
final int EW_OVER=0, NS_OVER=1;
// cell drawing directions
final int NORTH=1, N=1,
          SOUTH=2, S=2,
          EAST =4, E=4,
          WEST =8, W=8;
/*
 *  int dir = WEST;
 *  dir |= NORTH;
 *  dir |= EAST;
 *  if ((dir & NORTH) == NORTH) println("north");
 *  if ((dir & SOUTH) == SOUTH) println("south");
 *  if ((dir & EAST)  == EAST)  println("east");
 *  if ((dir & WEST)  == WEST)  println("west");
 */

class Cell {
  int x, y, midx, midy, grid_x, grid_y, step, hstep, line_type;

  // line widths
  int border, line,
      ld, hld, // line diff
      b0, l0, b1, l1; // border / line offsets

  color c_border, c_line;

  String id;
  int dir;

  boolean alive;
  World myworld;

  // set default line type
  Cell(int _x, int _y, int _s) {
    alive = true;

    // line_type = EW_NS;
    dir = 0;

    // hsb
    c_border = color(0, 0, 0);
    c_line   = color(255, 0, 255);

    // grid coordinates
    grid_x = _x;
    grid_y = _y;

    // pixel coordinates
    step = _s; hstep = step / 2;
    x = grid_x * step;
    y = grid_y * step;

    id = Integer.toString(x) + ',' + Integer.toString(y);

    // border is a line slightly wider than the line
    border = hstep + (step / 8);
    line   = hstep - (step / 8);

    //     b0 l0     l1 b1    <- relevant border / line offsets
    // +--------------------+
    // |   |  |      |  |   |
    // |   |  |      |  |   |
    // |---+--+------+--+---|
    // |   |  |      |  |   | <- border
    // |---+--+------+--+---|
    // |   |  |      |  |   |
    // |   |  |      |  |   | <- line
    // |   |  |      |  |   |
    // |---+--+------+--+---|
    // |   |  |      |  |   | <- border
    // |---+--+------+--+---|
    // |   |  |      |  |   |
    // |   |  |      |  |   |
    // +--------------------+

    // offsets
    ld = border - line;
    hld = ld / 2;

    b0 = (step - border) / 2;
    l0 = (step - line) / 2;
    l1 = hstep + line / 2;
    b1 = hstep + border / 2;

    // pixel coordinates
    midx = x + hstep;
    midy = y + hstep;
  }

  void toggle() {
    alive = !alive;
  }

  void draw() {
    if (alive) {
      draw_center();
      draw_segments();
    }
  }

  void draw_center() {
    // draw center block downwards
    l_border(midx, y + b0, midx, y + b1);
    l_line(  midx, y + l0, midx, y + l1);
  }

  void draw_segments() {
    if (northy()) {
      l_border(midx, y, midx, y + b0);
      l_line(  midx, y, midx, y + l0);
    }

    if (southy()) {
      l_border(midx, y + b1, midx, y + step);
      l_line(  midx, y + l1, midx, y + step);
    }

    if (easty()) {
      l_border(x + b1, midy, x + step, midy);
      l_line(  x + l1, midy, x + step, midy);
    }

    if (westy()) {
      l_border(x, midy, x + b0, midy);
      l_line(  x, midy, x + l0, midy);
    }
  }

  boolean northy() { return (dir & N) == N; }
  boolean southy() { return (dir & S) == S; }
  boolean easty()  { return (dir & E) == E; }
  boolean westy()  { return (dir & W) == W; }

  void l_border(int x1, int y1, int x2, int y2) {
    stroke(c_border); strokeWeight(border); line(x1, y1, x2, y2);
  }

  void l_line(int x1, int y1, int x2, int y2) {
    stroke(c_line); strokeWeight(line); line(x1, y1, x2, y2);
  }

  boolean in_line_with(int ogx, int ogy) {
    println("comparing " + ogx + " to " + grid_x + " and " + ogy + " to " + grid_y);
    return (ogx == grid_x || ogy == grid_y);
  }
}

World world;
Line  knot;

void setup() {
  colorMode(HSB, 255);
  size(STEP * STEPS, STEP * STEPS);
  strokeCap(SQUARE);
  w = width; h = height;
  c = 0; r = -(STEP / 2);
  clr = 0;

  cell_width = w / STEP;
  cell_height = h / STEP;

  // initialize world
  world = new World(cell_width, cell_height, STEP);
  knot  = new Line(world);

  frameRate(4);
}

void draw() {
  background(51);

  world.draw();

  // noLoop();
}

void keyPressed() {
  noLoop();
}

void mouseClicked() {
  // get grid number
  int gx = (mouseX / STEP),
      gy = (mouseY / STEP);

  // try to add cell
  knot.add(gx, gy);
}


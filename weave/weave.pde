import processing.pdf.*;

final String VERSION = "v11";

// set PDF drawing to true to save generated knot as a PDF immediately.
final boolean PDF_MODE=false;

// Maybe maze drawing offers a clue?

int w, h, c, r, clr,
    count = 0,
    cell_height, cell_width;

final int STEP  = 16, // STEP must be a multiple of 16
          STEPS_X = 32,
          STEPS_Y = 32;

// STEPS_X = 2560 / STEP;
// STEPS_Y = 1440 / STEP;

final int VERT = 0, HORIZ = 1;

// UTILITY FUNCTIONS

// return starting pixel location of cell at grid step
int[] cell_at(int gx, int gy) {
  return new int[] {gx * STEP, gy * STEP};
}

// string suitable for hashing
String cell_id(int x, int y) {
  int[] point = cell_at(x, y);
  int _x = point[0],
      _y = point[1];
  return  _x + "," + _y;
}

// lines are what knots are made of
class Knot {
  ArrayList points, visited;
  // HashMap cells;
  Cell[][] cell_grid;

  // start
  Cell first;
  // newest living cell
  Cell current;

  int crosses=0;

  Knot () {
    first = null;
    points = new ArrayList();
    visited = new ArrayList();
    cell_grid = new Cell[STEPS_X][];
    for (int x=0; x<STEPS_X; x++) {
      cell_grid[x] = new Cell[STEPS_Y];
    }

    // cells = new HashMap(STEPS_X * STEPS_Y);
  }

  Cell last() {
    return points.size() > 0 ?
      (Cell)points.get(points.size() - 1) :
      null;
  }

  Cell first() {
    if (first == null && points.size() > 0) first = (Cell)points.get(0);
    return first;
  }

  void add(int gx, int gy) {
    Cell c, l;

    // first cell
    if (points.size() == 0) {
      c = this.place_cell_at(gx, gy);
      c.setColor(next_color());
      points.add(c);
      return;
    }

    l = last();

    // already a closed loop
    if (points.size() > 3 && first() == last()) return;

    // can only add points in line with last point
    if (!l.in_line_with(gx, gy)) return;

    // don't end on existing cells unless it's the starting point
    if (this.get_cell_at(gx, gy) != null &&
        this.get_cell_at(gx, gy) != first()) return;

    add_range(l.grid_x, l.grid_y, gx, gy);
  }

  void add_range(int gx1, int gy1, int gx2, int gy2) {
    Cell prev_cell = null, next_cell;
    int dx, dy, nx, ny, next_point, next_dir, prev_dir, travel;

    dx = gx1 > gx2 ? -1 : 1;
    dy = gy1 > gy2 ? -1 : 1;

    if (gx1 == gx2) dx = 0;
    if (gy1 == gy2) dy = 0;

    // starting cell is offset by one
    nx = gx1 + dx;
    ny = gy1 + dy;

    travel = dx == 0 ? VERT : HORIZ;

    // draw cells in the appropriate direction
    while (nx != gx2 + dx || ny != gy2 + dy) {
      if (prev_cell == null) prev_cell = last();

      prev_cell.dirty = true;

      // the direction out from prev to next cell.
      if (travel == HORIZ) {
        next_dir = dx == 1 ? EAST : WEST;
        prev_dir = dx == 1 ? WEST : EAST;
      } else {
        next_dir = dy == 1 ? SOUTH : NORTH;
        prev_dir = dy == 1 ? NORTH : SOUTH;
      }

      next_cell = this.get_cell_at(nx, ny);

      // don't run parallel or cross corners
      if (next_cell != null) {
        if (next_cell == first()) {
          // is legit, leave it alone
        } else if (next_cell.is_corner() ||
                   next_cell.parallel_to(next_dir) ||
                   next_cell == first()) {
          // stop drawing, don't draw this cell
          return;
        }
        // this is the second visit, set second line color
        next_cell.setColor2(next_color());
      } else {
        next_cell = this.place_cell_at(nx, ny);
        next_cell.setColor(next_color());
      }

      prev_cell.dir |= next_dir;
      next_cell.dir |= prev_dir;

      points.add(next_cell);

      prev_cell = next_cell;
      nx += dx;
      ny += dy;
    }
  }

  // returns EW_OVER or NS_OVER
  int next_cross(int travel) {
    crosses++;
    if (crosses % 2 == 0) {
      // this line goes under
      return travel == HORIZ ? NS_OVER : EW_OVER;
    } else {
      // this line goes over
      return travel == HORIZ ? EW_OVER : NS_OVER;
    }
  }

  void clear() {
    // cells.clear();
    points.clear();
    for (int x=0; x<STEPS_X; x++) {
      for (int y=0; y<STEPS_Y; y++) {
        cell_grid[x][y] = null;
      }
    }
    current = null; first = null;
  }

  // is there an open cell that we can move to?
  boolean move_possible(int dir) {
    return possible_moves(dir).size() > 0;
  }

  // can move to any empty cell that is not past a corner.
  // walk along the grid, checking each point as a possible
  // destination.
  ArrayList possible_moves(int dir) {
    Cell l = last(), check;
    ArrayList pts = new ArrayList();

    int dx=0,dy=0,
        gx = l.grid_x,
        gy = l.grid_y;

    switch(dir) {
      case NORTH:
        dx = 0;
        dy = -1;
        break;
      case SOUTH:
        dx = 0;
        dy = 1;
        break;
      case EAST:
        dx = 1;
        dy = 0;
        break;
      case WEST:
        dx = -1;
        dy = 0;
        break;
    }

    while (gx < STEPS_X && gx >= 0 && gy < STEPS_Y && gy >= 0) {
      if ((check = this.get_cell_at(gx, gy)) != null) {
        // If cell already has a line, then it's perpendicular or a corner.
        // Skip perpendiculars. Corner means the line can't go past it, just
        // return.
        if (check.is_corner()) {
          return pts;
        }
      } else {
        pts.add(new int[] {gx, gy});
      }

      gx += dx;
      gy += dy;
    }

    return pts;
  }

  // Get the newest living cell on the knot.

  void draw() {
    int travel=0;

    crosses = 0;

    for (int n=0; n < points.size(); n++) {
      Cell c = (Cell)points.get(n);

      if (n - 1 > 0) {
        Cell prv = (Cell)points.get(n - 1);
        switch (prv.direction_to(c)) {
          case N: travel = VERT; break;
          case S: travel = VERT; break;
          case E: travel = HORIZ; break;
          case W: travel = HORIZ; break;
        }
      }

      if (c.crosses()) {
        c.dirty = true;
        int initial_over = c.over,
            next_over = next_cross(travel);
        if (initial_over != next_over) {
          c.setOver(next_over);
        }

        if (visited.indexOf(c) < 0) {
          // set color 1
          c.first_pass = travel;
        } else {
          // set color 2
          visited.add(c);
        }
      } else {
        // set color 1
      }

      if (c.dirty) {
        c.draw();
        c.dirty = false;
      }
    }

    visited.clear();
  }

  Cell place_cell_at(int gx, int gy) {
    Cell c = new Cell(gx, gy, STEP);
    // cells.put(c.id, c);
    cell_grid[gx][gy] = c;
    return c;
  }

  Cell get_cell_at(int gx, int gy) {
    // return (Cell)cells.get(cell_id(gx, gy));
    return cell_grid[gx][gy];
  }
}

// cell drawing types
final int NEITHER=0, EW_OVER=1, NS_OVER=2;

// cell drawing directions
final int NORTH=1, N=1,
          SOUTH=2, S=2,
          EAST =4, E=4,
          WEST =8, W=8;

// combinations
final int NW = N | W, NE = N | E, SW = S | W, SE = S | E,
          NSEW = N | S | E | W, EW = E | W, NS = N | S;

class Cell {
  int x, y, midx, midy,
      grid_x, grid_y,
      step, hstep, over;

  // line widths
  int border, line,
      ld, hld, // line diff
      b0, l0, b1, l1; // border / line offsets

  // up to two colors since cell can be visited twice
  color c_border, c_line,
        c_border2, c_line2;

  boolean use_color_2, dirty, alive;

  String id;
  int dir, first_pass;

  Cell previous;

  // set default line type
  Cell(int _x, int _y, int _s) {
    over = NEITHER;
    use_color_2 = false;
    dirty = true; // has cell changed?
    alive = true;

    // line_type = EW_NS;
    dir = 0;

    // hsb
    c_border = color(0);
    c_line   = color(255, 0, 255);

    c_border2 = color(0);
    c_line2   = color(255, 0, 255);

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

  void setPrevious(Cell c) { previous = c; }

  void setColor(color c) { setKnotColor(c);   /* setBorderColor(c);  /* */ }
  void setColor2(color c) { setKnotColor2(c); /* setBorderColor2(c); /* */ }

  void setKnotColor(color c) { c_line = c; }
  void setKnotColor2(color c) { c_line2 = c; }
  void setBorderColor(color c) { c_border = c; }
  void setBorderColor2(color c) { c_border2 = c; }

  boolean is_corner() {
    return ((dir & NW) == NW) ||
           ((dir & NE) == NE) ||
           ((dir & SW) == SW) ||
           ((dir & SE) == SE);
  }

  boolean crosses() {
    return (dir & NSEW) == NSEW;
  }

  void draw() {
    if (over == NEITHER) {
      draw_center();
      draw_segments();
    } else {
      if (over == EW_OVER) {
        if (first_pass == VERT) {
          use_color_2 = true;
          vstripe();
          use_color_2 = false;
          hstripe();
        } else {
          vstripe();
          use_color_2 = true;
          hstripe();
          use_color_2 = false;
        }
      } else {
        if (first_pass == VERT) {
          hstripe();
          use_color_2 = true;
          vstripe();
          use_color_2 = false;
        } else {
          use_color_2 = true;
          hstripe();
          use_color_2 = false;
          vstripe();
        }
      }
    }
    // cells are dirty until they've been drawn, then they are clean
    dirty = false;
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

  // simple crossings
  void vstripe(){
    int hx = x + hstep;
    l_border(hx, y, hx, y + step);
    l_line(  hx, y, hx, y + step);
  }

  void hstripe() {
    int hy = y + hstep;
    l_border(x, hy, x + step, hy);
    l_line(  x, hy, x + step, hy);
  }

  boolean northy() { return (dir & N) == N; }
  boolean southy() { return (dir & S) == S; }
  boolean easty()  { return (dir & E) == E; }
  boolean westy()  { return (dir & W) == W; }

  void l_border(int x1, int y1, int x2, int y2) {
    if (use_color_2) stroke(c_border2);
    else stroke(c_border);
    strokeWeight(border); line(x1, y1, x2, y2);
  }

  void l_line(int x1, int y1, int x2, int y2) {
    if (use_color_2) stroke(c_line2);
    else stroke(c_line);
    strokeWeight(line); line(x1, y1, x2, y2);
  }

  boolean in_line_with(int ogx, int ogy) {
    return (ogx == grid_x || ogy == grid_y);
  }

  // does cell already have an exit facing this direction?
  boolean parallel_to(int dir_flag) {
    return (this.dir & dir_flag) == dir_flag;
  }

  // direction from this to other. In other words, what direction is
  // the line travelling when moving from this cell to the other cell.
  int direction_to(Cell other) {
    if      (x < other.x) return EAST;
    else if (x > other.x) return WEST;
    else if (y < other.y) return SOUTH;
    else if (y > other.y) return NORTH;
    return 0;
  }

  int exits() {
    int total = 0;
    if (northy()) total++;
    if (southy()) total++;
    if (easty()) total++;
    if (westy()) total++;
    return total;
  }

  void setOver(int ovr) {
    over = ovr;
    dir = NORTH | SOUTH | EAST | WEST;
  }
}

Knot knot;
boolean living, automatic = true;

final int[] steps = {NORTH, EAST, SOUTH, WEST};

void setup() {
  colorMode(HSB, 255);

  if (PDF_MODE) {
    size(STEP * STEPS_X, STEP * STEPS_Y, PDF, "knot.pdf");
    noLoop();
  } else {
    size(STEP * STEPS_X, STEP * STEPS_Y, P2D);
  }

  strokeCap(SQUARE);

  w = width; h = height;
  c = 0; r = -(STEP / 2);
  clr = 0;

  cell_width = STEPS_X;
  cell_height = STEPS_Y;

  // initialize world
  knot  = new Knot();
  living = true;

  // frameRate(40);
  // frameRate(3);
  background(255);
}

boolean resetScreen = false;

void draw() {
  if (resetScreen) {
    background(255);
  // fill(0, 145);
  // noStroke();
  // rect(0, 0, width, height);
    resetScreen = false;
  }

  // while (living && automatic) {
    living = make_a_knot();
    // if (!PDF_MODE) break; // only one loop if we're not preparing a pdf
  // }

  knot.draw();

  if (PDF_MODE) {
    exit();
  }

  if (!living) {
    noLoop();
  }
}

void keyPressed() {
  switch(key) {
    case ' ':
      knot.clear();
      living = true;
      resetScreen = true;
      loop();
      break;
    case 'a':
      automatic = !automatic;
      break;
    case 's':
      save(VERSION +"-"+ millis() + ".png");
      exit();
      break;
  }
}

void mouseClicked() {
  // get grid number
  int gx = (mouseX / STEP),
      gy = (mouseY / STEP);

  // try to add cells
  knot.add(gx, gy);
}

// take next step or die
boolean make_a_knot() {
  Cell last_cell = knot.last();
  if (last_cell == null) {
    knot.add(STEPS_X / 2, 0);
  } else  {
    // return false if we can't take a step
    if (!step(last_cell)) return false;
  }
  return true;
}

void print_steps () {
  for (int i=0; i<steps.length; i++) println(steps[i]);
}

void shuffle_steps() {
  int j, t;

  for (int i = steps.length - 1; i >= 0; i--) {
    j = int(random(i));
    t = steps[i];
    steps[i] = steps[j];
    steps[j] = t;
  }
}

boolean step(Cell last_cell) {
  shuffle_steps();

  int nx, ny,
      current_step = (int)random(steps.length),
      cur_dir = steps[current_step];
  int tries = 0;
  boolean possible = false;
  ArrayList possibles = knot.possible_moves(cur_dir);
  while (possibles.size() == 0 && tries < steps.length) {
    current_step = (current_step + 1) % steps.length;
    cur_dir = steps[current_step];
    tries++;
    possibles = knot.possible_moves(cur_dir);
  }
  if (possibles.size() > 0) {
    // choose one of the possibles
    int[] point = (int[]) possibles.get( int(random(possibles.size() / 3)) );
    knot.add(point[0], point[1]);
    return true;
  } else {
    return false;
  }
}

// totally awesome color cycling
int nc=0;
color next_color() {
  
  nc = (nc + 1) % 255;
  // return color(nc, 255, 200); // color cycle
  return color(255); // just white
}

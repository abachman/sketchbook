import java.util.Map;
import java.util.Set;

Center[] centers;
int[][] connections;
HashMap<Integer, Center> world;

static int PONS = 40; 
static int CONS = 4;
static float STEP = 1;
static float COLOR_STEP = 0.4;

void setup() {
  size(1000, 600);
  background(30);
  colorMode(HSB);
  centers = new Center[PONS];
  world = new HashMap<Integer, Center>();

  fill(200);

  float x, y, dx, dy;

  Center c;

  for (int i=0; i < PONS; i++) {
    x = random(width);
    y = random(height);
    dx = random(-STEP, STEP);
    dy = sin(acos(dx / STEP)) * STEP * (random(1) > 0.5 ? -1 : 1);

    c = new Center(i, x, y, dx, dy);
    centers[i] = c;
  }

  // add all points to world
  for (Center self : centers) {
    world.put(self.id, self);
  }
}

void updateWorld(Range range) {
  for (Center self : centers) {
    if (range.contains(self)) {
      world.put(self.id, self);
    } else {
      world.remove(self.id);
    }
  }
}

void drawConnections(Range range) {
  strokeWeight(1);
  noFill();

  Object[] availables = world.keySet().toArray();

  for (Center self : centers) {
    Center other;

    // build connection list on the fly
    self.reconnect(availables);

    for (int n=0; n < CONS; n++) {
      // get other center
      other = self.connections[n];
  
      stroke( self.clr() );

      // connect it
      line(self.px, self.py, other.px, other.py);
    }
  }
}

void drawPoints(Range range) {
  // draw points
  noStroke();
  fill(200);
  for (Center self : world.values ()) {
    ellipse(self.px, self.py, 10, 10);
  }
}

Range getRange() {
  float cx = width/2, 
  cy = height/2, 
  mx = mouseX, 
  my = mouseY;
  return new Range(cx, cy, dist(cx, cy, mx, my));
}

void drawRange(Range range) {
  stroke(200);
  strokeWeight(3);
  noFill();
  ellipse(range.cx, range.cy, range.diam, range.diam);
}

void draw() {
  background(30);
  // fill(0, 30);
  // rect(0, 0, width, height);

  Range range = getRange();

  for (int i=0; i < PONS; i++) {
    centers[i].update(range);
  }

  // updateWorld(range);
  drawConnections(range);
  // drawPoints(range);
  // drawRange(range);
}

///// Point

class Center {
  float x, y, dx, dy, step; // moving point
  float px, py; // drawn point
  float hue; // color
  
  int id;
  Center[] connections;

  Center(int id, float x, float y, float dx, float dy) {
    this.id = id;
    this.x = x;
    this.y = y;
    this.dx = dx;
    this.dy = dy;

    this.connections = new Center[CONS];

    this.step = STEP;
    
    this.hue = random(255);
  }

  // movement of point
  void update(Range range) {
    float nx = x + dx;
    if (nx < width && nx > 0) {
      x = nx;
    } else {
      // too far right, bounce
      dx = -dx;
    }

    float ny = y + dy;
    if (ny < height && ny > 0) {
      y = ny;
    } else {
      // too far down, bounce
      dy = -dy;
    }
    
    // if point is outside range, set (px, py) to the point on the edge of the range 
    // with the same angle from the origin as (x, y)  
    if (range.contains(this)) {
      px = x;
      py = y; 
    } else {
      float theta = atan2(y - range.cy, x - range.cx);
      px = range.rad * cos(theta) + range.cx;
      py = range.rad * sin(theta) + range.cy;
    }
    
    // update color 
    hue += COLOR_STEP;
  }

  // build connection list from known Centers
  void reconnect(Object[] others) {
    int i = 0, x;
    Center other;
    while (i < CONS) {
      if (connections[i] != null && world.containsKey(connections[i].id)) {
        // this connection is still in the world, don't replace it
        i++;
        continue;
      }

      // pick a random other point in the world
      x = int(random(others.length));
      other = world.get((Integer)others[x]);

      if (other != this || others.length < 4) {
        this.connections[i] = other;
        i++;
      }
    }
  }

  float cdist(float ox, float oy) {
    return dist(ox, oy, this.x, this.y);
  }
  
  color clr() {
    return color(128 + floor(hue) % 128);
  }
}

///// Range

class Range {
  float 
    cx, cy, // location of the center of the Range 
    rad, diam; // size of the Range

  Range(float cx, float cy, float rad) {
    this.cx = cx;
    this.cy = cy;
    this.rad = rad;
    this.diam = rad * 2;
  }

  boolean contains(Center point) {
    return point.cdist(cx, cy) < rad;
  }
}


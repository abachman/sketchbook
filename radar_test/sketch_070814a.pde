float cx,cy;
float r = 100;
float spread = .5;
float[][] points;

void setup() {
  size(600, 600);
  background(255);
  smooth();
  frameRate(30);  
  cx = width/2;
  cy = height/2;
  points = new float[30][4];
  for (int p = 0; p < points.length; p++) {
    points[p][0] = random(width);
    points[p][1] = random(height);
    points[p][2] = getAngle(points[p][0]-cx,points[p][1]-cx);
    points[p][3] = dist(points[p][0],points[p][1],cx,cy);
  }
}

void draw() {
  background(255);
  float dir = getAngle(mouseX-cx,mouseY-cy);

  float lx = r*sin(dir-spread) + cx, ly = r*cos(dir-spread) + cy;
  float rx = r*sin(dir+spread) + cx, ry = r*cos(dir+spread) + cy;
  line(cx,cy,lx,ly);
  line(cx,cy,rx,ry);
  float mindist = 10000;
  int minpoint=0;
  for (int p = 0; p < points.length; p++) {
    if (points[p][2] > dir-spread && points[p][2] < dir+spread) {
      ellipse(points[p][0], points[p][1], 10,10);
      if (points[p][3] < mindist) {
        mindist = points[p][3];
        minpoint = p;
      }
    }
  }
  line(cx,cy,points[minpoint][0],points[minpoint][1]);
}

void pointer(float x, float y, float ox, float oy) {
  x -= ox;
  y -= oy;
  float d, r = 30;
  d = getAngle(x, y);
  line(ox, oy, r*sin(d)+ox,  r*cos(d)+oy);
}

float getAngle(float x, float y) {
  // Get the angle in radians for point (x,y) for rectangular to polar conversion.
  return y < 0 ? PI + atan(x/y) : atan(x/y);
}


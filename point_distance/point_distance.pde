// Point Distance, QLab speaker location demo
// https://gist.github.com/abachman/5911532
//
// requires the oscP5 library from:
// http://www.sojamo.de/libraries/oscp5/
//

import oscP5.*;
import netP5.*;

int points[][];
int existingPoints[][];

float pds[]; // point distances

float pdsWeight[];
float pdsInverse[];
float pdsInverseWeight[];

PFont font;

int PADDING = 100;
int POINTS = 0;
float defaultStroke = 100;

float levels[];
float previousLevels[];
boolean levelChange = false;

// throttle OSC messages
int previousMillis;
int M_PER_SEC = 11;
int milliStep, ms;

OscP5 oscP5;
NetAddress qlabRemote;

void setup() {
  points = new int[POINTS][];
  existingPoints = new int[POINTS][];
  pds = new float[POINTS];
  
  pdsWeight = new float[POINTS];
  pdsInverse = new float[POINTS];
  pdsInverseWeight = new float[POINTS];
  
  levels = new float[POINTS];
  previousLevels = new float[POINTS];
  
  size(800, 400);
  frameRate(24);
  
  initPoints();
  
  stroke(255);
  strokeWeight(4);
  
  font = loadFont("Monospaced-14.vlw");
  textFont(font, 14);
  
  oscP5 = new OscP5(this, 53002);
  qlabRemote = new NetAddress("127.0.0.1",53000);
  
  milliStep = 1000 / M_PER_SEC;
}

float sum, inverseSum;

void draw() {
  background(0);
  noStroke();
  fill(255);
  sum = 0.0;
  for (int n=0; n < points.length; n++) {
    pds[n] = drawPoint(points[n]);
    sum += pds[n];
  }
  
  // get weights and weight inverses
  inverseSum = 0.0;
  for (int n=0; n < points.length; n++) {
    pdsWeight[n] = pds[n] / sum;
    pdsInverse[n] = 1 / pdsWeight[n];
    inverseSum += pdsInverse[n];
  }
  
  stroke(255, 50);
  for (int n=0; n < points.length; n++) {
    pdsInverseWeight[n] = pdsInverse[n] / inverseSum;
    levels[n] = linearToDb(pdsInverseWeight[n]);
  
    text(pdsWeight[n], points[n][0] + 10, points[n][1]);
    text(pdsInverseWeight[n],  points[n][0] + 10, points[n][1] + 10);
    text(levels[n], points[n][0] + 10, points[n][1] + 20);
   
    strokeWeight(defaultStroke * (pdsInverse[n] / inverseSum));
    line(points[n][0], points[n][1], mouseX, mouseY);
  }

  ms = millis();
  if (previousMillis + milliStep < ms) {
    // send sliderLevel message to QLab, first workspace, first cue
    OscBundle sliders = new OscBundle();
  
    for (int n=0; n < points.length; n++) {
      // if level has changed beyond threshold, try to send message
      if (!levelChange) { 
        if (abs(previousLevels[n] - levels[n]) > 0.001) {
          levelChange = true;
        }
        previousLevels[n] = levels[n];
      }
          
      OscMessage slider = new OscMessage("/cue/1/sliderLevel");
      slider.add(n + 1);
      slider.add(linearToDb(pdsInverseWeight[n]));
      sliders.add(slider);
    }
    
    if (levelChange) oscP5.send(sliders, qlabRemote);
    previousMillis = ms;  
    levelChange = false;
  }
  
  // display sum of line lengths
  text(sum, width/2, 20);
}

float drawPoint(int point[]) {
  ellipse(point[0], point[1], 10, 10);
  return dist(point[0], point[1], mouseX, mouseY);
}

void initPoints() {
  // reset to POINTS
  for (int n=0; n < points.length; n++) {
    addPointAt(int(random(width - PADDING)) + (PADDING / 2),
               int(random(height - PADDING)) + (PADDING / 2),
               n);
  }
}

void keyPressed() {
  save("point-distance.png");
  
  if (key == ' ') {
    // reset points length to POINTS
    points = (int[][]) expand(points, POINTS);
    initPoints();
    resetData();
  }
}

// add point when clicked
void mousePressed() {
  points = (int[][]) append(points, new int[] {mouseX, mouseY});
  resetData();
}

void resetData() { 
  // make sure the data tracking arrays are the same length as points
  pds = (float[]) expand(pds, points.length);
  pdsWeight = (float[]) expand(pdsWeight, points.length);
  pdsInverse = (float[]) expand(pdsInverse, points.length);
  pdsInverseWeight = (float[]) expand(pdsInverseWeight, points.length);
  levels =  (float[]) expand(levels, points.length);
  previousLevels =  (float[]) expand(previousLevels, points.length);
}

void addPointAt(int x, int y, int idx) {
  points[idx] = new int[]{ x, y };
}

float log10 (float x) {
  return (log(x) / log(10));
}

float linearToDb(float volume) {
  if (volume < 0.0 || Float.isInfinite(volume)) {
    return -100.0;
  } else if (volume > 1.0 || Float.isNaN(volume)) {
   return 0.0; 
  } else {
    return 20.0 * log10(volume);
  }
}

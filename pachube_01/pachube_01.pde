//import maxlink.*;
import eeml.*;
// receives datastream from ELF sensor via Max/MSP
// joshua penrose 2010
// from jkriss clor picker sketch

//MaxLink link = new MaxLink(this,"get_7harmonicsc");
DataOut dOut;
float lastUpdate;

// these must be public
public float one = 1;
public float two = 2;
public float three = 3;
public float four = 4;
public float five = 5;
public float six = 6 ;
public float seven = 7;
PFont f;

void setup() {
  size(520, 120);
  background(20);
  f = loadFont("Meta-Bold.vlw");
  textFont(f, 10);
  /* link.declareInlet("one");
  link.declareInlet("two");
  link.declareInlet("three");
  link.declareInlet("four");
  link.declareInlet("five");
  link.declareInlet("six");
  link.declareInlet("seven"); */

  // set up DataOut object; requires URL of the EEML you are updating, and your Pachube API key
  dOut = new DataOut(this, "http://www.pachube.com/api/feeds/6929.xml", "[REDACTED]");

  //  and add and tag a datastream
  dOut.addData(0,"temperature");
  frameRate(10);
}

int response = 200;
void draw()
{
    drawMessageone();
    // update once every 3.7 seconds (rate limit of 3.6 seconds)
    if ((millis() - lastUpdate) > 3700){
        text("ready to POST: " + one, 80, 60);  
        dOut.update(0, one); // update the datastream
        response = dOut.updatePachube(); // updatePachube() updates by an authenticated PUT HTTP request
        text(response, 80, 80); // should be 200 if successful; 401 if unauthorized; 404 if feed doesn't exist
        lastUpdate = millis();
    }
}

void drawMessageone() {
  one += .2;
  // background(20);
  fill(0, 15);
  rect(0, 0, width, height);
  fill(255);
  text(one, 10, 20);
  text(two, 80, 20);
  text(three, 150, 20);
  text(four, 220, 20);
  text(five, 290, 20);
  text(six, 360, 20);
  text(seven, 430, 20);
}



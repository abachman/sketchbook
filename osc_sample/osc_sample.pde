/**
 * oscP5 website at http://www.sojamo.de/oscP5
 */

import oscP5.*;
import netP5.*;

OscP5 oscP5;
Zone[] zones;
int next_zone;
int zone_count;
int zone_w;
int zone_h;
static int MAX_ZONES=20;

void setup() {
  size(800,600,P2D);
  noSmooth();
  noStroke();
  frameRate(12);
  oscP5 = new OscP5(this, 1234);
  oscP5.plug(this,"register","/register");
  oscP5.plug(this,"notify","/notify");
  
  // onscreen text
  PFont f = loadFont("Century-28.vlw");
  textFont(f, 16);
  
  // zones
  zones = new Zone[MAX_ZONES];
  next_zone = 0;
  zone_count = 0;
}

public void register(String name) {
  zones[next_zone] = new Zone(name);
  next_zone += 1;
  if (zone_count < MAX_ZONES) zone_count += 1;
  if (next_zone > MAX_ZONES) next_zone = 0;
}

//    @make_method('/notify', 'ss')
//    def notify_callback(self, path, args):
//        name, message = args
//        self.processor.process(name, message)

public void notify(String name, String message){
  for (int i=0; i < zone_count; i++) {
    if (zones[i].name.equals(name)) {
      zones[i].ping(message);
      return;
    }
  }
  // should never get here unless we receive unregistered messages
  register(name);
}

void draw() {
  fill(0, 30);
  rect(0,0,width, height);  
}

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* with theOscMessage.isPlugged() you check if the osc message has already been
   * forwarded to a plugged method. if theOscMessage.isPlugged()==true, it has already 
   * been forwared to another method in your sketch. theOscMessage.isPlugged() can 
   * be used for double posting but is not required.
  */  
  if(theOscMessage.isPlugged()==false) {
  /* print the address pattern and the typetag of the received OscMessage */
  println("### received an osc message.");
  println("### addrpattern\t"+theOscMessage.addrPattern());
  println("### typetag\t"+theOscMessage.typetag());
  }
}

// Zone is a randomly chosen area where the pings show up.
class Zone {
  public String name;
  float x, y;
  color col;
  Zone(String _name) {
    name = _name;
    x = random(50, width-50);
    y = random(50, height-50);
    col = color(random(100, 255), random(100,255), random(100, 255));
    
    fill(col, 175);
    ellipse(x,y,200,200);
    fill(125);
    text("welcome " + name, x-100, y);
  }
  
  public void ping(String message) {
    fill(col, 175);
    float nx = x + random(-40, 40); 
    float ny = y + random(-40, 40);
    if (nx < 0 || nx > width) nx = x;
    if (ny < 0 || ny > height) ny = y;
    float rad = random(30, 75);
    ellipse(int(nx), int(ny), int(rad), int(rad));
    //println("{" +this.name+ "} " + message);
    //println(nx + ", " + ny + " (" + rad + ")");
    fill(255);
    text(message.substring(0,15), x-75, y-50);
  }
}

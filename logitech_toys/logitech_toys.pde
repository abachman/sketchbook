// control
import procontroll.*;
import net.java.games.input.*;
ControllIO controll;
ControllDevice device;
//ControllStick movementStick;
//ControllStick transformStick;
ControllButton button;
ControllStick  cooliehat;

// sound
import krister.Ess.*;
AudioChannel myChannel;

// general
Mover mover;
float ch, cw;
float transX, transY;
float HALFPI = PI/2;
 
void setup(){
  size(1000,600);
  frameRate(26);
  ch = height/2;
  cw = width/2;
  transX = cw;
  transY = ch;
  controll = ControllIO.getInstance(this);
  controll.printDevices();
  device = controll.getDevice(3);
  device.printSticks(); 
  device.printButtons();

  initButtons();
  initSticks();
  PFont f = loadFont("DejaVuSansMono-14.vlw");
  textFont(f, 14);
  mover = new Mover(30);
  
  Ess.start(this);
  myChannel=new AudioChannel("mlody_long.aif");
  myChannel.loop(Ess.FOREVER);
  myChannel.cue(0);
}

void draw() {
  if (false) {
    fill(0, 20);
    noStroke();
    rect(0,0,width,height);
  } else {
    background(0);
  }
  fill(255);
  //text(movementStick.getX(),10,20); text(movementStick.getY(),80,20);
  //text(transformStick.getX(),10,40); text(transformStick.getY(),80,40);
  mover.drawme();
  checkButtons();
}

class Mover {
  float ohw, hw, dir, skew, curskew, dirskew;
  float[] verts;
  int _verts;
  float cx,cy;
  boolean isskewed, skewoff, skewon, colorize;
  Mover(float _hw) {
    ohw = _hw;
    hw = ohw;
    skew = 0;
    dir = 0;
    verts = new float[4];
    for (int v = 0; v < verts.length; v++) {
      verts[v] = v * (PI/(verts.length / 2.0));
    }
    colorize = false;
    skewon = false;
  }

  void update(float x, float y, float rot) {
  }
  
  void drawme() {
    //dir = transformStick.getTotalX();
    //hw = hw - transformStick.getY()*2;
    if (hw < 0) hw = 0;
    if (hw > height) hw = height;
    text(hw, width-80,height-30);    
    //text(transformStick.getY(), width-80,height-10);    
    //cx = movementStick.getX() + cw;
    //cy = movementStick.getY() + ch;
    
    myChannel.volume(hw / height);
    myChannel.pan((cx - cw) / cw);
    text(hw / height, 10, height-24);
    text((cx - cw) / cw, 10, height-10);
    
    
    noStroke();

    if (colorize) {
      int pv = int(random(3, 10));
      if (pv == verts.length) pv += 1;
      verts = new float[pv];
      for (int v = 0; v < verts.length; v++) {
        verts[v] = v * (PI / (verts.length / 2.0));
      }       
      colorize = false;
    }
    
    text(cooliehat.getX(), cx + hw, cy + hw);
    text(cooliehat.getY(), cx + hw, cy + hw + 13);
    ellipse(cx + (hw * cooliehat.getX()), cy + (hw * cooliehat.getY()), 20, 20);
    //stroke(255);
    //noFill();
    beginShape();
    for (int v = 0; v < verts.length; v++) {
      curskew = skewon ? random(-hw/10,hw/10) : 0;
      dirskew = skewon ? random(-.2,.2) : 0;
      vertex((hw + curskew) * cos(dir + verts[v] + dirskew) + cx, 
             (hw + curskew) * sin(dir + verts[v] + dirskew) + cy);
    }
    endShape();
  }
}

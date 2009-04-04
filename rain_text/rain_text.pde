import java.util.*;

ArrayList messages;

void setup() {
  size(250, 500);
  PFont font = loadFont("BitstreamVeraSansMono-Roman-10.vlw");
  textFont(font, 10);
  messages = new ArrayList();
  frameRate(26);
}


float curx, cury;

void draw() {
  background(0);
  if (abs(curx - mouseX) > 1) {
    messages.add(new Message(width/2 - 20, 
                             height/2, 
                             random(-1,1), 
                             random(2,5) * (random(1)>5?-1:1), 
                             nf(mouseX,2,0)));
    curx = mouseX; 
  }
  if (abs(cury - mouseY) > 1) {
    messages.add(new Message(width/2 + 20, 
                             height/2, 
                             random(-1,1), 
                             random(2,5) * (random(1)>5?-1:1), 
                             nf(mouseY,3,0)));
    cury = mouseY; 
  }  
  
  Message mes;
  
  for (int m=messages.size()-1; m > -1; m--) {
    mes = (Message)messages.get(m);
    if (mes.update()) {
      mes.drawme();
    }
    else {
      messages.remove(m);
    }
    
  }
  
}

class Message {
  float x,y,vx,vy;
  String m;
  Message(float sx, float sy, float _vx, float _vy, String _m) {
    x = sx;
    y = sy;
    vx = _vx;
    vy = _vy;
    m = _m;
  } 
  boolean update() {
    x += vx;
    y += vy;  
    if (x > width || y > height || x < 0 || y < 0)
      return false;
    return true;
  }
  void drawme() {
    text(m, x, y); 
  }
}

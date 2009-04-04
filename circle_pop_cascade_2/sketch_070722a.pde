import java.util.List;

// int DOTCOL = 255;
int MAXDOTS = 80;
float[] SPEED = new float[] {.5, 3};
Dot[] dots = new Dot[MAXDOTS];
float MAXEXPL = 60;
float SHRINK = 4; // each propagated explosion will be SHRINK pixels smaller
List expls = new LinkedList();
Explosion expl;

void setup() {
  size(400, 400);
  frameRate(30);
  smooth();
  for (int f=0;f<MAXDOTS;f++) {
    dots[f] = new Dot();
    dots[f].launch();
  }
 
  PFont font;
  font = loadFont("LucidaSans-11.vlw"); 
  textFont(font, 11); 
}

int MAXCHAIN = 0, NEWCHAIN = 0, MINEXPL = (int)MAXEXPL;
boolean DONE = false;

void draw() {
  if (DONE) {
    frameRate(10);
    noStroke();
    fill(255);
    text("GAME OVER", width/2, height/2);
    text("Max chain: " + Integer.toString(MAXCHAIN), width/2, height/2 + 10);
    text("Max propagation: " + Float.toString((MAXEXPL-MINEXPL)/SHRINK), width/2, height/2 + 20);
    fill(0, 10);
    rect(0,0,width,height);
  }
  else 
    background(0);

  int dotcount = 0;
  for (int f=0;f<MAXDOTS;f++) {
    Dot d = dots[f];
    if (d.launched) {
      if (d.update()) {
        d.drawme();
        dotcount++;
      }
    }
    else if (random(0, 1) > .95) {
      d.launch();
      dotcount++;
    }
  }
  
  int s = expls.size();
  if (s > 0) {
    for (int x=s-1; x >= 0;x--) {
      Explosion e = (Explosion)expls.get(x);
      MINEXPL = MINEXPL < e.maxrad ? MINEXPL : (int)e.maxrad;
      e.update();
      e.drawme();
    }
  }
  
  MAXCHAIN = NEWCHAIN > MAXCHAIN ? NEWCHAIN : MAXCHAIN;
  fill(0, 255, 153);
  text(MAXCHAIN, 0, height - 10);
  fill(200);
  text(NEWCHAIN, 0, height - 20);
  fill(100);
  text(dotcount, 0, height - 30);
  fill(100);
  text((MAXEXPL-MINEXPL)/SHRINK, 0, height - 40);
  
}

void mousePressed() {
  if (expls.size() == 0) {
    float x = mouseX; 
    float y = mouseY;
    NEWCHAIN = 1;
    expls.add(new Explosion(x, y, MAXEXPL));
  }
  else {
    boolean finished = true;
    for (int i=0;i<expls.size();i++) {
      if (((Explosion)expls.get(i)).drawable) 
        finished = false;
    }
    if (finished) {
      expls = new LinkedList();
      mousePressed();
    }
    
  }
}

class Explosion {
  float x, y;
  float rad = .5, maxrad;
  List connections = new LinkedList();
  boolean drawable = true;
  Explosion(float _x,float _y,float _maxrad) {
    x = _x;
    y = _y;
    maxrad = _maxrad;
  }
  
  void update() {
    if (!drawable) return;
    rad += 3;
        
    if (rad > maxrad) {
      drawable = false;
      return;
    }
    
    for (int f=0;f<MAXDOTS;f++) {
      Dot d = dots[f];
      if (d.launched) {
        float da = (x-d.x), db = (y-d.y), dc = d.rad+rad; 
        if ((da * da + db * db) < (dc*dc)) {
          NEWCHAIN += 1;
          Explosion e = new Explosion(d.x, d.y, maxrad - SHRINK);
          connections.add(e);
          expls.add(e);
          d.launched = false;
        }
      }
    }
  }
  
  void drawme() {
    stroke(255);
    //beginShape();
    //vertex(x,y);
    for (int i=0; i < connections.size(); i++) {
      Explosion e = (Explosion)connections.get(i);
      line(x, y, e.x, e.y); 
      //vertex(e.x, e.y);
    }  
    //endShape();
    noStroke();
    noFill();
    if (drawable) { 
      fill(200, 30);
      ellipse(x,y,rad*2,rad*2);  
    }
  }
}

class Dot {
  float x,y,rad;
  float vx,vy;
  boolean launched;
  Dot() { 
   launched = false; 
  }  
  void launch() {
    x = random(1,width-1);
    y = random(0,1)>.5 ? 0 : height;
    vx = random(SPEED[0], SPEED[1]) * (random(0,1)>.5 ? -1 : 1);
    vy = random(SPEED[0], SPEED[1]);
    launched = true;
    rad = random(3, 18);
  }
  boolean update() {
    x += vx;
    y += vy;
    if (x < 0 || x > width) {
      vx *= -1;
    }
    else if (y < 0 || y > height) {
      vy *= -1;
    }
    return true;
  }  
  void drawme() {
    fill(200, 30);
    noStroke();
    ellipse(x,y,rad*2,rad*2);
  }
}


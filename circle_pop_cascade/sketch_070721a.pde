import java.util.List;

// int DOTCOL = 255;
int MAXDOTS = 90;
float[] SPEED = new float[] {.5, 3};
Dot[] dots = new Dot[MAXDOTS];
float MAXEXPL = 60;
float SHRINK = 2.5; // each propagated explosion will be SHRINK pixels smaller
List expls = new LinkedList();
Explosion expl;

void setup() {
  size(500, 450);
  frameRate(30);
  //smooth();
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
  
  if (dotcount == 0) {
    DONE = true;
  }
  else {
  int s = expls.size();
  if (s > 0) {
    for (int x=s-1; x >= 0;x--) {
      Explosion e = (Explosion)expls.get(x);
      MINEXPL = MINEXPL < e.maxrad ? MINEXPL : (int)e.maxrad;
      if (e.update())
        e.drawme();
      else
        expls.remove(x);      
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
}

void mousePressed() {
  if (expls.size() == 0) {
    float x = mouseX; 
    float y = mouseY;
    NEWCHAIN = 1;
    expls.add(new Explosion(x, y, MAXEXPL));
  }
}

class Explosion {
  float x, y;
  float rad = .5, maxrad;
  Explosion(float _x,float _y,float _maxrad) {
    x = _x;
    y = _y;
    maxrad = _maxrad;
  }
  
  boolean update() {
    rad *= 1.2 ;
    
    for (int f=0;f<MAXDOTS;f++) {
      Dot d = dots[f];
      if (d.launched) {
        float da = (x-d.x), db = (y-d.y), dc = d.rad+rad; 
        if ((da * da + db * db) < (dc*dc)) {
          NEWCHAIN += 1;
          expls.add(new Explosion(d.x, d.y, maxrad - SHRINK));
          d.launched = false;
        }
      }
    }
    
    if (rad > maxrad) {
      return false;
    }
    return true;
  }
  
  void drawme() {
    noFill();
    stroke(155,10,10);
    ellipse(x,y,rad*2,rad*2);
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
    rad = random(3, 8);
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
    fill(255);
    noStroke();
    ellipse(x,y,rad*2,rad*2);
  }
}

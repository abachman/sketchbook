import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class heart_drawing extends PApplet {

static int CMAX = 100;

public void setup() {
  size(800, 800, P2D);
  background(0);
  noFill();
  frameRate(30);
  colorMode(HSB, CMAX);
}

int mx = 0, c = 0;
int sc = 75;

public void draw() {
  // c = (c + 1) % CMAX;
  c = PApplet.parseInt(CMAX * ((mouseY * 1.0f) / height));
  stroke(c, CMAX, CMAX * 0.75f);

  // if (mx != mouseX) {
    // background(0);
    strokeWeight(150 * ((mouseX * 1.0f) / width));
    line(width/2, height - sc, sc, height/2);
    line(sc, height/2, width/4, sc);
    line(width/4, sc, width/2, height/2);
    line(width/2, height/2, width/4 * 3, sc);
    line(width/4 * 3, sc, width - sc, height/2);
    line(width - sc, height/2, width/2, height - sc);
    mx = mouseX;
  // }
}

public void keyPressed() {
  switch(key) {
    case ' ':
      save(millis() + ".png");
      break;
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "heart_drawing" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}

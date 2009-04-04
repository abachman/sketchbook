HoverTarget targ;
HoverTarget[] targs;
PFont font;

void setup() {
  size(400,400);
  targs = new HoverTarget[] {
    new HoverTarget(
      new float[][] {{100,100},{150,150},{100,200},{50, 150}}, 
      color(120, 50, 50)), 
    new HoverTarget(
      new float[][] {{150,150},{200,200},{150,250},{100,200}}, 
      color(50, 120, 50)),
    new HoverTarget(
      new float[][] {{100,200},{150,250},{100,300},{50,250}}, 
      color(50, 50, 120))
  };
      
  background(0);
  font = loadFont("Consolas-16.vlw"); 
  textFont(font, 16); 
}

void draw() {
  background(0);
  stroke(255);
  for (int n=0; n<targs.length; n++) {
    draw_thing(targs[n]);
  }
  
  if (pmouseX != mouseX || pmouseY != mouseY) {
    //text("pixel data", 10, 10);
    loadPixels();
    for (int n=0; n<targs.length; n++) {
      if (targs[n].check(mouseX, mouseY)) {
        targs[n].f = color(250);
      }
      else {
        targs[n].f = targs[n].d;
      }
    }
  }
}

void draw_thing(HoverTarget t) {
  fill(t.f);
  noStroke();
  beginShape(); 
  for (int i=0; i < t.points.length; i++) {
    vertex(t.points[i][0], t.points[i][1]);
  }  
  endShape();
}
  

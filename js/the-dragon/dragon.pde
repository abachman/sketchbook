// processing.js version
/*
    The dragon curve drawn using an L-system.
      variables : X Y
      constants : F + −
      start  : FX
      rules  : (X → X+YF+), (Y → -FX-Y)
      angle  : 90°

    Here, F means "draw forward", - means "turn left 90°", and + means "turn
    right 90°". X and Y do not correspond to any drawing action and are only
    used to control the evolution of the curve.
 */

class Pen {
  int x, y, q, fx, fy;
  int r = 3; // line length
  int turn = 90; // turn

  Pen() {
    reset();
  }

  void reset() {
    x = 0;
    y = 0;
    fx = 0;
    fy = 0;
    q = 0;
  }

  void draw_forward() {
    float t = q * (PI / 180.0);
    fx = x + round(r * sin(t));
    fy = y + round(r * cos(t));

    line(x, y, fx, fy);

    x = fx;
    y = fy;
  }

  void turn_left() {
    q -= turn;
  }

  void turn_right() {
    q += turn;
  }

  String state() {
    return "x:" + x + " y:" + y + " q:" + q;
  }
}

// return next string
String evolve (str) {
  var out_string = [];
  for (int i=0; i < str.length(); i++) {
    dragonRule(str[i], out_string);
  }
  return out_string.join('');
}

void dragonRule (c, out_string) {
  switch (c) {
    case "F":
      out_string.push("F");
      break;
    case "-":
      out_string.push("-");
      break;
    case "+":
      out_string.push("+");
      break;
    case "X":
      out_string.push("X+YF+");
      break;
    case "Y":
      out_string.push("-FX-Y");
      break;
  }
}

String s;
Pen pen;
float rot;
int instr;

void setup () {
  size(640, 640);
  frameRate(30);
  stroke(#aaccee);
  strokeWeight(1);
  background(#141414);

  int n = 0;
  s = "FX";
  pen = new Pen();
  while (n < 15) {
    s = evolve(s);
    n++;
  }
  print(s);
  rot = 0.0;
  instr = 0;
}

void draw () {
  translate(width/2, height/2);

  // several steps per draw loop
  for (int r=0; r < 32; r++) {
    if (instr < s.length()) {
      switch(s.charAt(instr)) {
        case "F":
          pen.draw_forward();
          break;
        case "-":
          pen.turn_left();
          break;
        case "+":
          pen.turn_right();
          break;
      }
    }
    instr++;
  }

}




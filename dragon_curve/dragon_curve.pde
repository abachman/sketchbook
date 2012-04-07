// pure processing version
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
  int r = 2; // line length
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

    // console.log("x:%f y:%f fx:%f fy:%f q:%i", x, y, fx, fy, q);

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
String evolve (String str) {
  StringBuffer out_string = new StringBuffer();
  for (int i=0; i < str.length(); i++) {
    dragonRule(str.charAt(i), out_string);
  }
  return out_string.toString();
}

void dragonRule (char c, StringBuffer out_string) {
  switch (c) {
    case 'F':
      out_string.append('F');
      break;
    case '-':
      out_string.append('-');
      break;
    case '+':
      out_string.append('+');
      break;
    case 'X':
      out_string.append("X+YF+");
      break;
    case 'Y':
      out_string.append("-FX-Y");
      break;
  }
}

String s;
Pen pen;
float rot;
int instr;

void setup () {
  size(440, 440);
  frameRate(30);
  stroke(#ffffff);
  background(#141414);

  int n = 0;
  s = "FX";
  pen = new Pen();
  while (n < 16) {
    s = evolve(s);
    n++;
  }
  print(s);
  rot = 0.0;
  instr = 0;
}

void draw () {
  translate(width/2, height/2);

  // four steps per draw loop
  for (int r=0; r<128; r++) {
    if (instr < s.length()) {
      switch(s.charAt(instr)) {
        case 'F':
          pen.draw_forward();
          break;
        case '-':
          pen.turn_left();
          break;
        case '+':
          pen.turn_right();
          break;
      }
    }
    instr++;
  }

}



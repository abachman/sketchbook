#include <Adafruit_CircuitPlayground.h>

void setup() {
  Serial.begin(9600);
  while (!Serial) {};
  
  CircuitPlayground.begin();
  CircuitPlayground.strip.show();
}

int xp_side[] = { 3, 4, 5, 6 };
int xn_side[] = { 8, 9, 0, 1 };

int yp_side[] = { 0, 1, 2, 3, 4 };
int yn_side[] = { 5, 6, 7, 8, 9 };

void loop() {
  // Check if the slide switch is enabled (on +) and if not then just exit out
  // and run the loop again.  This lets you turn on/off the mouse movement with
  // the slide switch.
  if (!CircuitPlayground.slideSwitch()) {
    return;
  }

  // Grab x, y acceleration values (in m/s^2).
  float x = CircuitPlayground.motionX();
  float y = CircuitPlayground.motionY();
  float z = CircuitPlayground.motionZ();

  CircuitPlayground.clearPixels();

  Serial.print(x); Serial.print(F(" ")); 
  Serial.print(y); Serial.print(F(" ")); 
  Serial.println(z); 

  tilt(-x, xp_side, xn_side, 4);
  tilt(y, yp_side, yn_side, 5);

  CircuitPlayground.strip.show();

  delay(100);
  /* 
  
  if (i != pi) {
    CircuitPlayground.strip.setPixelColor(pi, 0, 0, 0);
    pi = (pi + 1) % 10;
  }
  
  // put your main code here, to run repeatedly:
  CircuitPlayground.strip.setPixelColor(i, 255, 0, c);
  c = (c + 50) % 255;
  i = (i + 1) % 10;
  CircuitPlayground.strip.show();
  delay(1000);
  */
}

void tilt(float t, int *na, int *pa, int c) {
  int *arr;
  bool high = (t > 4) || (t < -4);
  if ( t > 0 ) {
    arr = na;
  } else {
    arr = pa;
  }

  int f = 0;
  int l = c - 1;
  
  for (int i=0; i < c; i++) {
    if (high && (i == f || i == l)) continue;
    CircuitPlayground.strip.setPixelColor(arr[i], 0, 0, 100);
  }
}


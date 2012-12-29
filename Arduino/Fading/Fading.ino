/*
 Fading
 
 This example shows how to fade an LED using the analogWrite() function.
 
 The circuit:
 * LED attached from digital pin 9 to ground.
 
 Created 1 Nov 2008
 By David A. Mellis
 modified 30 Aug 2011
 By Tom Igoe
 
 http://arduino.cc/en/Tutorial/Fading
 
 This example code is in the public domain.
 
 */

int red = 11;
int green = 10;
int blue = 9;

void setup()  { 
  // nothing happens in setup 
  randomSeed(analogRead(0));  
} 

long delayTime = 2; // 10 milliseconds = seconds 0.01
int maximumLevel = 200;

int colors[] = {red, green, blue};

void loop()  {
  // blinkLight(colors[0]);
  // blinkLight(colors[1]);
  // blinkLight(colors[2]);
  
  int colorIndex = random(0, 3);

  blinkLight(colors[colorIndex]);
}

void blinkLight(int color) {
  // delayTime = random(2, 10);  
  for (int n=0; n < maximumLevel; n++) {  
    analogWrite(color, maximumLevel - n);         
    delay(delayTime);
  }
}


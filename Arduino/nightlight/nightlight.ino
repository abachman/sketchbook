/*
 * A simple programme that will change the intensity of
 * an LED based on the amount of light incident on 
 * the photo resistor.
 * 
 */

//PhotoResistor Pin
int lightPin = 0; //the analog pin the photoresistor is 
                  //connected to
                  //the photoresistor is not calibrated to any units so
                  //this is simply a raw sensor value (relative light)
                  
//LED Pin
int rPin = 9;  //the pin the LED is connected to
               //we are controlling brightness so 
               //we use one of the PWM (pulse width
               // modulation pins)
int gPin = 10;
int bPin = 11;
                
void setup()
{
  Serial.begin(9600);
  pinMode(rPin, OUTPUT); //sets the led pin to output
  pinMode(gPin, OUTPUT); //sets the led pin to output
  pinMode(bPin, OUTPUT); //sets the led pin to output
}

// 100 == on pretty much all the time
// 800 == night only
#define THRESHOLD 100

/*
 * loop() - this function will start after setup 
 * finishes and then repeat
 */
void loop() {
  // Read the lightlevel
  int lightLevel = analogRead(lightPin); 
  Serial.print(lightLevel);
  Serial.print("\t");

  if (lightLevel > THRESHOLD) {
    nightlight();
    Serial.print(100);
  } else {
    light_off();
    Serial.print(0);
  }

  Serial.println("");
  delay(40);
}

void light_off() {
  analogWrite(rPin, 0);
  analogWrite(gPin, 0);
  analogWrite(bPin, 0);
}

int rlevel = 0;
int glevel = 0;
int blevel = 0;

// r  g  b
const int states[7][3] = {
  {0, 0, 1},
  {0, 1, 0},
  {1, 0, 0},
  {0, 1, 1},
  {1, 0, 1},
  {1, 1, 0},
  {1, 1, 1}
};

//                   r     g     b
const int pins[3] = {rPin, gPin, bPin};
int pinVal[3] = {0, 0, 0};

int currentState = 0;
const int MAX_STATE = 6;

int steps = 0;
const int TIMES_SLOWER = 60;

void nightlight() {

  // when I start, set "i" equal to 0
  // each time through, check to see if "i" is less than 3. while it is, keep going
  // each time through, after you finish the block of code, increase "i" by 1
  for (int i = 0; i < 3; i++) {
    bool on = states[currentState][i] == 1;
    if (on) {
      if (pinVal[i] < TIMES_SLOWER) pinVal[i]++;
    } else {
      if (pinVal[i] > 0) pinVal[i]--;
    }
    analogWrite(pins[i], map(pinVal[i], 0, TIMES_SLOWER, 0, 255));
  }

  steps++;
  if (steps == TIMES_SLOWER) {
    int nextState = random(7);
    while (nextState == currentState) { 
      nextState = random(7);
    }
    
    currentState = nextState;
    // currentState++;
    // if (currentState > MAX_STATE) currentState = 0;
    steps = 0;
  }
}

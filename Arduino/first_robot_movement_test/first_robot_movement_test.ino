#include <Servo.h>
#include <AFMotor.h>

/**************************************************** HelloRobot.ino: Initial Robot test sketch
Michael Margolis 4 July 2012
*****************************************************/

// include motor libraries
#include <AFMotor.h>     // adafruit motor shield library
#include <RobotMotor.h>  // 2wd or 4wd motor library

/***** Global Defines ****/
// defines to identify sensors
const int SENSE_IR_LEFT   = 0;
const int SENSE_IR_RIGHT  = 1;
const int SENSE_IR_CENTER = 2;
// defines for directions
const int DIR_LEFT   = 0;
const int DIR_RIGHT  = 1;
const int DIR_CENTER = 2;
const char* locationString[] = {"Left", "Right", "Center"};
// http://arduino.cc/en/Reference/String for more on character string arrays
// obstacles constants
const int OBST_NONE       = 0;  // no obstacle detected
const int OBST_LEFT_EDGE  = 1;  // left edge detected
const int OBST_RIGHT_EDGE = 2;  // right edge detected
const int OBST_FRONT_EDGE = 3;  // edge detect at both left and right sensors
const int LED_PIN = 13;
/**** End of Global Defines ****************/

// Setup runs at startup and is used configure pins and init system
// variables
void setup()
{
  Serial.begin(9600);
  blinkNumber(8); // open port while flashing. Needed for Leonardo only
  motorBegin(MOTOR_LEFT);
  motorBegin(MOTOR_RIGHT);
  irSensorBegin();    // initialize sensors
  pinMode(LED_PIN, OUTPUT); // enable the LED pin for output
  Serial.println("Waiting for a sensor to detect blocked reflection");
}
void loop() {
   // call a function when reflection blocked on left side
   if(lookForObstacle(OBST_LEFT_EDGE) == true)   {
     calibrateRotationRate(DIR_LEFT,360);  // calibrate CCW rotation
   }
   // as above for right sensor
   if(lookForObstacle(OBST_RIGHT_EDGE) == true)   {
     calibrateRotationRate(DIR_RIGHT, 360);  // calibrate CW rotation
   }
}
// function to indicate numbers by flashing the built-in LED
void blinkNumber( byte number) {
   pinMode(LED_PIN, OUTPUT); // enable the LED pin for output
   while(number--) {
     digitalWrite(LED_PIN, HIGH); delay(100);
     digitalWrite(LED_PIN, LOW);  delay(400);
   }
}
/**********************
 code to look for obstacles
**********************/
// returns true if the given obstacle is detected
boolean lookForObstacle(int obstacle)
{
  switch(obstacle) {
     case  OBST_FRONT_EDGE: return irEdgeDetect(DIR_LEFT) || irEdgeDetect(DIR_RIGHT);
     case  OBST_LEFT_EDGE:  return irEdgeDetect(DIR_LEFT);
     case  OBST_RIGHT_EDGE: return irEdgeDetect(DIR_RIGHT);
}
  return false;
}

/*
  Blink
  
  Turns on an LED on for one second, then off for one second, repeatedly.
 
  This example code is in the public domain.
 */
 
// Pin 13 has an LED connected on most Arduino boards.
// give it a name:
int pin13 = 13;
//int pin12 = 12;
//int pin11 = 11;

// the setup routine runs once when you press reset:
void setup() {                
  // initialize the digital pin as an output.
  pinMode(pin13, OUTPUT);
  //pinMode(pin12, OUTPUT);
  //pinMode(pin11, OUTPUT);
}

int delayTime = 1;

// the loop routine runs over and over again forever:
void loop() {
  digitalWrite(pin13, HIGH);   // turn the LED on (HIGH is the voltage level)
  delay(1000);               // wait for a second
  digitalWrite(pin13, LOW);    // turn the LED off by making the voltage LOW
  delay(500);
  
  // digitalWrite(pin12, HIGH);   // turn the LED on (HIGH is the voltage level)
  // delay(delayTime);               // wait for a second
  // digitalWrite(pin12, LOW);    // turn the LED off by making the voltage LOW
  
  // digitalWrite(pin11, HIGH);   // turn the LED on (HIGH is the voltage level)
  // delay(delayTime);               // wait for a second
  // digitalWrite(pin11, LOW);    // turn the LED off by making the voltage LOW
}

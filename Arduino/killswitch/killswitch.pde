/*
 */

const int buttonPin = 2;
const int blinkPin = 13;

int buttonState = LOW;
int spoken = LOW;

void setup()
{
  // initialize the serial communication:
  Serial.begin(9600);

  // initialize the ledPin as an output:
  pinMode(blinkPin, OUTPUT);

  // initialize the pushbutton pin as an input:
  pinMode(buttonPin, INPUT);
}

void loop() {
  byte brightness;

  // read the state of the pushbutton value:
  buttonState = digitalRead(buttonPin);

  // check if the pushbutton is pressed.
  if (buttonState == HIGH) {
    // turn LED on:
    digitalWrite(blinkPin, HIGH);
    if (spoken == LOW) {
      Serial.println("ok");
      spoken = HIGH;
    }
  } else {
    // turn LED off:
    digitalWrite(blinkPin, LOW);
    spoken = LOW;
  }
}

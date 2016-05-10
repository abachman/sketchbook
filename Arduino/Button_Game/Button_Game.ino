
// Init the Pins used for PWM
const int redPin = 11;
const int greenPin = 10;
const int bluePin = 9;

const int scoreNo  = 5;
const int scoreYes = 4;

// control
const int buttonPin   = 2;
int lastButtonState   = LOW;
int triggered         = LOW;
long lastDebounceTime = 0;  // the last time the output pin was toggled
long debounceDelay    = 50;    // the debounce time; increase if the output flickers
int buttonState;

int previousSecond = 0;
int currentSecond  = 0;

// game state
boolean winMode = false;
int score = 0;

void setup() {
  Serial.begin(9600);

  pinMode(redPin, OUTPUT);
  pinMode(greenPin, OUTPUT);
  pinMode(bluePin, OUTPUT);
  
  pinMode(scoreYes, OUTPUT);
  pinMode(scoreNo,  OUTPUT);
  
  pinMode(buttonPin, INPUT);
}

int colorStepRed = 0, colorStepGreen = 75, colorStepBlue = 150;

int stepDelay = 30000, curStep = 0;

void loop() {
  // digitalWrite(scoreYes, HIGH);
  // digitalWrite(scoreNo, HIGH);
  
  currentSecond = millis() / 1000;
 
  if (currentSecond != previousSecond) {
    choosePinState();
    
    analogWrite(redPin, colorStepRed);
    analogWrite(bluePin, colorStepBlue);
    analogWrite(greenPin, colorStepGreen);
    
    curStep = 0;
    previousSecond = currentSecond;
  } else {
    curStep += 1;
  }
  
  /// BUTTON STUFF
  
  // read the state of the pushbutton value:
  int reading = digitalRead(buttonPin);
  
  if (reading != lastButtonState) {
    lastDebounceTime = millis();
  }
  
  if ((millis() - lastDebounceTime) > debounceDelay) {
    // state change to un-pressed
    buttonState = reading;    
  }
  checkButtonPress();
  lastButtonState = reading;
}

void checkButtonPress() {
  if (buttonState == HIGH && triggered == LOW) {
    // state change to pressed
    // Serial.println("BANG");
    checkScore();
    triggered = HIGH;
  } else if (buttonState == LOW && triggered == HIGH) {
    // state change to un-pressed
    triggered = LOW;
  }
}

void checkScore() {
  if (winMode) {
    score += 1;
    Serial.println("POINT! ************");
    Serial.println(score);
    
    // blink the scoreYes light score times.
    for (int i=0; i < score; i++) { 
      digitalWrite(scoreYes, HIGH);
      delay(400);
      digitalWrite(scoreYes, LOW);
      delay(400);
    }
    
    
  } else {
    score = 0;
    Serial.println("fail");
    digitalWrite(scoreNo, HIGH);
  }
  delay(1000);
  
  digitalWrite(scoreYes, LOW);
  digitalWrite(scoreNo,  LOW);
}

void choosePinState() {
  // colorStepRed   = 255;
  // colorStepBlue  = 255;
  // colorStepGreen = 255;
  
  colorStepRed   = random(10) > 4 ? 0 : 255;
  colorStepBlue  = random(10) > 4 ? 0 : 255;
  colorStepGreen = random(10) > 4 ? 0 : 255;
    
  if (colorStepRed == 255 && colorStepGreen == 255 && colorStepBlue == 255) {
    winMode = true;
  } else {
    winMode = false;
  }
}

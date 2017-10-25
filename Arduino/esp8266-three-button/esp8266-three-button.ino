/*
 */

// constants won't change. They're used here to
// set pin numbers:
const int ba = 14;
const int bb = 12;
const int bc = 13;

const int lg = 15;      // the number of the LED pin
const int lr = 16;      // the number of the LED pin

// variables will change:
int bas, bbs, bcs;         // variable for reading the pushbutton status

void setup() {
  Serial.begin(9600); 
  delay(100);
  
  // initialize the LED pin as an output:
  pinMode(lg, OUTPUT);
  pinMode(lr, OUTPUT);
  
  // initialize the pushbutton pin as an input:
  pinMode(ba, INPUT);
  pinMode(bb, INPUT);
  pinMode(bc, INPUT);
}

void showButtonState() {
  Serial.print(bas);
  Serial.print("\t");
  Serial.print(bbs);
  Serial.print("\t");
  Serial.println(bcs);
}

unsigned long curtime, nextime;

// keep LED on until
unsigned long off_at[2] = {0, 0};

// delay checking for button presses
unsigned long check_after[3] = {0, 0, 0};

#define LED_DELAY 100

void loop() {
  curtime = millis();
  
  // read the state of the pushbutton value:
  if (curtime > check_after[0]) {
    bas = digitalRead(ba);
  }
  if (curtime > check_after[1]) {
    bbs = digitalRead(bb);
  }
  if (curtime > check_after[2]) {
    bcs = digitalRead(bc);
  }

  // delayed shutoff
  if (curtime > off_at[0]) {
    digitalWrite(lg, LOW);
  }
  if (curtime > off_at[1]) {
    digitalWrite(lr, LOW);
  }
    
  // check if the pushbutton is pressed.
  // if it is, the buttonState is HIGH:
  nextime = curtime + LED_DELAY;
  if (bas == HIGH) {
    digitalWrite(lg, HIGH);
    digitalWrite(lr, HIGH);
    off_at[0] = nextime;
    off_at[1] = nextime;
    check_after[0] = nextime;
  } else if (bbs == HIGH) {
    digitalWrite(lg, HIGH);
    off_at[0] = nextime;
    check_after[1] = nextime;
  } else if (bcs == HIGH) {
    // digitalWrite(lg, HIGH);
    digitalWrite(lr, HIGH);
    off_at[1] = nextime;
    check_after[2] = nextime;
  }

  // reset all buttons to low
  bas = LOW;
  bbs = LOW;
  bcs = LOW;  
}


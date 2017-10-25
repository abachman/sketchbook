/************************* WiFi Access Point *********************************/

// #define WIFI_SSID       "normalnet"
// #define WIFI_PASS       "the bachman family"
#define WIFI_SSID       "susan.cello"
#define WIFI_PASS       "4124692590"
/************************* Adafruit IO Setup ********************************/

#define IO_USERNAME    "abachman"
#define IO_KEY         "5d416dc6972f4abebb1ab4a3ac681126"

/*************************** Client Setup ***********************************/

// set up the wifi client using the supplied ssid & pass:
#include "AdafruitIO_WiFi.h"
AdafruitIO_WiFi io(IO_USERNAME, IO_KEY, WIFI_SSID, WIFI_PASS);

// holds the boolean (true/false) state of the light
bool is_on = false;
bool was_on = false;

// tracking timing of LED on/off via button
unsigned long curtime, nextime;

int lights[] = {5, 15, 16};

// keep LED on until
unsigned long off_at[] = {0, 0, 0};

// delay checking for button presses
unsigned long check_after[] = {0, 0, 0};

int buttons[] = { 14, 12, 13 };
int button_states[] = { 0, 0, 0 };

// set up the 'light' feed
AdafruitIO_Feed *light = io.feed("light");

void setup() {

  // start serial monitor and wait for it to open
  Serial.begin(115200); 
  while(! Serial);
  
  for (int i=0; i < 3; i++) {
    // initialize the LED pin as an output:
    pinMode(lights[i], OUTPUT);
    // initialize the pushbutton pin as an input:
    pinMode(buttons[i], INPUT);
  }
  
  Serial.print("Connecting to Adafruit IO");

  // connect to io.adafruit.com
  io.connect();

    // attach a new message handler for the light feed.
  light->onMessage(handleLight);

  // wait for a connection
  while(io.status() < AIO_CONNECTED) {
    Serial.print(".");
    delay(500);
  }

  // we are connected
  Serial.println();
  Serial.println(io.statusText());
}

void showButtonState() {
  Serial.print(button_states[0]);
  Serial.print("\t");
  Serial.print(button_states[1]);
  Serial.print("\t");
  Serial.println(button_states[2]);
}


#define LED_DELAY 100

void loop() {
  // process messages and keep connection alive
  io.run();
  
  curtime = millis();

  showButtonState();

  for (int i=0; i < 3; i++) {
    // read button state
    if (curtime > check_after[i]) {
      button_states[i] = digitalRead(buttons[i]);
    }

    // turn off after delay
    if (curtime > off_at[i]) {
      digitalWrite(lights[i], LOW);
    }
  }
    
  // check if the pushbutton is pressed.
  // if it is, the buttonState is HIGH:
  nextime = curtime + LED_DELAY;
  for (int i=0; i < 3; i++) {
    if (button_states[i] == HIGH) {
      digitalWrite(lights[i], HIGH);
      off_at[i] = nextime;
      check_after[i] = nextime;
    }
  }
  
  // light is actually only controlled by IO
  if (is_on) {
    for (int i=0; i < 3; i++) {
      digitalWrite(lights[i], HIGH);
    }
    was_on = true;
  } else if (was_on) {
    for (int i=0; i < 3; i++) {
      digitalWrite(lights[i], LOW);
    }
    was_on = false;
  }
  // else {
  //  digitalWrite(lr, LOW);
  // }

  // reset all buttons to low
  for (int i=0; i < 3; i++) {
    button_states[i] = LOW;
  }
}

// you can set a separate message handler for a single feed,
// as we do in this example for the light feed
void handleLight(AdafruitIO_Data *data) {

  // print out the received light value
  Serial.print("received <- light ");

  // use the isTrue helper to get the
  // boolean state of the light
  if(data->isTrue()) {
    Serial.println("is on.");
    is_on = true;
  } else {
    Serial.println("is off.");
    is_on = false;
  }
}


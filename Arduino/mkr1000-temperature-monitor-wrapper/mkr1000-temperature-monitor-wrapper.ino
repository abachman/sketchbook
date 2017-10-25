
#include "config.h"

// temperature sensor
#include <DHT.h>


/*************************** NEOPIXEL */

#include <Adafruit_NeoPixel.h>
#ifdef __AVR__
#include <avr/power.h>
#endif

#define NEO_DATA_PIN 6
Adafruit_NeoPixel strip = Adafruit_NeoPixel(7, NEO_DATA_PIN, NEO_GRB + NEO_KHZ800);



/*************************** DHT22 */

#define DHTTYPE DHT22   // DHT 22  (AM2302)
#define DHTPIN 5
DHT dht(DHTPIN, DHTTYPE);



/*************************** Sketch Code ************************************/

#define IP_BYTE_0(x)  ip & 0xFF
#define IP_BYTE_1(x)  (ip >> 8) & 0xFF
#define IP_BYTE_2(x)  (ip >> 16) & 0xFF
#define IP_BYTE_3(x)  (ip >> 24) & 0xFF

void print_ip(IPAddress ip) {
  Serial.print(IP_BYTE_0(ip));
  Serial.print('.');
  Serial.print(IP_BYTE_1(ip));
  Serial.print('.');
  Serial.print(IP_BYTE_2(ip));
  Serial.print('.');
  Serial.print(IP_BYTE_3(ip));
  Serial.print('\n');
}

void setup_neo() {
  // start neopixel
  strip.begin();
  strip.setBrightness(128);
  strip.show(); // Initially, all pixels are 'off'
}

void setup_dht() {
  // start DHT (temp / humidity sensor)
  dht.begin();
}


// set up the feeds
// recv
AdafruitIO_Feed *light = io.feed("light");
// send
AdafruitIO_Feed *temperature = io.feed("temperature");
AdafruitIO_Feed *humidity = io.feed("humidity");
// AdafruitIO_Feed *updatedAt = io.feed("updated-at");

void handleLight();

void setup() {
  Serial.begin(115200);
  
  // the `while (!Serial)` causes the MKR1000 to hang if nothing 
  // ever connects to the Serial port to listen
  // while (!Serial) {} // wait for connection
  delay(1000);

  setup_neo();
  setup_dht();

  setRing(10, 10, 10);

  // attach a new message handler for the light feed.
  Serial.println("attaching message handler");
  light->onMessage(handleLight);

  // connect to io.adafruit.com
  Serial.println("connecting");
  io.connect();
  Serial.println("io.connect() called");
  
  // wait for a connection
  while(io.status() < AIO_CONNECTED) {
    Serial.print(".");
    delay(500);
  }

  setRing(0,0,0);
}


// timeout between temp data saves
const int update_temp_after = 60000;
bool rollover = false; // handle unsigned long overflow

bool is_on = false; // io says light on
bool is_actually_lit = false; // light has actually been turned on

// timeouts
unsigned long next_update = 0;
unsigned long confirm_light_off_at = 0;
unsigned long last_update = 0;

void loop() {
  io.run();

  if (millis() > next_update) {
    saveTemp();
  }

  if (millis() > confirm_light_off_at) {
    pulse();
  }

  if (is_on && !is_actually_lit) {
    setRing(0, 0, 100);
    is_actually_lit = true;
  } else if (!is_on && is_actually_lit) {
    setRing(0, 0, 0);
    is_actually_lit = false;
  }
}


int c_lvl = 0;
int d_lvl = 1;
void pulse() {
  // if not currently displaying confirmation light, pulse purple
  c_lvl = c_lvl + d_lvl;
  
  if (c_lvl == 15) {
    d_lvl = -1;
  } else if (c_lvl == 0) {
    d_lvl = 1;
  }

  setCenter(c_lvl, 0, c_lvl);
}


void saveTemp() {
  float h = dht.readHumidity();
  float f = dht.readTemperature(true);
  unsigned long start = millis();

  // Check if read failed and exit early (to try again).
  if (isnan(h) || isnan(f)) {
    Serial.println("Failed to read from DHT sensor!");
    delay(2000);
    return;
  }

  Serial.print("Humidity: ");
  Serial.print(h);
  Serial.print(" %\t");
  Serial.print("Temperature: ");
  Serial.print(f);
  Serial.print(" *F\n");
 
  if (!(temperature->save(f) && humidity->save(h))) {
    Serial.println(F("Publish Failed."));
  } else {
    Serial.println(F("Publish Success!"));
    setCenter(0, 100, 0);
    confirm_light_off_at = millis() + 1000;
  }
  
  next_update = millis() + update_temp_after;
  Serial.print("Next update at: ");
  Serial.println(next_update);

  Serial.print("Updated in: ");
  Serial.print(millis() - start);
  Serial.println("ms");
}


int i;

// set NP 1-7 
void setRing(int r, int g, int b) {
  for(i=1; i<strip.numPixels(); i++) {
    strip.setPixelColor(i, strip.Color(r, g, b));
  }
  strip.show();  
}

// set NP 0
void setCenter(int r, int g, int b) {
  strip.setPixelColor(0, strip.Color(r, g, b));
  strip.show();
}

// set all NPs
void setColor(int r, int g, int b) {
  // turn NP on
  for(i=0; i<strip.numPixels(); i++) {
    strip.setPixelColor(i, strip.Color(r, g, b));
  }
  strip.show();
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


#define MQTT_DEBUG 1

#include <Adafruit_SleepyDog.h>
#include <Adafruit_MQTT.h>
#include <Adafruit_MQTT_Client.h>
#include <WiFi101.h>
#include <WiFiSSLClient.h>

// temperature sensor
#include <DHT.h>

/************************* WiFi Access Point *********************************/

#define WLAN_SSID       "normalnet"
#define WLAN_PASS       "the bachman family"

WiFiSSLClient client;

/************************* Adafruit.io Setup *********************************/

#define PRODMODE 1

#ifdef PRODMODE

#define AIO_SERVER      "io.adafruit.com"
#define AIO_SERVERPORT  8883                   // use 8883 for SSL
#define AIO_USERNAME    "abachman"
#define AIO_PW          "5d416dc6972f4abebb1ab4a3ac681126"
#define AIO_TEMP_FEED   AIO_USERNAME "/feeds/temperature"
#define AIO_HUMID_FEED  AIO_USERNAME "/feeds/humidity"

#else

#define AIO_SERVER      "192.168.1.36"
#define AIO_SERVERPORT  1883                   // use 8883 for SSL
#define AIO_USERNAME    "test_username"
#define AIO_PW          "9268c9f020e64643aecd5d133865962e"
#define AIO_TEMP_FEED   AIO_USERNAME "/feeds/toast-temp"
#define AIO_HUMID_FEED  AIO_USERNAME "/feeds/toast-humid"

#endif

// Store the MQTT server, username, and password in flash memory.
// This is required for using the Adafruit MQTT library.
const char MQTT_SERVER[] PROGMEM    = AIO_SERVER;
const char MQTT_USERNAME[] PROGMEM  = AIO_USERNAME;
const char MQTT_PASSWORD[] PROGMEM  = AIO_PW;



// Setup the MQTT client class by passing in the WiFi client and MQTT server and login details.
Adafruit_MQTT_Client mqtt(&client, AIO_SERVER, AIO_SERVERPORT, 
                          "ab-mkr1k-weather-9dj3qp", AIO_USERNAME, AIO_PW);

// io.adafruit.com SHA1 fingerprint (not verifiable with the MKR1000)
const char* fingerprint = "26 96 1C 2A 51 07 FD 15 80 96 93 AE F7 32 CE B9 0D 01 55 C4";

/****************************** Feeds ***************************************/

// Notice MQTT paths for AIO follow the form: <username>/feeds/<feedname>
const char AIO_TEMP[] PROGMEM  = AIO_TEMP_FEED;
const char AIO_HUMID[] PROGMEM = AIO_HUMID_FEED;

Adafruit_MQTT_Publish tempFeed  = Adafruit_MQTT_Publish(&mqtt, AIO_TEMP);
Adafruit_MQTT_Publish humidFeed = Adafruit_MQTT_Publish(&mqtt, AIO_HUMID);


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

// Bug workaround for Arduino 1.6.6, it seems to need a function declaration
// for some reason (only affects ESP8266, likely an arduino-builder bug).
void MQTT_connect();

void setup() {
  Serial.begin(115200);
  // while (!Serial) {} // wait for connection

  setup_neo();
  
  // Connect to WiFi access point.
  Serial.print(F("Connecting to "));
  Serial.println(WLAN_SSID);

  setColor(255, 0, 0);
  delay(1000);

  WiFi.begin(WLAN_SSID, WLAN_PASS);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(F("."));
  }
  Serial.println();

  Serial.println(F("WiFi connected"));
  Serial.print(F("IP address: ")); print_ip(WiFi.localIP());

  setColor(0, 255, 0);
  delay(1000);
  
  setup_dht();

  setColor(0, 0, 255);
  delay(1000);
}

const int update_temp_after = 60000;
unsigned long next_update = 0;
unsigned long confirm_light_off_at = 0;
unsigned long last_update = 0;

bool rollover = false; // handle unsigned long overflow
 
void loop() {
  // Ensure the connection to the MQTT server is alive (this will make the first
  // connection and automatically reconnect when disconnected).  See the MQTT_connect
  // function definition further below.
  MQTT_connect();

  if (millis() > next_update) {
     
    float h = dht.readHumidity();
    float f = dht.readTemperature(true);
  
    // Check if read failed and exit early (to try again).
    if (isnan(h) || isnan(f)) {
      Serial.println("Failed to read from DHT sensor!");
      delay(1000);
      return;
    }
  
    Serial.print("Humidity: ");
    Serial.print(h);
    Serial.print(" %\t");
    Serial.print("Temperature: ");
    Serial.print(f);
    Serial.print(" *F\n");
   
    if (!tempFeed.publish(f) || !humidFeed.publish(h)) {
      Serial.println(F("Publish Failed."));
    } else {
      Serial.println(F("Publish Success!"));
      setColor(0, 100, 0);
      delay(500);
      setColor(0, 0, 0);
    }

    next_update = millis() + update_temp_after;

  } else {
    Serial.print(next_update - millis());
    Serial.println("ms remain");
    setColor(100, 0, 200);
    delay(300);
    setColor(0, 0, 0);
  }

  delay(5000);
}

// Function to connect and reconnect as necessary to the MQTT server.
// Should be called in the loop function and it will take care if connecting.
void MQTT_connect() {
  int8_t ret;

  // Stop if already connected.
  if (mqtt.connected()) {
    return;
  }

  Serial.print(F("Connecting to MQTT... "));

  uint8_t retries = 3;
  while ((ret = mqtt.connect()) != 0) { // connect will return 0 for connected
       Serial.println(mqtt.connectErrorString(ret));
       Serial.println(F("Retrying MQTT connection in 5 seconds..."));
       mqtt.disconnect();
       delay(5000);  // wait 5 seconds
       retries--;
       if (retries == 0) {
         Serial.println("ABANDON SHIP");
         // basically die and wait for WDT to reset me
         while (1);
       }
  }
  Serial.println(F("MQTT Connected!"));
}

int i;

void setColor(int r, int g, int b) {
  // turn NP on
  for(i=0; i<strip.numPixels(); i++) {
    strip.setPixelColor(i, strip.Color(r, g, b));
  }
  strip.show();
}

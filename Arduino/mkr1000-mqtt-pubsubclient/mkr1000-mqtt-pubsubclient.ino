
/* 
#include <Adafruit_SleepyDog.h>
#include <Adafruit_MQTT.h>
#include <Adafruit_MQTT_Client.h>
*/

#include <SPI.h>
#include <WiFi101.h>

/************************* WiFi Access Point *********************************/

#define WLAN_SSID       "normalnet"
#define WLAN_PASS       "the bachman family"

// MQTT

#define ARB_SERVER      "192.168.1.36"
#define ARB_SERVERPORT  1883
#define ARB_USERNAME    "test_username"
#define ARB_PW          "631567d2103140dab3797ad4c9a25318"

WiFiSSLClient client;

// Store the MQTT server, username, and password in flash memory.
// This is required for using the Adafruit MQTT library.
const char MQTT_SERVER[] PROGMEM    = ARB_SERVER;
const char MQTT_USERNAME[] PROGMEM  = ARB_USERNAME;
const char MQTT_PASSWORD[] PROGMEM  = ARB_PW;

// Setup the MQTT client class by passing in the WiFi client and MQTT server and login details.
Adafruit_MQTT_Client mqtt(&client, MQTT_SERVER, ARB_SERVERPORT, MQTT_USERNAME, MQTT_PASSWORD);

/****************************** Feeds ***************************************/

// Setup a feed called 'arb_packet' for publishing.
// Notice MQTT paths for AIO follow the form: <username>/feeds/<feedname>
const char ARB_FEED[] PROGMEM = "/feeds/arb_packet";
Adafruit_MQTT_Publish ap = Adafruit_MQTT_Publish(&mqtt, ARB_FEED);

// Arbitrary Payload
// Union allows for easier interaction of members in struct form with easy publishing
// of "raw" bytes
typedef union{
    //Customize struct with whatever variables/types you like.
    struct __attribute__((__packed__)){  // packed to eliminate padding for easier parsing.
        char charAry[10];
        int16_t val1;
        unsigned long val2;
        uint16_t val3;
    }s;

    uint8_t raw[sizeof(s)];                    // For publishing
} packet_t;

/*************************** Sketch Code ************************************/

#define BYTE_0(x)  ip & 0xFF
#define BYTE_1(x)  (ip >> 8) & 0xFF
#define BYTE_2(x)  (ip >> 16) & 0xFF
#define BYTE_3(x)  (ip >> 24) & 0xFF

void print_ip(IPAddress ip) {
  Serial.print(BYTE_0(ip));
  Serial.print('.');
  Serial.print(BYTE_1(ip));
  Serial.print('.');
  Serial.print(BYTE_2(ip));
  Serial.print('.');
  Serial.print(BYTE_3(ip));
  Serial.print('\n');
}

// Bug workaround for Arduino 1.6.6, it seems to need a function declaration
// for some reason (only affects ESP8266, likely an arduino-builder bug).
void MQTT_connect();

void setup() {
  Serial.begin(9600);
  delay(10);

  Serial.println(F("Adafruit MQTT demo"));

  // Connect to WiFi access point.
  Serial.println(); Serial.println();
  Serial.print(F("Connecting to "));
  Serial.println(WLAN_SSID);

  WiFi.begin(WLAN_SSID, WLAN_PASS);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(F("."));
  }
  Serial.println();

  Serial.println(F("WiFi connected"));
  Serial.println(F("IP address: ")); print_ip(WiFi.localIP());
}

packet_t arbPac;

const char strVal[] PROGMEM = "Hello!";

void loop() {
  // Ensure the connection to the MQTT server is alive (this will make the first
  // connection and automatically reconnect when disconnected).  See the MQTT_connect
  // function definition further below.
  MQTT_connect();

  //Update arbitrary packet values
  strcpy_P(arbPac.s.charAry, strVal);
  arbPac.s.val1 = -4533;
  arbPac.s.val2 = millis();
  arbPac.s.val3 = 3354;

  if (! ap.publish(arbPac.raw, sizeof(packet_t))) {
    Serial.println(F("Publish Failed."));
  } else {
    Serial.println(F("Publish Success!"));
    delay(500);
  }

  delay(10000);
  /*
  if(! mqtt.ping()) {
    mqtt.disconnect();
  }
  */
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
         // basically die and wait for WDT to reset me
         while (1);
       }
  }
  Serial.println(F("MQTT Connected!"));
}

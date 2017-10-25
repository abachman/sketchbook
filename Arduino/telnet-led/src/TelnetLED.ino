#include <WiFi101.h>
#include <WiFiClient.h>
#include <WiFiServer.h>
// #include <WiFiMDNSResponder.h>
// #include <WiFiSSLClient.h>
// #include <WiFiUdp.h>

//SSID of your network
char ssid[] = "normalnet";
//password of your WPA Network
char pass[] = "the bachman family";

// WiFi connection status
int status = WL_IDLE_STATUS;

// start server on the default telnet port
int port = 23;
WiFiServer server(port);


#include <Adafruit_NeoPixel.h>
#ifdef __AVR__
#include <avr/power.h>
#endif

#define NEO_DATA_PIN 6

// Parameter 1 = number of pixels in strip
// Parameter 2 = Arduino pin number (most are valid)
// Parameter 3 = pixel type flags, add together as needed:
//   NEO_KHZ800  800 KHz bitstream (most NeoPixel products w/WS2812 LEDs)
//   NEO_KHZ400  400 KHz (classic 'v1' (not v2) FLORA pixels, WS2811 drivers)
//   NEO_GRB     Pixels are wired for GRB bitstream (most NeoPixel products)
//   NEO_RGB     Pixels are wired for RGB bitstream (v1 FLORA pixels, not v2)
//   NEO_RGBW    Pixels are wired for RGBW bitstream (NeoPixel RGBW products)
Adafruit_NeoPixel strip = Adafruit_NeoPixel(7, NEO_DATA_PIN, NEO_GRB + NEO_KHZ800);


// the setup function runs once when you press reset or power the board
void setup() {
  // initialize digital pin 6 as an output, since it controls the onboard LED on the MKR1000
  Serial.begin(9600);

  // attempt to connect to Wifi network:
  while ( status != WL_CONNECTED) {
    Serial.print("Attempting to connect to SSID: ");
    Serial.println(ssid);

    delay(1000);

    // Connect to WPA/WPA2 network. Change this line if using open or WEP network:
    status = WiFi.begin(ssid, pass);

    // wait 10 seconds for connection:
    delay(5000);
  }

  Serial.print("IP Address: ");
  print_ip(WiFi.localIP());

  // start the server:
  server.begin();

  // start neopixel
  strip.begin();
  strip.setBrightness(128);
  strip.show(); // Initially, all pixels are 'off'
}

void print_ip(IPAddress ip)
{
  unsigned char bytes[4];
  bytes[0] = ip & 0xFF;
  bytes[1] = (ip >> 8) & 0xFF;
  bytes[2] = (ip >> 16) & 0xFF;
  bytes[3] = (ip >> 24) & 0xFF;
  Serial.print(bytes[0]);
  Serial.print('.');
  Serial.print(bytes[1]);
  Serial.print('.');
  Serial.print(bytes[2]);
  Serial.print('.');
  Serial.println(bytes[3]);
}

// track whether or not the client was connected previously
boolean alreadyConnected = false;

uint32_t magenta = strip.Color(255, 0, 255);
uint32_t nocolor = strip.Color(0, 0, 0);
int i;

// the loop function runs over and over again forever
void loop() {
  // wait for a new client:
  WiFiClient client = server.available();

  // when the client sends the first byte, say hello:
  if (client) {
    // turn NP on
    for(i=0; i<strip.numPixels(); i++) {
      strip.setPixelColor(i, magenta);
    }
    strip.show();

    if (!alreadyConnected) {
      // clead out the input buffer:
      client.flush();
      Serial.println("We have a new client");
      client.println("Hello, client!");
      alreadyConnected = true;
    }

    if (client.available() > 0) {
      // read the bytes incoming from the client:
      char thisChar = client.read();

      // echo the bytes back to the client:
      server.write(thisChar);

      Serial.print("char received: ");
      Serial.print(thisChar);
      if (isPrintable(thisChar)) {
        Serial.println(" (printable)");
      }
    }

    for(i=0; i<strip.numPixels(); i++) {
      strip.setPixelColor(i, nocolor);
    }
    strip.show();
    delay(200);
  }
}

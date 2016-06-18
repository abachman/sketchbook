#include <WiFi101.h>
// #include <WiFiClient.h>
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

// start server on PORT
int port = 23;
WiFiServer server(port);

#include <Adafruit_NeoPixel.h>
#ifdef __AVR__
#include <avr/power.h>
#endif

#define NEO_DATA_PIN 6

Adafruit_NeoPixel strip = Adafruit_NeoPixel(7, NEO_DATA_PIN, NEO_GRB + NEO_KHZ800);

// the setup function runs once when you press reset or power the board
void setup() {
  // initialize digital pin 6 as an output, since it controls the
  // onboard LED on the MKR1000
  Serial.begin(9600);

  // attempt to connect to Wifi network:
  // while ( status != WL_CONNECTED) {
  Serial.print("Attempting to connect to SSID: ");
  Serial.println(ssid);

  delay(100);

  // Connect to WPA/WPA2 network. Change this line if using open or WEP network:
  status = WiFi.begin(ssid, pass);

    // wait 10 seconds for connection:
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.print('.');
  }
  Serial.println();

  Serial.print("Connected! IP Address: ");
  print_ip(WiFi.localIP());

  // start the server:
  server.begin();

  // start neopixel
  strip.begin();
  strip.setBrightness(128);
  strip.show(); // Initially, all pixels are 'off'
}

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

int i;

void setColor(int r, int g, int b) {
  // turn NP on
  for(i=0; i<strip.numPixels(); i++) {
    strip.setPixelColor(i, strip.Color(r, g, b));
  }
  strip.show();
}

// the loop function runs over and over again forever
void loop() {
  // wait for a new client:
  WiFiClient client = server.available();

  // when the client sends the first byte, say hello:
  if (client) {
    Serial.println("new client");
    char col[3];
    int  idx = 0;
    while (client.connected()) {
      if (client.available()) {
        char c = client.read();
        // Serial.write(c);
        if (c == '\n' || idx > 2) {
          // ignore / reset
          client.stop();

          Serial.print(F("received '"));
          char hex_color[7];
          sprintf(hex_color, "%02X%02X%02X", col[0], col[1], col[2]);
          Serial.print(hex_color);
          setColor(col[0], col[1], col[2]);
          Serial.println("' closing");
        } else {
          col[idx] = c;
          idx++;
        }
      }
    }

    Serial.println("wait for client");
  }

  /*


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
  */
}

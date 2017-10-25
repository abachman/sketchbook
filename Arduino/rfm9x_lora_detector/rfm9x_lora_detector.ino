#include <Adafruit_NeoPixel.h>

#include <SPI.h>
#include <RH_RF95.h>

// Singleton instance of the radio driver
#define RF95_FREQ 900.0 

/* for feather32u4 */
#define RFM95_CS 8
#define RFM95_RST 4
#define RFM95_INT 7

// Singleton instance of the radio driver
RH_RF95 rf95(RFM95_CS, RFM95_INT);

void rfmSetup() {
  
  Serial.println("Feather LoRa TX Test!");

  pinMode(RFM95_RST, OUTPUT);
  digitalWrite(RFM95_RST, HIGH);

  // manual reset
  digitalWrite(RFM95_RST, LOW);
  delay(10);
  digitalWrite(RFM95_RST, HIGH);
  delay(10);
 
  while (!rf95.init()) {
    Serial.println("LoRa radio init failed");
    while (1);
  }
  Serial.println("LoRa radio init OK!");

  // Defaults after init are 434.0MHz, modulation GFSK_Rb250Fd250, +13dbM
  if (!rf95.setFrequency(RF95_FREQ)) {
    Serial.println("setFrequency failed");
    while (1);
  }
  Serial.print("Set Freq to: "); Serial.println(RF95_FREQ);
  
  // If you are using RFM95/96/97/98 modules which uses the PA_BOOST transmitter pin, then 
  // you can set transmitter powers from 5 to 23 dBm:
  rf95.setTxPower(23, false);
  
}

#define NEO_PIN 2
#define NEO_COUNT 32

// Parameter 1 = number of pixels in strip
// Parameter 2 = pin number (most are valid)
// Parameter 3 = pixel type flags, add together as needed:
//   NEO_KHZ800  800 KHz bitstream (most NeoPixel products w/WS2812 LEDs)
//   NEO_KHZ400  400 KHz (classic 'v1' (not v2) FLORA pixels, WS2811 drivers)
//   NEO_GRB     Pixels are wired for GRB bitstream (most NeoPixel products)
//   NEO_RGB     Pixels are wired for RGB bitstream (v1 FLORA pixels, not v2)
Adafruit_NeoPixel strip = Adafruit_NeoPixel(NEO_COUNT, NEO_PIN, NEO_GRB + NEO_KHZ800);

void setup() {
  delay(200);
  Serial.begin(9600);
  delay(100);

  rfmSetup();
  
  // put your setup code here, to run once:
  strip.begin();
  strip.setBrightness(64);
  strip.show(); // Initialize all pixels to 'off'

  Serial.println("neo up");

}

int n = 0;
int on = 0;
int red = 128;
int green = 128; 
int blue = 128;

int16_t packetnum = 0;  // packet counter, we increment per xmission


void blinker(uint8_t r, uint8_t g, uint8_t b) {
  for (int i=0; i < 3; i++) {
    for (int p=0; p < 8; p++) {
      strip.setPixelColor(p, r, g, b);
    }
    strip.show();
    delay(100);
    for (int p=0; p < 8; p++) {
      strip.setPixelColor(p, 0, 0, 0);
    }
    strip.show();
    delay(100);
  }
}

void loop() {

  char radiopacket[20] = "Hello World #      ";
  itoa(packetnum++, radiopacket+13, 10);
  Serial.print("Sending "); Serial.println(radiopacket);
  radiopacket[19] = 0;
  
  Serial.println("Sending..."); delay(10);
  rf95.send((uint8_t *)radiopacket, 20);
 
  Serial.println("Waiting for packet to complete..."); delay(10);
  rf95.waitPacketSent();
  // Now wait for a reply
  uint8_t buf[RH_RF95_MAX_MESSAGE_LEN];
  uint8_t len = sizeof(buf);


  blinker(0, 0, 128);

  Serial.println("Waiting for reply..."); delay(10);
  if (rf95.waitAvailableTimeout(1000)) { 
    // Should be a reply message for us now   
    if (rf95.recv(buf, &len)) {      
      Serial.print("Got reply: ");
      Serial.println((char*)buf);
      Serial.print("RSSI: ");
      Serial.println(rf95.lastRssi(), DEC);    

      blinker(0, 255, 0);
    } else {
      Serial.println("recv failed");
      blinker(255, 0, 255);
    }
  } else {
    blinker(255, 0, 0);
    Serial.println("No reply, is rf95_server running?");
  }
  delay(1000);
  
}

/*  this is how I type now */

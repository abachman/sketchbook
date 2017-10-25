#include <AdafruitIO.h>

// Specifically for use with the Adafruit Feather, the pins are pre-set here!

// include SPI, MP3 and SD libraries
#include <SPI.h>
#include <SD.h>
#include <Adafruit_VS1053.h>
#include <IRrecv.h>
#include <IRutils.h>

#include "io_setup.h"

// These are the pins used
#define VS1053_RESET   -1     // VS1053 reset pin (not used!)

// Feather ESP8266
#if defined(ESP8266)
  #define VS1053_CS      16     // VS1053 chip select pin (output)
  #define VS1053_DCS     15     // VS1053 Data/command select pin (output)
  #define CARDCS          2     // Card chip select pin
  #define VS1053_DREQ     0     // VS1053 Data request, ideally an Interrupt pin
#endif
 
// Connect a 38KHz remote control sensor to the pin below
// An IR detector/demodulator is connected to GPIO pin 4
uint16_t RECV_PIN = 4;
// As this program is a special purpose capture/decoder, let us use a larger
// than normal buffer so we can handle Air Conditioner remote codes.
uint16_t CAPTURE_BUFFER_SIZE = 1024;

// Nr. of milli-Seconds of no-more-data before we consider a message ended.
// NOTE: Don't exceed MAX_TIMEOUT_MS. Typically 130ms.
#define TIMEOUT 15U  // Suits most messages, while not swallowing repeats.

// Use turn on the save buffer feature for more complete capture coverage.
IRrecv irrecv(RECV_PIN, CAPTURE_BUFFER_SIZE, TIMEOUT, true);
// #define RECV_PIN 4 //an IR detector/demodulatord is connected to GPIO pin 2
// IRrecv irrecv(RECV_PIN);

Adafruit_VS1053_FilePlayer musicPlayer = 
  Adafruit_VS1053_FilePlayer(VS1053_RESET, VS1053_CS, VS1053_DCS, VS1053_DREQ, CARDCS);

// set up the 'counter' feed
AdafruitIO_Feed *volume = io.feed("volume");

// set up the 'counter-two' feed
AdafruitIO_Feed *control = io.feed("control");

AdafruitIO_Feed *actions = io.feed("actions");

void setup() {
  Serial.begin(115200);

  // if you're using Bluefruit or LoRa/RFM Feather, disable the BLE interface
  //pinMode(8, INPUT_PULLUP);

  // Wait for serial port to be opened, remove this line for 'standalone' operation
  // while (!Serial) { delay(1); }

  Serial.println("\n\nAdafruit VS1053 Feather Test");
  
  if (! musicPlayer.begin()) { // initialise the music player
     Serial.println(F("Couldn't find VS1053, do you have the right pins defined?"));
     while (1);
  }

  Serial.println(F("VS1053 found"));
 
  musicPlayer.sineTest(0x44, 500);    // Make a tone to indicate VS1053 is working
  
  if (!SD.begin(CARDCS)) {
    Serial.println(F("SD failed, or not present"));
    while (1);  // don't do anything more
  }
  Serial.println("SD OK!");

  // Set volume for left, right channels. lower numbers == louder volume!
  musicPlayer.setVolume(10,10);

  // list files
  // printDirectory(SD.open("/"), 0);

  // connect to io.adafruit.com
  io.connect();

  // attach the same message handler for the second counter feed.
  control->onMessage(handleControl);

  // attach a new message handler for the volume feed.
  volume->onMessage(handleVolume);

  // wait for a connection
  while(io.status() < AIO_CONNECTED) {
    Serial.print(".");
    delay(500);
  }

  Serial.println("");
  Serial.println(io.statusText());

  // irrecv.enableIRIn(); // Start the receiver
  
  musicPlayer.sineTest(0x88, 500);    // Make a tone to indicate VS1053 is connected
  
#if defined(__AVR_ATmega32U4__) 
  // Timer interrupts are not suggested, better to use DREQ interrupt!
  // but we don't have them on the 32u4 feather...
  Serial.println("32u4 interrupts prepared");  
  musicPlayer.useInterrupt(VS1053_FILEPLAYER_TIMER0_INT); // timer int
#elif defined(ESP32)
  // no IRQ! doesn't work yet :/
  Serial.println("ESP32 - no interrupts available!");  
#else
  // If DREQ is on an interrupt pin we can do background
  // audio playing
  musicPlayer.useInterrupt(VS1053_FILEPLAYER_PIN_INT);  // DREQ int
  Serial.println("use DREQ interrupt pin");  
#endif

  actions->save((char *)"booted up");
}

String playlist[] = {
  "sureshot.mp3",
  "wndowlkr.mp3",
  "brothaz.mp3",
  "birdhous.mp3",
  "girl-boy.mp3"
};
int tracks = 5;
int playlistIndex = 0;
bool isPlaying = false;
bool doStop = false; // track forced stops

void startPlaylist() {
   /* 
    WNDOWLKR.MP3  11257741
    BROTHAZ.MP3    7801056
    BIRDHOUS.MP3   3578255
    SURESHOT.MP3   3166321
    GIRL-BOY.MP3   4659783
   */
  
  // Play a file in the background, REQUIRES interrupts!
  String sTrack = playlist[playlistIndex];
  int trackLen = sTrack.length() + 1;
  char track[trackLen];
  sTrack.toCharArray(track, trackLen);
  musicPlayer.startPlayingFile(track);
  
  String state = "playing ";
  state.concat(track);
  actions->save(state);

  isPlaying = true;
}

int loops = 0;
int lastcode = -1;
decode_results ir_results;

int irHexToInt(uint64_t inval) {
  switch (inval) {
    case 0xFD00FF: return 0; // vol -
    case 0xFD807F: return 1; // play pause
    case 0xFD40BF: return 2; // vol +

    // case 0xFD20DF: return 3;
    // case 0xFDA05F: return 4;
    case 0xFD609F: return 5; // stop

    case 0xFD10EF: return 6; // left 
    case 0xFD50AF: return 8; // right

    // repeat code
    case 0xFFFFFFFF: return -1;  

    // ignore
    default: 
      // Show Code & length
      Serial.print("unrecognized code: ");
      serialPrintUint64(inval, 16);
      return -2;
  }
}

void loop() {
  if(digitalRead(VS1053_DREQ) && !musicPlayer.stopped() && isPlaying) {
    musicPlayer.feedBuffer();
  } 

  // process messages and keep connection alive
  io.run();

  /*

  // look for a message!
  if (irrecv.decode(&ir_results)) {
    controlPlayer(irHexToInt(ir_results.value));
    irrecv.resume(); // Receive the next value
  }

  */

  // File is playing in the background, set flag when it stops
  if (isPlaying && musicPlayer.stopped()) {
    actions->save((char *)"stopped");
    isPlaying = false;
  }
  
  delay(1000);

  loops++;
  if (loops % 50 == 0) {
    Serial.print(millis());
    Serial.print(" ");
    Serial.println(io.statusText());
  }
  
}


// you can set a separate message handler for a single feed,
// as we do in this example for the light feed
void handleVolume(AdafruitIO_Data *data) {

  // print out the received light value
  Serial.print("received <- volume ");

  // use the isTrue helper to get the
  // boolean state of the light
  float setting = data->toFloat();
  
  Serial.println(setting);

  float level = map(setting, 0.0, 20.0, 20.0, 0.0); 

  // Set volume for left, right channels. lower numbers == louder volume!
  musicPlayer.setVolume(level, level);
  String state = "volume ";
  state.concat(level);
  actions->save(state);

  Serial.println("handling complete");
}

// you can also attach multiple feeds to the same
// meesage handler function. both counter and counter-two
// are attached to this callback function, and messages
// for both will be received by this function.
void handleControl(AdafruitIO_Data *data) {

  Serial.print("received <- ");

  int command = data->toInt();
  
  // since we are using the same function to handle
  // messages for two feeds, we can use feedName() in
  // order to find out which feed the message came from.
  Serial.print(data->feedName());
  Serial.print(" ");

  controlPlayer(command);

  Serial.println("handling complete");
}

void controlPlayer(int command) {
  // print out the received count or counter-two value
  Serial.print("controlPlayer ");
  Serial.println(command);

  if (command == 0) {
    musicPlayer.stopPlaying();
    isPlaying = false;
    doStop = true;
    actions->save((char *)"stopped");
  } else if (command == 1) {
    if (!musicPlayer.playingMusic) {
      startPlaylist();
    } else if (!musicPlayer.paused()) {
      Serial.println("Paused");
      musicPlayer.pausePlaying(true);
      isPlaying = false;
      actions->save((char *)"paused");
    } else { 
      Serial.println("Resumed");
      musicPlayer.pausePlaying(false);
      actions->save((char *)"resumed");
    }
  } else if (command == 2) {
    playlistIndex = (playlistIndex + 1) % tracks;
    musicPlayer.stopPlaying();
    delay(500);
    startPlaylist();
  }
}

/// File listing helper, can also be used to grab list of .mp3 files.
void printDirectory(File dir, int numTabs) {
   while(true) {
     
     File entry =  dir.openNextFile();
     if (! entry) {
       // no more files
       break;
     }
     for (uint8_t i=0; i<numTabs; i++) {
       Serial.print('\t');
     }
     Serial.print(entry.name());
     if (entry.isDirectory()) {
       Serial.println("/");
       printDirectory(entry, numTabs+1);
     } else {
       // files have sizes, directories do not
       Serial.print("\t\t");
       Serial.println(entry.size(), DEC);
     }
     entry.close();
   }
}



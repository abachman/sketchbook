/************************* WiFi Access Point *********************************/

#define WIFI_SSID       "normalnet"  // can't be longer than 32 characters!
#define WIFI_PASS       "the bachman family"

#define AIO_SERVER      "io.adafruit.com"
#define AIO_SERVERPORT  1883
#define IO_USERNAME  "abachman"
#define IO_KEY       "5d416dc6972f4abebb1ab4a3ac681126"


// comment out the following two lines if you are using fona or ethernet
#include "AdafruitIO_WiFi.h"
AdafruitIO_WiFi io(IO_USERNAME, IO_KEY, WIFI_SSID, WIFI_PASS);

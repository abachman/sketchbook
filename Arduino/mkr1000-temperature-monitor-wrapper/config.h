
/************************* WiFi Access Point *********************************/

#define WIFI_SSID       "normalnet"
#define WIFI_PASS       "the bachman family"

/************************* Adafruit.io Setup *********************************/

// PROD
#define IO_USERNAME    "abachman"
#define IO_KEY         "5d416dc6972f4abebb1ab4a3ac681126"

// DEV
// #define IO_USERNAME    "test_username"
// #define IO_KEY         "ceae759dd4594b1db73ca2c20551c81b"

// set up the wifi client using the supplied ssid & pass:
#include "AdafruitIO_WiFi.h"
AdafruitIO_WiFi io(IO_USERNAME, IO_KEY, WIFI_SSID, WIFI_PASS);


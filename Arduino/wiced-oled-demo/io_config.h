#define WLAN_SSID             "Foundery members"
#define WLAN_PASS             "timetobuild"

#define IO_USERNAME  "abachman"
#define IO_KEY       "5d416dc6972f4abebb1ab4a3ac681126"

#include <AdafruitIO_WiFi.h>
AdafruitIO_WiFi io(IO_USERNAME, IO_KEY, WLAN_SSID, WLAN_PASS);


/* 

Confirmed working, had to manually set the python executable in the 
Adafruit hardware support directory: 

  /Users/adam/Library/Arduino15/packages/adafruit/hardware/wiced/0.6.2/platform.txt

It works! 

2017-05-25

 */
// Base

#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_FeatherOLED.h>

#include "io_config.h"

#define VBAT_ENABLED              1
#define VBAT_PIN                  PA1

// STM32F2
#define BUTTON_A PA15
#define BUTTON_B PC7
#define BUTTON_C PC5
#define LED PB5

Adafruit_FeatherOLED oled = Adafruit_FeatherOLED();

AdafruitIO_Feed *fTemperature = io.feed("temperature");
AdafruitIO_Feed *fHumidity = io.feed("humidity");

float temperature = 0.0;
float humidity = 0.0;

void updateTemperature(AdafruitIO_Data *data) {
  Serial.print("received temp <- ");
  Serial.println(data->toFloat());
  temperature = data->toFloat();
}

void updateHumidity(AdafruitIO_Data *data) {
  Serial.print("received humid <- ");
  Serial.println(data->toFloat());
  humidity = data->toFloat();
}

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);

  oled.init();
  oled.setBatteryVisible(true);

  io.connect();

  fTemperature->onMessage(updateTemperature);
  fHumidity->onMessage(updateHumidity);

  // wait for a connection
  while(io.status() < AIO_CONNECTED) {
    Serial.print(".");
    delay(500);
  }

  // we are connected
  Serial.println();
  Serial.println(io.statusText());
  
  oled.init();
  oled.setBatteryVisible(true);
}

void loop() {
  // put your main code here, to run repeatedly:
  io.run();

  // clear the current count
  oled.clearDisplay();

  // get and render battery state
  float battery = getBatteryVoltage();
  oled.setBattery(battery);
  oled.renderBattery();

  // print the count value to the OLED
  oled.print("temperature: ");
  oled.println(temperature);
  oled.print("humidity:    ");
  oled.println(humidity); 

  // update the display with the new count
  oled.display();
  

  delay(1000);
}

float getBatteryVoltage() {

  pinMode(VBAT_PIN, INPUT_ANALOG);

  float measuredvbat = analogRead(VBAT_PIN);

  measuredvbat *= 2;         // we divided by 2, so multiply back
  measuredvbat *= 0.80566F;  // multiply by mV per LSB
  measuredvbat /= 1000;      // convert to voltage

  return measuredvbat;

}

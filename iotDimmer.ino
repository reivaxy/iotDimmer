/**
 *  iotinator Dimmer Slave module 
 *  Xavier Grosjean 2018
 *  Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International Public License
 */
 

#include <stdio.h>
#include "DimmerModule.h"

#include "config.h"

#define API_VERSION "1.0"    // modules can check API version to make sure they are compatible...

// Global object to store config
DimmerConfigClass *config;
XIOTModule* module;

int scl = 12;
int sda = 14;

bool temoin = true;
time_t lastTemoin = 0;
time_t startTime = 0;

void setup(){
  int intPin = 13;
  int ctrlPin = 5;
  startTime = millis();
  Serial.begin(9600);
  delay(500); // time to connect serial
  
  config = new DimmerConfigClass((unsigned int)CONFIG_VERSION, (char*)MODULE_NAME);
  config->init();
 
  module = new DimmerModule(config, 0x3C, sda, scl, intPin, ctrlPin);
  pinMode(15, OUTPUT);   
}

/*********************************
 * Main Loop
 *********************************/
void loop() {
  // Mandatory periodic call, to refresh display, Clock, check requests
  // on the http API, ...
  module->loop();
  time_t now = millis();
  
  // 50 Hz zero crossing simulation
  if(now - startTime > 30000) {
    if(now - lastTemoin > 20) {
      if(temoin) {
        digitalWrite(15, HIGH);
      } else {
        digitalWrite(15, LOW);
      }
      intHandler();
      lastTemoin = now;
      temoin = ! temoin;
    }  
  }
}


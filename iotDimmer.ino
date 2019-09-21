/**
 *  iotinator Dimmer Agent module
 *  Xavier Grosjean 2018
 *  Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International Public License
 */
 

#if F_CPU != 160000000
//  CPU FREQUENCY MUST BE SET TO 160MHz !!
#endif

#include <stdio.h>
#include "DimmerModule.h"

#include "config.h"

#define API_VERSION "1.0"    // modules can check API version to make sure they are compatible...

// Global object to store config
DimmerConfigClass *config;
XIOTModule* module;

int scl = 12;
int sda = 14;

void setup(){
  int intPin = 13;
  int ctrlPin = 5;
  
  // After a reset, interrupt handlers may still be operating ??
  detachInterrupt(digitalPinToInterrupt(intPin));

  Serial.begin(9600);
  delay(500); // time to connect serial
  
  config = new DimmerConfigClass((unsigned int)CONFIG_VERSION, (char*)MODULE_NAME);
  config->init();
 
  module = new DimmerModule(config, 0x3C, sda, scl, intPin, ctrlPin);
}

/*********************************
 * Main Loop
 *********************************/
void loop() {
  // Mandatory periodic call, to refresh display, Clock, check requests
  // on the http API, ...
  module->loop();
}


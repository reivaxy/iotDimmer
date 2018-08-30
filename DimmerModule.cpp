/**
 *  iotinator Dimmer Agent module
 *  Xavier Grosjean 2018
 *  Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International Public License
 */

#include "DimmerModule.h"
#include <FunctionalInterrupt.h>


DimmerModule::DimmerModule(DimmerConfigClass* config, int displayAddr, int displaySda, int displayScl, int intPin, int ctrlPinParam):XIOTModule(config, displayAddr, displaySda, displayScl) {
  pinMode(intPin, INPUT_PULLUP);
  _intPin = intPin;
  pinMode(ctrlPinParam, OUTPUT);
  _ctrlPin = ctrlPinParam;
  _oledDisplay->setLineAlignment(2, TEXT_ALIGN_CENTER);
  setLevel(config->getDefaultLevel());
  
}

void DimmerModule::customOnStaGotIpHandled(WiFiEventStationModeGotIP ipInfo) {
  Serial.println("Init interrupt handler");
  attachInterrupt(digitalPinToInterrupt(_intPin), std::bind(&DimmerModule::intHandler, this), RISING);

}

// Handler for the interruption received when crossing 0
// Code found on Amazon description of triac + zero crossing detection module
void DimmerModule::intHandler() {
  // Firing angle calculation : 1 full 50Hz wave =1/50=20ms
  // Every zerocrossing : (50Hz)-> 10ms (1/2 Cycle) For 60Hz (1/2 Cycle) => 8.33ms
  // 10ms=10000us
  if(_lightLevelDelay > 9600) {
    digitalWrite(_ctrlPin, LOW);    // triac Off
    return;
  }
  delayMicroseconds(_lightLevelDelay);    // Off cycle
  digitalWrite(_ctrlPin, HIGH);   // triac firing
  delayMicroseconds(10);         // triac On propogation delay (for 60Hz use 8.33)
  digitalWrite(_ctrlPin, LOW);    // triac Off
}

bool DimmerModule::customBeforeOTA() {
  Serial.println("Detaching interrupts for OTA");
  detachInterrupt(digitalPinToInterrupt(_intPin));
  return true;
}


char* DimmerModule::_customData() {
//  Serial.println("DimmerModule::_customData");
  char* data = (char *)malloc(100);
  sprintf(data, "{\"level\":%d}", _level);
  return data;
}

char* DimmerModule::useData(char* data, int* httpCode) {
Serial.println("dimmer");
Serial.println(data);
  const int bufferSize = 2*JSON_OBJECT_SIZE(1);
  StaticJsonBuffer<bufferSize> jsonBuffer;
  JsonObject& root = jsonBuffer.parseObject(data);
  if (!root.success()) {
    _oledDisplay->setLine(1, "Got bad data", TRANSIENT, NOT_BLINKING);
  } else {
    int level = (int)root["level"];
    Serial.printf("New level: %d\n", level);
    setLevel(level);
  }
  *httpCode = 200;
  return emptyMallocedResponse();
}

void DimmerModule::setLevel(int levelParam) {
  _level = levelParam;
  _lightLevelDelay = (100 - _level) * 100;   // Delay in ms before triggering triac
  Serial.printf("LevelDelay %d\n", _lightLevelDelay);

  refreshDisplay();
}

void DimmerModule::refreshDisplay() {
  char message[100];
  sprintf(message, "Level  %d", _level);
  _oledDisplay->setLine(2, message, NOT_TRANSIENT, NOT_BLINKING);
}

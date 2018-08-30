/**
 *  iotinator Dimmer module 
 *  Xavier Grosjean 2018
 *  Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International Public License
 */
 
#pragma once 
#include "config.h"
#include <XIOTModule.h>

 
class DimmerModule:public XIOTModule {
public:
  DimmerModule(DimmerConfigClass* config, int displayAddr, int displaySda, int displayScl, int intPin, int ctrlPin);
  bool customBeforeOTA();

protected:    
  void customOnStaGotIpHandled(WiFiEventStationModeGotIP ipInfo) override;
  void intHandler();
  char* _customData() override;
  char* useData(char *, int *) override;
  void setLevel(int);
  void refreshDisplay();
  
  int _intPin;
  int _level = 0;
  int _lightLevelDelay = 0;
  int _ctrlPin;
};
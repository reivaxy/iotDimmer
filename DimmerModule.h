/**
 *  iotinator Dimmer module 
 *  Xavier Grosjean 2018
 *  Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International Public License
 */
 
#pragma once 
#include "config.h"
#include <XIOTModule.h>

void intHandler();
 
class DimmerModule:public XIOTModule {
public:
  DimmerModule(DimmerConfigClass* config, int displayAddr, int displaySda, int displayScl, int intPin, int ctrlPin);
  void customRegistered() override;
  
protected:    
  char* _customData() override;
  char* useData(char *, int *) override;
  void setLevel(int);
  void refreshDisplay();
  
  int _intPin;
};
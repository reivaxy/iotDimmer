/**
 *  Definition of the config data structure for the iotDimmer module and the class to persist it to EEPROM 
 *  Xavier Grosjean 2018
 *  Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International Public License
 */
 
#pragma once

#include <XIOTConfig.h>
#include <XUtils.h>

#define CONFIG_VERSION 1
#define MODULE_NAME "Dimmer"

struct DimmerConfigStruct:ModuleConfigStruct {
  // Add config fields needed if any
};

class DimmerConfigClass:public ModuleConfigClass {
public:
  DimmerConfigClass(unsigned int version, const char* name);
  void initFromDefault();
  const char* getDefaultUIClassName() override;

protected:
  DimmerConfigStruct* _getDataPtr(void);  
};

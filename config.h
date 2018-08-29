/**
 *  Definition of the config data structure for the iotDimmer module and the class to persist it to EEPROM 
 *  Xavier Grosjean 2018
 *  Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International Public License
 */
 
#pragma once

#include <XIOTConfig.h>
#include <XUtils.h>

#define CONFIG_VERSION 3
#define MODULE_NAME "Dimmer"

#define DEFAULT_DEFAULT_LEVEL 50

struct DimmerConfigStruct:ModuleConfigStruct {
  int defaultLevel = DEFAULT_DEFAULT_LEVEL;
};

class DimmerConfigClass:public ModuleConfigClass {
public:
  DimmerConfigClass(unsigned int version, const char* name);
  void initFromDefault();
  const char* getDefaultUIClassName() override;
  int getDefaultLevel();
  void setDefaultLevel(int level); 

protected:
  DimmerConfigStruct* _getDataPtr(void); 
};

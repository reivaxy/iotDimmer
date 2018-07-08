/**
 *  Class to persist the iotDimmer module configuration data structure to EEPROM 
 *  Xavier Grosjean 2018
 *  Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International Public License
 */
 
#include "config.h"


DimmerConfigClass::DimmerConfigClass(unsigned int version, const char* name):ModuleConfigClass(version, "iotdimmer", name, sizeof(DimmerConfigStruct)) {
}

/**
 * Reset the config data structure to the default values.
 * This is done each time the data structure version is different from the one saved in EEPROM
 * NB: version and name are handled by base class 
 */
void DimmerConfigClass::initFromDefault() {
  ModuleConfigClass::initFromDefault(); // handles version and name init, ssid and pwd
  setDefaultLevel(DEFAULT_DEFAULT_LEVEL);
}

const char* DimmerConfigClass::getDefaultUIClassName() {
  Serial.println("DimmerConfigClass::getDefaultUIClassName");
  return "dimmerUIClass";
}

/**
 * Return the typed data structure object
 *
 */
DimmerConfigStruct* DimmerConfigClass::_getDataPtr(void) {
  return (DimmerConfigStruct*)ModuleConfigClass::_getDataPtr();
}

int DimmerConfigClass::getDefaultLevel() {
  return (int)DimmerConfigClass::_getDataPtr()->defaultLevel;
}

void DimmerConfigClass::setDefaultLevel(int level) {
  DimmerConfigClass::_getDataPtr()->defaultLevel = level;
}
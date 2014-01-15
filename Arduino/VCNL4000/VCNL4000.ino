#include "Wire.h"
#define VCNL4000Adress 0x13
#define VCNL4000Register0 0x80
#define VCNL4000Register1 0x81
#define VCNL4000Register2 0x82
#define VCNL4000Register3 0x803
#define VCNL4000Register4 0x84
#define VCNL4000Register5 0x85
#define VCNL4000Register6 0x86
#define VCNL4000Register7 0x87
#define VCNL4000Register8 0x88
#define VCNL4000Register9 0x89
#define VCNL4000Register10 0x8A


void setup()
{
  byte value = 0;
   Serial.begin(9600);
   Wire.begin();
   delay(1000);
   VCNL4000Setup(); 
  Wire.beginTransmission(VCNL4000Adress);
  Wire.write(VCNL4000Register0);
  Wire.endTransmission();
  Wire.requestFrom(VCNL4000Adress,1);
  value = Wire.read();
  Serial.print("setup: ");
  Serial.println(value,1);
   Wire.beginTransmission(VCNL4000Adress);
  Wire.write(VCNL4000Register3);
  Wire.endTransmission();
  Wire.requestFrom(VCNL4000Adress,1);
  value = Wire.read();
  Serial.print("setup: ");
  Serial.println(value,1);
   Wire.beginTransmission(VCNL4000Adress);
  Wire.write(VCNL4000Register4);
  Wire.endTransmission();
  Wire.requestFrom(VCNL4000Adress,1);
  value = Wire.read();
  Serial.print("setup: ");
  Serial.println(value,1);
  
}

void loop()
{
  byte LightHigh, LightLow, ProximtyHigh, ProximtyLow; 
  
  while(true)
  {
    byte results[2] = {0, 0};
    unsigned int light, proximty;
    VCNL4000Read(results, 2, VCNL4000Register5);
    light = ((int)results[1] << 8) + (int)results[0];
    Serial.print(light);
    Serial.print(", ");
    Serial.println("");
    delay(20);
  
  }  
   
}

void VCNL4000Setup()
{
  VCNL4000Write(VCNL4000Register4,0x8d);
}

void VCNL4000Write(byte registerAddress,byte data)
{
  byte value = 0x00;
  Wire.beginTransmission(VCNL4000Adress);
  Wire.write(registerAddress);
  Wire.write(data);
  Wire.endTransmission();
  Wire.beginTransmission(VCNL4000Adress);
  Wire.write(registerAddress);
  Wire.endTransmission();
  Wire.requestFrom(VCNL4000Adress,1);
  value = Wire.read();
  Serial.print("setup: ");
  Serial.println(value,1);
}

void VCNL4000Read(byte *results, int len, byte Register)
{
  int n;
  Wire.beginTransmission(VCNL4000Adress);
  Wire.write(Register);
  Wire.endTransmission();
  Wire.requestFrom(VCNL4000Adress,len);
  for(n = 0; n < len; n++)
  {
    results[n] = Wire.read();
  }
}

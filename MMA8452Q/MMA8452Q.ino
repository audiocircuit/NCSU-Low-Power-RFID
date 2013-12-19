#include "Wire.h"
#define MMA8452QAdress 0x1C
#define MMA8452QRegister0 0x00
#define MMA8452QRegister1 0x01
#define MMA8452QRegister2 0x02
#define MMA8452QRegister3 0x03
#define MMA8452QRegister4 0x04
#define MMA8452QRegister5 0x05
#define MMA8452QRegister6 0x06
#define MMA8452QRegister7 0x07
#define MMA8452QRegister8 0x08
#define MMA8452QRegister9 0x09
#define MMA8452QRegister10 0x0A
#define MMA8452QRegisterCTRL_REG1 0x28


void setup()
{
   Serial.begin(9600);
   Wire.begin();
   MMA8452QSetup(); 
   
}

void MMA8452QSetup()
{
  MMA8452Qwrite(MMA8452QRegisterCTRL_REG1, 0x01);
}

void MMA8452Qwrite(byte address, byte value)
{
  Wire.beginTransmission(MMA8452QAdress);
  Wire.write(address);
  Wire.write(value);
  Wire.endTransmission();
}


void loop()
{
  byte xHigh, xLow, yHigh, yLow, zHigh, zLow;
  unsigned int xResult, yResult, zResult; 
  while(true)
  {
   MMA8452QRead(&xHigh, &xLow, &yHigh, &yLow, &zHigh, &zLow);
   xResult = (int)(xHigh << 4) + (int)(xLow >> 4);
   yResult = (int)(yHigh << 4) + (int)(yLow >> 4);
   zResult = (int)(zHigh << 4) + (int)(zLow >> 4);
   Serial.print(xResult);
   Serial.print(", ");
   Serial.print(yResult);
   Serial.print(", ");
   Serial.print(zResult);
   Serial.println("");
   delay(10);
  }
}

void MMA8452QRead(byte *xHigh, byte *xLow, byte *yHigh, byte *yLow, byte *zHigh, byte *zLow)
{
  Wire.beginTransmission(MMA8452QAdress);
  Wire.write(MMA8452QRegister1);
  Wire.endTransmission();
  Wire.requestFrom(MMA8452QAdress,6);
  *xHigh = Wire.read();
  *xLow = Wire.read();
  *yHigh = Wire.read();
  *yLow = Wire.read();
  *zHigh = Wire.read();
  *zLow = Wire.read(); 
}

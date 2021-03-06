#include <Wire.h>
#include <Adafruit_BMP280.h>

/*************************************************** 
  This is an example for the BMP085 Barometric Pressure & Temp Sensor

  Designed specifically to work with the Adafruit BMP085 Breakout 
  ----> https://www.adafruit.com/products/391

  These displays use I2C to communicate, 2 pins are required to  
  interface
  Adafruit invests time and resources providing this open source code, 
  please support Adafruit and open-source hardware by purchasing 
  products from Adafruit!

  Written by Limor Fried/Ladyada for Adafruit Industries.  
  BSD license, all text above must be included in any redistribution
 ****************************************************/

// Connect VCC of the BMP085 sensor to 3.3V (NOT 5.0V!)
// Connect GND to Ground
// Connect SCL to i2c clock - on '168/'328 Arduino Uno/Duemilanove/etc thats Analog 5
// Connect SDA to i2c data - on '168/'328 Arduino Uno/Duemilanove/etc thats Analog 4
// EOC is not used, it signifies an end of conversion
// XCLR is a reset pin, also not used here

Adafruit_BMP280 bmp;
int tmp;
int tmp2 = 0;

void setup() {
  Serial.begin(9600);
  delay(500);
  if (!bmp.begin()) {
  Serial.println("BMP280 init error");
  while (1) {}
  }
}

void loop() {
//    Serial.print(bmp.readTemperature());
//    Serial.print(" ");
//    Serial.write((int)bmp.readPressure());
    tmp = bmp.readPressure();
    Serial.println(abs(tmp2-tmp));
    Serial.write(abs(tmp2-tmp));
    tmp2 = tmp;
    delay(100);
}

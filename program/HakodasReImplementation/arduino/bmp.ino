#include <Wire.h>
#include <Adafruit_BMP280.h>

float prsbef = 0;

Adafruit_BMP280 bmp;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  delay(500);
  if (!bmp.begin()) {
    Serial.println("Wire Error!");
    while (1) {}
  }
}

void loop() {
  // put your main code here, to run repeatedly:
  float prsaft;
  prsbef = bmp.readPressure();
  Serial.println(prsbef);
  while (1) {
    prsaft = bmp.readPressure();
    if (prsbef - prsaft > 200) {
      Serial.println("PUSH");
      prsbef = prsaft;
      delay(2000);
    } else {
      prsbef = prsaft;
      Serial.println(prsaft);
      delay(100);
    }
  }
}

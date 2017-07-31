#include <CapSense.h>

CapSense cs_19_14 = CapSense(19,14); //ピン4-2間に10MΩ，ピン2に銀ナノ
CapSense cs_19_15 = CapSense(19,15);
CapSense cs_19_16 = CapSense(19,16);
CapSense cs_19_17 = CapSense(19,17);
CapSense cs_19_18 = CapSense(19,18);

static int y1[2] = {0};
static int y2[2] = {0};
static int y3[2] = {0};
static int y4[2] = {0};
static int y5[2] = {0};

float lowpass = 0.9;

void setup() {
  Serial.begin(9600);
}

void loop() {
  long total1 = cs_19_14.capSense(30);
  long total2 = cs_19_15.capSense(30);
  long total3 = cs_19_16.capSense(30);
  long total4 = cs_19_17.capSense(30);
  long total5 = cs_19_18.capSense(30);

  y1[1] = lowpass * y1[0] + (1-lowpass) * total1;
  y2[1] = lowpass * y2[0] + (1-lowpass) * total2;
  y3[1] = lowpass * y3[0] + (1-lowpass) * total3;
  y4[1] = lowpass * y4[0] + (1-lowpass) * total4;
  y5[1] = lowpass * y5[0] + (1-lowpass) * total5;
  Serial.print(y1[1]);
  Serial.print(" ");
  
  Serial.print(y2[1]);
  Serial.print(" ");
  Serial.print(y3[1]);
  Serial.print(" ");
  Serial.print(y4[1]);
  Serial.println(" ");
  /*
  Serial.print(y5[1]);
  Serial.print(".");
  */
//  Serial.println(" ");
}


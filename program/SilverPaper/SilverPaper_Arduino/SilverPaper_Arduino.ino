//最初に立ち返って，CapSenseを用いて作る(まあ，できるよねそりゃ)
//今後の課題としてCapSenseなしを作りたい
#include <CapSense.h>
//CapSense cs_19_14 = CapSense(14,15);
//CapSense cs_19_15 = CapSense(16,17);
//CapSense cs_19_16 = CapSense(18,19);

CapSense cs_red = CapSense(54,55);
//CapSense cs_yellow = CapSense(57,58);
//CapSense cs_green = CapSense(60,61);
//CapSense cs_black = CapSense(62,63);
static int y1[2] = {0};
static int y2[2] = {0};
static int y3[2] = {0};
static int y4[2] = {0};

float lowpass = 0.9;

void setup() {
  Serial.begin(9600);
}

void loop() {
  long start = millis();
  long total1 = cs_red.capSense(30);
//  long total2 = cs_yellow.capSense(30);
//  long total3 = cs_green.capSense(30);
//  long total4 = cs_black.capSense(30);

  y1[1] = lowpass * y1[0] + (1-lowpass) * total1;
//  y2[1] = lowpass * y2[0] + (1-lowpass) * total2;
//  y3[1] = lowpass * y3[0] + (1-lowpass) * total3;
//  y4[1] = lowpass * y4[0] + (1-lowpass) * total4;
  
  Serial.print(y1[1]);
//  Serial.print(",");
//  Serial.print(y2[1]);
//  Serial.print(",");
//  Serial.print(y3[1]);
//  Serial.print(",");
//  Serial.print(y4[1]);
  Serial.println("");

  y1[0] = y1[1];
//  y2[0] = y2[1];
//  y3[0] = y3[1];
//  y4[0] = y4[1];
}


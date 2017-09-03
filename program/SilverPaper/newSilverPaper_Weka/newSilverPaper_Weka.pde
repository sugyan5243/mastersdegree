//8月に突入したのでぶっ壊した
//変更要素：Wekaを使うためにデータを吸い出すよう変更
//Font: Menlo

import processing.serial.*;

//描画グラフ
int graphSpace = 100;
int graphWidth = 512;
int graphHeight = 250;

//Arduinoから受け取ったデータ格納
int mainNum = 1;      //メインセンサの数
int mainData = 64;   //保持しておくデータ数
int mainAve = 5;  //平均値として使用するデータ数
int mainGMax = 1000;  //グラフ最大値
int mainGLine = 100;  //グラフライン値

float[] mains = new float[mainNum];
float[][] mainave = new float[mainNum][mainAve];
float[] mainMlist = new float[mainNum];
float[][] mainlist = new float[mainNum][mainData];


int subNum = 2;      //サブセンサの数
int subData = 64;
int subAve = 5;
int subGMax = 300;
int subGLine = 50;

float[] subs = new float[subNum];
float[][] sublist = new float[subNum][subAve];
float[] subMlist = new float[subNum];
float[][] subave = new float[subNum][subData];

Serial myPort;
String comport = "/dev/cu.usbmodem1411";
int comspeed = 9600;

//ROM用
String ROM = "ROM: ";
float ROMs[] = new float[100];

Boolean isReadROM = false;
Boolean isResetROM = false;

//実験用
Boolean FlagT1 = false;
Boolean Flag1 = false;
float time1st;
float time1fi;

Boolean FlagT2 = false;
Boolean Flag2 = false;
float time2st;
float time2fi;

Boolean FlagT3 = false;

String ansA = "time: ";
String ansB = "b: ";

//Sub
PrintWriter output;
PFont display;

//関数
Basic base = new Basic();
DrawGraph graph = new DrawGraph();





void setup(){
  frameRate(50);
  myPort = new Serial(this, comport, comspeed);
  
  size(1000, 1000);
  display = loadFont("Serif-48.vlw");
  textFont(display, 20);
}



void draw(){
  println(mains[0]);
  if(mains[0] > 1000){
  }
}




void keyPressed() {
  if (key == 't') {
    FlagT1 = true;
    FlagT2 = true;
  }
}





//シリアル通信にてデータを受け取る
void serialEvent(Serial myPort) {
  if (myPort.available() >= 2*mainNum-1) {
    String cur = myPort.readStringUntil('\n');
    if (cur != null) {
      String[] parts = split(cur, ",");
      if (parts.length == mainNum) {
        for (int i = 0; i < mainNum; i++) {
          print(parts[i]);
          print(" ");
          mains[i] = float(parts[i]);
        }
      }else if(parts.length == 3){
        mains[0] = float(parts[0]);
        subs[0] = float(parts[1]);
        subs[1] = float(parts[2]);
      }
    }
  }
}
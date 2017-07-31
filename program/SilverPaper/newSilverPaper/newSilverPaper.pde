//7月に突入したのでプログラム直す，Github使えや！
//追加要素: 単一結線バーコードver0.4,超音波センサ搭載(2~3番)
//Font: Menlo

import processing.serial.*;

//描画グラフ
int graphSpace = 100;
int graphWidth = 512;
int graphHeight = 250;

//Arduinoから受け取ったデータ格納
int mainNum = 1;      //メインセンサの数
int mainData = 64;   //保持しておくデータ数
int mainAve = 5;
int mainGMax = 1000;
int mainGLine = 100;

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
  background(255);
  
  mainMlist = base.updateAve(mainave, mains);
  mainlist = base.updateList(mainlist, mainMlist);
  graph.drawGraphFrame(graphSpace, 50, graphWidth, graphHeight, mainGMax, mainGLine, "0", "", "64 [num]" ,mains, 1.0);
  graph.drawGraphData(mainlist, mainData);

  subMlist = base.updateAve(subave, subs);
  sublist = base.updateList(sublist, subMlist);
  graph.drawGraphFrame(graphSpace, 350, graphWidth, graphHeight, subGMax, subGLine, "0", "", "64 [num]" ,subs, 1.0);
  graph.drawGraphData(sublist, subData);
  
  if(sublist[0][0] < subGLine && FlagT1 && !Flag1){
    Flag1 = true;
    time1st = millis();
  }
  if(sublist[0][0] > subGLine && FlagT1 && Flag1){
    FlagT1 = false;
    time1fi = millis();
    println("a: "+ (time1fi-time1st));
    //ansA += time1fi-time1st;
  }

  if(sublist[1][0] < subGLine && FlagT2 && !Flag2){
    Flag2 = true;
    time2st = millis();
  }
  if(sublist[1][0] > subGLine && FlagT2 && Flag2){
    FlagT2 = false;
    time2fi = millis();
    println("b: "+(time2fi-time2st));
    //ansB += time2fi-time2st;
  }
  if(!FlagT1 && Flag1 && !FlagT2 && Flag2 && !FlagT3){
    FlagT3 = true;
    ansA += time2st-time1st +" [ms]";
  }
  
  textSize(32);
  fill(0);
  text(ansA,700,150);
  //text(ansB,700,200);
  textSize(20);
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
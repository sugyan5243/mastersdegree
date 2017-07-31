//CapSenseを使わないで電圧値の値を表示する(できた!)
//注意:使うときはノートPCの電源を抜いておくこと，交流電源なので影響される
//Font: Menlo

import processing.serial.*;

Serial myPort;
PFont display;

//平均をとる数を増やすと当然処理速度が下がる
//トレードオフだが，12個ぐらいが経験的にちょうどいい
int sensorNum = 5;
int averageNum = 12;

//グラフの横幅を決めるパラメータと縦幅の最大値
//電圧値を表示する場合はMaxheight=5.0(Arduinoのデフォルト)
//graphwidthは，平均1個なら30，12個なら3
int graphwidth = 3;
float Maxheight = 3.0;

float[] values = new float[sensorNum];
float[][] lastNumValues = new float[sensorNum][averageNum]; // last num values
float[] aveValues = new float[sensorNum];
float[][] lastNumAveValues = new float[sensorNum][averageNum*25];

void setup(){
  size(1000,250);
  
  myPort = new Serial(this,"/dev/cu.usbserial-AH02OBZM", 9600);
  
  display = loadFont("Serif-48.vlw");
  textFont(display, 48);
}

void draw(){
  background(10);
  aveValues = reloadArrayAndCalcAverage(lastNumValues,values);
  for(int i = 0; i < lastNumAveValues.length; i++){
    reloadArray(lastNumAveValues[i], aveValues[i]);
  }
  drawGraph(lastNumAveValues);
}

void drawGraph(float value[][]){
  strokeWeight(2);
  
  for(int i = 0; i < value.length; i++){
    switch(i){
      case 0:
        stroke(255,0,0);  //red
        break;
      case 1:
        stroke(255,165,0);  //orange
        break;
      case 2:
        stroke(255,255,255);  //white
        break;
      case 3:
        stroke(0,60,255);  //blue
        break;
      case 4:
        stroke(0,255,0);  //green
        break;
    }
    for(int j = 0; j < value[i].length-1; j++){
      line(graphwidth*j,convToGraphPoint(value[i][j]), graphwidth*(j+1), convToGraphPoint(value[i][j+1]));
    }
  }
}

float convToGraphPoint(float value){
  return (height - value*height/Maxheight);
}


//過去Num個の値を更新，さらにそれを用いて平均値を計算
float[] reloadArrayAndCalcAverage(float values[][], float newValues[]){
  float ave[] = new float[values.length];
  
  //更新しながらaveに値を代入
  for(int i = 0; i < values.length; i++){
    for(int j = 0; j < values[i].length -1; j++){
      values[i][j] = values[i][j+1];
      ave[i] += values[i][j+1];
    }
    
    //最新値を代入して更新完了
    values[i][values[i].length-1] = newValues[i];
    ave[i] += newValues[i];
    ave[i] /= values[i].length;
  }
  return ave;
}

void reloadArray(float array[], float newValue){
  for(int i = 0; i < array.length-1; i++){
    array[i] = array[i+1];
  }
  array[array.length-1] = newValue;
}

void serialEvent(Serial myPort) {
  if (myPort.available() >= 7) {
    String cur = myPort.readStringUntil('\n');
    if (cur != null) {
      String[] parts = split(cur, " ");
      if (parts.length == sensorNum) {
        for (int i = 0; i < sensorNum; i++) {
          values[i] = float(parts[i]);
        }
      }
    }
  }
}
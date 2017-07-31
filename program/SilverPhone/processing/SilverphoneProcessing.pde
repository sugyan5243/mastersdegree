//実装2: 上下左右に銀ナノインクを用いた回路外部における操作(できた!)
//注意:使うときはノートPCの電源を抜いておくこと，コンセントの電源は交流なので出力に影響する
//対応するArduinoプログラム: Silverphone2_Arduino
//Font: Menlo

import processing.serial.*;

Serial myPort;
PFont display;
String aveValuesStr[] = new String[5];

//平均をとる数を増やすと当然処理速度が下がる
//トレードオフだが，10個ぐらいが経験的にちょうどいい
int sensorNum = 5;
int averageNum = 10;
int hikizan = 1;
int kakeru = 100;

//グラフの横幅を決めるパラメータと縦幅の最大値
//電圧値を表示する場合はMaxheight=5.0(Arduinoのデフォルト)
//graphwidthは，平均1個なら30，12個なら3
int graphwidth = 3;
float Maxheight = 1.1;

//グラフの描画開始位置
int sizewidth = 50;

float[] values = new float[sensorNum];
float[][] lastNumValues = new float[sensorNum][averageNum]; // last num values
float[] aveValues = new float[sensorNum];
float[][] lastNumAveValues = new float[sensorNum][averageNum*25];

void setup(){
  size(1000,300);
  
  myPort = new Serial(this,"/dev/cu.usbserial-AH02OBZM", 9600);
  
  display = loadFont("Serif-48.vlw");
  textFont(display, 20);
}

void draw(){
  background(10);
  aveValues = reloadArrayAndCalcAverage(lastNumValues,values);
  for(int i = 0; i < lastNumAveValues.length-hikizan; i++){
    reloadArray(lastNumAveValues[i], aveValues[i]);
    
    //画面にセンサ値を表示するためにもともとあったfor文を使う
    aveValuesStr[i] = "";
    aveValuesStr[i] += "sensor";
    aveValuesStr[i] += str(i+1);
    aveValuesStr[i] += ": ";
//    aveValuesStr[i] += (float)(aveValues[i]);
    aveValuesStr[i] += (int)(aveValues[i]*kakeru);
    
    text(aveValuesStr[i], 10+i*120+sizewidth, 280);
  }
  
  //グラフをグラフの形にする
  text("1.0[V]",0, 20);
  stroke(0,255,0);  // green
  fill(0, 0, 0);
  rect(sizewidth,0,750,220);
  stroke(250,255,0);  //yellow
  line(sizewidth,20,800,20);
  
  drawGraph(lastNumAveValues);
  drawPosition(aveValues,values);
  
  fill(255, 255, 255);
  
}

//グラフ描画
void drawGraph(float value[][]){
  strokeWeight(2);
  
  for(int i = 0; i < value.length-hikizan; i++){
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
    for(int j = 0; j < value[i].length-hikizan; j++){
      line(graphwidth*j+sizewidth,convToGraphPoint(value[i][j]), graphwidth*(j+1)+sizewidth, convToGraphPoint(value[i][j+1]));
    }
  }
}

//タッチ点を描画
void drawPosition(float values[], float bases[]){
  int[] data = new int[values.length];
  
  pushMatrix();
  pushStyle();
  stroke(255);
  noFill();
  ellipse(width-100,70,120,120);
  
  for(int i = 0;i < values.length; i++){
    data[i] = (int)(values[i]*kakeru);
    
    if(data[i] > 60){
      data[i] = 60;
    }
    if(i == 1 || i == 2){
      data[i] *= -1;

    }
    
    if(i == 0 || i == 2){
      translate(0,data[i]);
    }else{
      translate(data[i],0);
    }
  }
    pushMatrix();
    translate(width-100,70);
    stroke(0, 255, 0);
    fill(0, 255, 0);
    ellipse(0, 0, 10, 10);
    popMatrix();
  popMatrix();
}

//値をグラフの点に変換
float convToGraphPoint(float value){
  return ((height-80) - value*(height-100)/(float)Maxheight);
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

//値の更新
void reloadArray(float array[], float newValue){
  for(int i = 0; i < array.length-1; i++){
    array[i] = array[i+1];
  }
  array[array.length-1] = newValue;
}

//シリアル通信にてデータを受け取る
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
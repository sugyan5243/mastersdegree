//引き出しジェスチャの実装+追加要素，今度改造する
//Font: Menlo

import processing.serial.*;

//シリアル通信用変数
Serial myPort;

//センサ数と平均個数
//平均= 複数個のセンサの平均を複数個集めて平均をとッたもの
int sensorNum = 2;
int averageNum = 10;
int aveaverageNum = 2;

//グラフのMAXパラメータと基準線
int graphyoko = 80;
int graphWidth = 700;
int graphHeight = 250;
float graphMax = 1000;
float graphAve = 800;
int ellipseMax = 300;

//キャリブレーション
boolean calibration = false;

//センサの値
float[] values = new float[sensorNum];
float[][] lastNumValues = new float[sensorNum][averageNum]; // last num values
float[] aveValues = new float[sensorNum];  // last num ave
float[][] lastNumAveValues = new float[sensorNum][averageNum*aveaverageNum];  //ave ave
float[] baseValues = new float[sensorNum];
float[] calibValues = new float[sensorNum];

//スワイプ認識
boolean startRecognition = false;
boolean finishGesture = false;

boolean isGotHover = false;
boolean isStartedHikidasi = false;
boolean isStartedSimai = false;
int isNotHoveredCount = 0;
String gestureStr = "";


//そのた
String aveValuesStr[] = new String[sensorNum];
PrintWriter output;
PFont display;

void setup(){
  size(1000,1000);
  myPort = new Serial(this,"/dev/cu.usbmodem1411", 9600);
  display = loadFont("Serif-48.vlw");
  textFont(display, 20);
}

void draw(){
  background(255);  //white

  //過去SensorValue-1個の値+新規値から平均値を更新
  aveValues = reloadArrayAndCalcAverage(lastNumValues,values);

  //平均値の平均値を計算し，センサ値を表示
  for(int i = 0; i < lastNumAveValues.length; i++){
    reloadArray(lastNumAveValues[i], aveValues[i]);
   
    changeColor(i);
    aveValuesStr[i] = "";
    aveValuesStr[i] += "sensor";
    aveValuesStr[i] += str(i+1);
    aveValuesStr[i] += ": ";
    aveValuesStr[i] += (int)(aveValues[i]);
    
    text(aveValuesStr[i], graphyoko+i*120, 280);
  }
  
  //グラフ描画
  drawGraphData(lastNumAveValues);
  drawGraphFrame(lastNumAveValues);
 
  drawPositionForm();
  drawPositionData(calibValues, baseValues, aveValues);
  
  checkGesture(aveValues);
  //リング描画
//  drawPosition(calibValues,baseValues,aveValues);
}

//色変更
void changeColor(int colors){
  switch(colors){
    case 0:  //red
      stroke(255,0,0);
      fill(255,0,0);
      break;
    case 1:  //orange
      stroke(255,165,0);  
      fill(255,165,0);
      break;
    case 2:  //green
      stroke(0,150,0);
      fill(0,150,0);
      break;
    case 3:  //blue
      stroke(0,60,255);
      fill(0,60,255);
      break;
    default:  //black
      stroke(0,0,0);
      fill(0,0,0);
      break;
  }
}

//グラフ外部描画
void drawGraphFrame(float value[][]){
  stroke(0,0,0);  //black
  noFill();
  rect(graphyoko,0,(value[0].length-1)*(graphWidth/(float)(averageNum*aveaverageNum)),graphHeight);
  fill(0,0,0);
  text("0", 40, graphHeight);
  text("500", 20, convToGraphPoint(500));
  tenline(graphyoko,(int)convToGraphPoint(500),(graphyoko/2)+graphWidth,(int)convToGraphPoint(500));
  text("[arb. unit]", 0, 15);
  text("20 [num]", (graphyoko/2)+10+graphWidth, graphHeight);
//  text("[num]", (graphyoko/2)+10+graphWidth, graphHeight);

}

//波形描画
void drawGraphData(float value[][]){
  strokeWeight(2);
  for(int i = 0; i < value.length; i++){
    changeColor(i);
    for(int j = 0; j < value[i].length-1; j++){
      line(graphyoko+j*(graphWidth/(float)(averageNum*aveaverageNum)),convToGraphPoint(value[i][j]),graphyoko+(j+1)*(graphWidth/(float)(averageNum*aveaverageNum)),convToGraphPoint(value[i][j+1]));
    }
  }
}


//値をグラフの点に変換
float convToGraphPoint(float value){
  return height-(height-graphHeight) - (value*(graphHeight/graphMax));
}

void tenline(int x1, int y1, int x2, int y2){
  float  bx, by;   //直前座標記録用
  int tenNum = 100;  //点線の個数
  String hasen = "0101"; //破線パターン
  
  strokeWeight(1);
  stroke( 0,0,0);
  
  //直前の座標を「始点」に初期化する
  bx = x1;
  by = y1;
  
  //点を始点・終点を含めてtenNum個打つ
  for( int i = 0, j = 0; i <= tenNum; i++ ){
    float px = lerp( x1, x2, i/(float)tenNum );
    float py = lerp( y1, y2, i/(float)tenNum );
    
    //破線パターンが1の場合は線で結ぶ
    String ptn = hasen.substring(j,j+1);
    j++;
    //パターンの終端まで来たら、最初に戻る
    if( j >= hasen.length() ){ j = 0; }
    
    if( ptn.equals("1") == true ){
      //線で結ぶ
      line( bx, by, px, py );
    } else {
      ;
    }
    
    //直前の座標を更新
    bx = px;
    by = py;
  }
}

void drawPositionForm(){
  stroke(0,0,0);
  noFill();
  rect(graphWidth+150,0,100,graphHeight);
  
  fill(#bfbfbf);
  rect(graphWidth+150,0,100,50);
  rect(graphWidth+150,graphHeight-50,100,50);
}

void drawPositionData(float calibs[], float bases[], float values[]){
  float[] range = new float[values.length];
  float[] upping = new float[values.length];
  int transdata = 0;
 
  pushMatrix();
  pushStyle();
  changeColor(0);

  for(int i = 0; i < sensorNum; i++){
    //値の幅・上昇量
    range[i] = calibs[i] - bases[i];
    upping[i] = values[i] - bases[i];
    
    //オーバー時
    if(values[i]-bases[i] > 500){
      if(i == 0){
        if(!isStartedHikidasi)
        isStartedSimai = true;
        translate(0,-100);
      }
      if(i == 1){
        if(!isStartedSimai)
        isStartedHikidasi = true;
        translate(0,100);
      }
      transdata = 0;
      break;
    }else{
      //すべてのセンサ値を加味して丸を動かす
      if(i == 0)
      transdata -= 150*(upping[i]/range[i]);
      if(i == 1)
      transdata += 150*(upping[i]/range[i]);
    }
  }
  //transdataの合計値ぶん動く
  if(transdata < -75){
    transdata = -75;
  }else if(75 < transdata){
    transdata = 75;
  }
  if(transdata != 0)
  translate(0,transdata);
  

  //まるを描画する
  pushMatrix();
  translate(graphWidth+200,125);
  ellipse(0, 0, 10, 10);
  popMatrix();
  
  /*
  for(int i = 0; i < sensorNum; i++){
    
    //値の幅・上昇量
    range[i] = calibs[i] - bases[i];
    upping[i] = values[i] - bases[i];
    int transdata = 0;

    data[i] = upping[i]/range[i];
  
    //値が最近傍値を超えた時
    if(values[i] > calibs[i]){
      translate(0,-transdata);  //中央に戻す
      //机面センサの場合
      if(i == 0){
        translate(0,100);
      }
    }
  }
    */  
  popMatrix();
  popStyle();
}


//タッチ点を描画
/*
void drawPosition(float calibs[], float bases[], float values[]){
  float[] renge = new float[values.length];
  float[] upping = new float[values.length];
  float[] data = new float[values.length];
  float[] transdata = new float[values.length];
  int diameter = 120;
  int over = 0;
  
  pushMatrix();
  pushStyle();
  stroke(0);
  noFill();
  ellipse(width-100,70,diameter,diameter);

  //データいじり
  for(int i = 0;i < values.length; i++){
    if(values[0]+values[1]+values[2]+values[3] < 80) break;
    renge[i] = calibs[i] - bases[i];
    upping[i] = values[i] - bases[i];
    data[i] = upping[i]/renge[i];
    
    //限界突破チェック
    if((data[i]*(float)diameter/2 > (float)diameter/2)||(values[i] > 500)){
      transdata[i] = diameter/2;
      over = i+1;
    }else{
      transdata[i] = data[i]*(float)diameter/2;
    }
    if(i == 1 || i == 2){
      transdata[i] *= -1;
    }
  }
  
    //もしどれかが限界突破した場合
    if(over != 0){
      stroke(200,0,0);
      fill(200,0,0);
      if((over-1) == 0 || (over-1) == 2){
        translate(transdata[over-1],0);
      }else{
        translate(0,transdata[over-1]);
      }
    
    //限界突破はしなかった場合
    }else{
      stroke(200, 100, 200);
      fill(200, 100, 200);
      for(int i = 0;i < values.length; i++){
        if(i == 0 || i == 2){
          translate(transdata[i],0);
        }else{
          translate(0,transdata[i]);
        }
      }
    }
    
    pushMatrix();
    translate(width-100,70);
    ellipse(0, 0, 10, 10);
    popMatrix();
  popMatrix();
}
*/

void checkGesture(float values[]){
  int maxThreshold = 500;

    //ジェスチャ認識
  if((!isStartedHikidasi && !isStartedSimai ) || finishGesture){
    isNotHoveredCount++;
    if(isNotHoveredCount > 50 && values[0] < 500 && values[1] < 500){
      isNotHoveredCount = 0;
      initGestureFlag();
      gestureStr =  "";
      finishGesture = false;
    }
  }else if(isStartedHikidasi){
    if(values[0] > maxThreshold){
      println("Hikidasi");
      initGestureFlag();
      finishGesture = true;
      gestureStr =  "Hikidasi";
    }
  }else if(isStartedSimai){
    if(values[1] > maxThreshold){
      println("Simai");
      initGestureFlag();
      finishGesture = true;
      gestureStr =  "Simai";
    }
  }else{
    gestureStr = "";
  }
  changeColor(-1);
  text(gestureStr, graphWidth+150,280);
}

void initGestureFlag(){
  isStartedHikidasi = false;
  isStartedSimai = false;
}


//valuesのj-1個の値+最新の値(newvalues)から平均値(ave)を更新
float[] reloadArrayAndCalcAverage(float oldValues[][], float newValues[]){
  float ave[] = new float[oldValues.length];
  
  for(int i = 0; i < oldValues.length; i++){
    for(int j = 0; j < oldValues[i].length -1; j++){
      oldValues[i][j] = oldValues[i][j+1];
      ave[i] += oldValues[i][j+1];
    }
    
    oldValues[i][oldValues[i].length-1] = newValues[i];
    ave[i] += newValues[i];
    ave[i] /= oldValues[i].length;
  }
  return ave;
}

//平均値の平均を更新
void reloadArray(float aveave[], float average){
  for(int i = 0; i < aveave.length-1; i++){
    aveave[i] = aveave[i+1];
  }
  aveave[aveave.length-1] = average;
}

//キャリってブレる
void keyPressed(){
  if(key == 'c'){
    for(int i = 0; i < sensorNum; i++){
      baseValues[i] = aveValues[i];
    }
    calibration = true;
  }
  if(key == '1'){
    calibValues[0] = aveValues[0];
  }else if(key == '2'){
    calibValues[1] = aveValues[1];
  }else if(key == '3'){
    calibValues[2] = aveValues[2];
  }else if(key == '4'){
    calibValues[3] = aveValues[3];
  }
  if(key == 'o'){
    output = createWriter("test.txt");
  }else if(key == 'p'){
    output.println(aveValues[0]);
  }else if(key == 'q'){
    output.flush();
    output.close();
  }
}

//シリアル通信にてデータを受け取る
void serialEvent(Serial myPort) {
  if (myPort.available() >= 2*sensorNum-1) {
    String cur = myPort.readStringUntil('\n');
    if (cur != null) {
      String[] parts = split(cur, ",");
      if (parts.length == sensorNum) {
        for (int i = 0; i < sensorNum; i++) {
          print(parts[i]);
          print(" ");
          values[i] = float(parts[i]);
        }
      }
    }
  }
}
//6月に突入したのでフォルダ分ける，Github使えや！
//追加要素: 単一結線バーコードver0.3
//Font: Menlo

import processing.serial.*;

//基本データ
int sensorNum = 1;
int averageNum = 8;
int dataNum = 64;
int aveaveNum = 8;

//グラフのMAXパラメータと基準線
int graphyoko = 100;
int graphWidth = 512;
int graphHeight = 250;
int graphMax = 1000;
float graphAve = 800;

//メイン
float[] values = new float[sensorNum];
Serial myPort;
String comport = "/dev/cu.usbmodem1411";
int comspeed = 9600;

//関数たち
Basics base = new Basics();
DrawGraph graph = new DrawGraph();
DrawGraph graphFFT = new DrawGraph();
FFT fft = new FFT(averageNum*aveaveNum);
ROM rom = new ROM();

//グラフ用変数
float[][] lastNumValues = new float[sensorNum][averageNum]; //averageNum個のデータ
float[] aveValues = new float[sensorNum];  //averageNum個の平均
float[][] aveaveValues = new float[sensorNum][dataNum];  //aveValules詰合せ

//FFT用変数
float[][] fftdata = new float[sensorNum][dataNum];  //FFTの絶対値
float[][] fftdatar = new float[sensorNum][dataNum];  //FFTの実数部
float[][] fftdatai = new float[sensorNum][dataNum];  //FFTの虚数部

//FFTグラフ用変数
int graphspaceFFT = 100;
int graphWidthFFT = 512;
int graphHeightFFT = 250;
int graphMaxFFT = 1000;

//ROM用変数
String ROM ="ROM: ";
Boolean isReadROM = false;
Boolean isResetROM = false;
float ROMMin = 10000;
float ROMs[] = new float[100];
int ROMnum = 0;

//分割を用いた実装法
float tiisai = 10000;
float ookii = -10000;

//傾きを用いた実装法
int data = 0;
float dataA = 0;
float dataB = 0;
int nowROM = 0;
float gin = 0;
float kami = 0;
Boolean Fin = false;

//そのた
String aveValuesStr[] = new String[sensorNum];
PrintWriter output;
PFont display;

void setup() {
  //通信セッティング
  frameRate(50);
  myPort = new Serial(this, comport, comspeed);

  //画面の見やすさ変更
  size(1000, 1000);
  display = loadFont("Serif-48.vlw");
  textFont(display, 20);

  //初期化
  initialize();
  
  //ファイル出力
  String out = hour() + "" + minute() +""+ second()+".txt";
  output = createWriter(out);
}



void draw() {
  background(255);  //white

  //過去SensorValue-1個の値+新規値から平均値を更新
  aveValues = base.reloadaveValues(lastNumValues, values);
  aveaveValues = base.reloadaveaveValues(aveaveValues, aveValues, sensorNum, dataNum);

  //グラフ描画
  graph.drawGraphFrame(graphyoko, 50, graphWidth, graphHeight, graphMax, "0", "1000", "[arbs.unit]", "100", "64 [num]");
  graph.drawGraphData(aveaveValues, sensorNum, dataNum);

  //FFT計算&描画
  calcFFT(aveaveValues);
  graphFFT.drawGraphFrame(graphyoko, 400, graphWidthFFT, graphHeight, graphMaxFFT, "0", "", "", "", "64 [Hz]");
  graphFFT.drawGraphData(fftdata, sensorNum, dataNum);

/*
  //単一結線ROM読取(分割と傾きを用いた実装法)
  dataA = dataB;
  dataB = values[0];
  
  //1.傾きが急だと開始
  if(!isReadROM && dataB - dataA > 350){
    isReadROM = true;
    nowROM = 1;
  }
  
  //主要処理部分
  if(isReadROM){
    if(nowROM == 0 && dataA-dataB > 150){  //プラス上昇
      nowROM = 1;
      data = 0;
      kami += values[0];
      ROMs[ROMnum++] = values[0];
    }else if(nowROM == 1 && abs(dataA-dataB) < 150){
      nowROM = 2;
      gin += values[0];
//      ROMs[ROMnum++] = values[0];
    }else if(nowROM == 2 && dataA-dataB < -150){    //マイナス下降
      nowROM = 3;
      data = 0;
    }else if(nowROM != 3 && abs(dataA-dataB) < 150){  //安定
      nowROM = 0;
      data++;
    }
  }
  if(data > 100){
    isReadROM = false;
  }
  
  //出力処理
  if(!isReadROM && ROMnum != 0 && !Fin){
    Fin = true;
    kami = kami / ROMnum;
    gin = gin / ROMnum;
    for(int i = 2; i < ROMnum; i++){
      if(kami < ROMs[i]){
        ROM += "1";
      }else{
        ROM += "0";
      }
    }
  }
  
  for(int i = 0; i < ROMnum; i++){
    print(ROMs[i]+" ");
  }
  println("");
  */
  
  
  //単一結線ROM読取(分割を用いた実装法，速度依存)
  //1.黒線に触れる
  if(!isReadROM && !isResetROM && rom.ResetROM(values[0])){
    isReadROM = true;
    isResetROM = false;
  }
  
  if(isReadROM){
    if(ROMMin < rom.one_threshold){
      isResetROM = false;
    }
    //3.再度黒線に触れる
    if(!isResetROM && rom.ResetROM(values[0])){
      //ROM = rom.ReturnROMValue(ROMMin,ROM);

      //大小を判断
      if(ROMMin < rom.one_threshold){
        ookii = rom.ReturnMax(ROMMin,ookii);
        tiisai = rom.ReturnMin(ROMMin,tiisai);
      }

      ROMs[ROMnum++] = ROMMin;
      ROMMin = 10000;
      isResetROM = true;
    
    //2.再度黒線に触れるまで
    }else{
      ROMMin = rom.ReturnMin(values[0],ROMMin);
      
      //手を離した際(読込終了)
      if(ROMMin == 0){
        isReadROM = false;
        isResetROM = true;
        output.flush();
        output.close();
        //4.最後に出力する
        if(!isReadROM && isResetROM){
          for(int i =0; i < ROMnum; i++){
            //ROM = rom.ReturnROMValue(ROMs[i],ROM);
            print(ROMs[i]+" ");
            if(ROMs[i] > 9900){
              ;
            }else if(ookii-ROMs[i] < ROMs[i]-tiisai){
              //ROM += "1";
            }else{
              //ROM += "0";
            }
          }
          println("");
        }
      }
    }
  }
  if(!isReadROM && isResetROM){
      data++;
    if(data == 60){
          ROM += "011";
    }
  }
  
            println("ROMNUMiS"+ROMnum);
  
  //CSV出力
//  if(!(!isReadROM && isResetROM)){
    output.println(values[0]);
//  }


  //最新の平均センサ値表示
  for (int i = 0; i < lastNumValues.length; i++) {
    changeColor(i);
    aveValuesStr[i] = "";
    aveValuesStr[i] += "sensor";
    aveValuesStr[i] += str(i+1);
    aveValuesStr[i] += ": ";
    aveValuesStr[i] += (int)(aveValues[i]);    
    text(aveValuesStr[i], graphyoko+i*120, graphHeight+30+50);
  }

  //ROM結果表示
  textSize(32);
  text(ROM, graphyoko+graphWidth+100, 200);
  textSize(20);
  println(ROM);
  //println(ROMnum);
}

//キャリってブレる
void keyPressed() {
  if (key == 'o') {
    output = createWriter("test.txt");
  } else if (key == 'p') {
    output.println(aveValues[0]);
  } else if (key == 'q') {
    output.flush();
    output.close();
  } else if (key == 'r'){
     //ファイル出力
     output.flush();
     output.close();
    String out = hour() + "" + minute() +""+ second()+".txt";
    output = createWriter(out);
    isReadROM = false;
    isResetROM = false;
    ROMMin = 10000;
    ROMnum = 0;
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
//グラフデータをすべて初期化
void initialize() {
  int x, y;
  for (y = 0; y < averageNum; y++) {
    for (x = 0; x < sensorNum; x++) {
      lastNumValues[x][y] = 0;
      fftdatar[x][y] = 0;
      fftdatai[x][y] = 0;
      aveValues[x] = 0;
    }
  }
}



//色変更
void changeColor(int colors) {
  switch(colors) {
  case 0:  //red
    stroke(255, 0, 0);
    fill(255, 0, 0);
    break;
  case 1:  //orange
    stroke(255, 165, 0);  
    fill(255, 165, 0);
    break;
  case 2:  //green
    stroke(0, 150, 0);
    fill(0, 150, 0);
    break;
  case 3:  //blue
    stroke(0, 60, 255);
    fill(0, 60, 255);
    break;
  default:  //black
    stroke(0, 0, 0);
    fill(0, 0, 0);
    break;
  }
}



///FFTを計算
void calcFFT(float aveaveValues[][]) {
  for (int i = 0; i < sensorNum; i++) {
    for (int j = 0; j < dataNum; j++) {
      float[] wnd = fft.getWindow();
      fftdata[i][j] = (fftdatar[i][j]*fftdatar[i][j]+fftdatai[i][j]*fftdatai[i][j]);
      fftdatar[i][j] = aveaveValues[i][j] * wnd[j];
      fftdatai[i][j] = 0;
    }
    fft.fft(fftdatar[i], fftdatai[i]);
  }
}
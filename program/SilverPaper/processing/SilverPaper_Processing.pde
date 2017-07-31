//CAUTION: Put out a pc battery charger plug because it influence to output signal. 
//correspondence program: SilverPaper_Arduino
//Font: Menlo

import processing.serial.*;

//variables for serial communication
Serial myPort;
PFont display;

boolean calibration = false;  //calibraction flag

// sensor values
float[] values = new float[SENSOR_NUM];
float[][] lastNumValues = new float[SENSOR_NUM][AVERAGE_NUM]; // last num values
float[] aveValues = new float[SENSOR_NUM];  // last num ave
float[][] lastNumAveValues = new float[SENSOR_NUM][AVERAGE_NUM*AVE_AVERAGE_NUM];  //ave ave
float[] nonValues = new float[SENSOR_NUM];
float[] baseValues = new float[SENSOR_NUM];
float[] calibValues = new float[SENSOR_NUM];

String aveValuesStr[] = new String[SENSOR_NUM];

PlaceCircle placeCircle;
WaveGraph waveGraph;
WaveGraph[] waveGraphs = new WaveGraph[SENSOR_NUM];


PrintWriter output;  // PrintWriter型のオブジェクトを宣言

void setup(){
  output = createWriter("test.txt");  // ファイル名test.txtでファイルを開く
  size(1600,900);
  myPort = new Serial(this,SERIAL_ADDRESS, 9600);
  display = loadFont("Serif-48.vlw");
  textFont(display, 20);
  
  //placeCircle = new PlaceCircle(PLACE_CIRCLE_POS[X],PLACE_CIRCLE_POS[Y],PLACE_CIRCLE_DIAMETER);
  //waveGraph = new WaveGraph(WAVE_GRAPH_POS[X],WAVE_GRAPH_POS[Y],WAVE_GRAPH_SIZE[X],WAVE_GRAPH_SIZE[Y]);

//  placeCircle = new PlaceCircle(575+200,250+200,400,30);
  placeCircle = new PlaceCircle(200,300,400,30);
  waveGraphs[0] = new WaveGraph(700,25,150,200);
  waveGraphs[1] = new WaveGraph(350,350,150,200);
  waveGraphs[2] = new WaveGraph(700,675,150,200);
  waveGraphs[3] = new WaveGraph(1050,350,150,200);
  
  waveGraphs[0].changeGraphDesign(COLOR_BLACK,COLOR_RED,4);
  waveGraphs[1].changeGraphDesign(COLOR_BLACK,COLOR_ORANGE,4);
  waveGraphs[2].changeGraphDesign(COLOR_BLACK,COLOR_GREEN,4);
  waveGraphs[3].changeGraphDesign(COLOR_BLACK,COLOR_BLUE,4);
}

void draw(){
  background(255);  //white

  //update average value by latest sensor value
  aveValues = reloadArrayAndCalcAverage(lastNumValues,values);

  //calcurate and display the average values
  for(int i = 0; i < lastNumAveValues.length; i++){
    reloadArray(lastNumAveValues[i], aveValues[i]);
   
    changeColor(i);
    aveValuesStr[i] = "";
    aveValuesStr[i] += "sensor";
    aveValuesStr[i] += str(i+1);
    aveValuesStr[i] += ": ";
    aveValuesStr[i] += (int)(aveValues[i]);
    
    text(aveValuesStr[i], i*120, 20);
  }
  
  //display a graph
  //waveGraph.drawGraphData(lastNumAveValues);
  //waveGraph.drawGraphFrame(lastNumAveValues);
  for(int i=0;i<SENSOR_NUM;i++)
//    waveGraphs[i].drawGraph(lastNumAveValues[i]);
  
  //display a ring circle
  //placeCircle.drawPosition(calibValues,baseValues,aveValues);
  placeCircle.drawCircle(calibValues,aveValues,baseValues,nonValues);
}

void changeColor(int colors){
  switch(colors){
    case 0:  //red
      stroke(COLOR_RED);
      fill(COLOR_RED);
      break;
    case 1:  //orange
      stroke(COLOR_ORANGE);  
      fill(COLOR_ORANGE);
      break;
    case 2:  //green
      stroke(COLOR_GREEN);
      fill(COLOR_GREEN);
      break;
    case 3:  //blue
      stroke(COLOR_BLUE);
      fill(COLOR_BLUE);
      break;
    default:  //black
      stroke(COLOR_BLACK);
      fill(COLOR_BLACK);
      break;
  }
}

void keyPressed(){
  switch(key){
    case 'n':
      for(int i = 0; i < values.length; i++){
        nonValues[i] = aveValues[i];
      }
    case 'c':
      for(int i = 0; i < values.length; i++){
        baseValues[i] = aveValues[i];
      }
      calibration = true;
      break;
    case 'a':
            output.println(values[0]+" "+values[1]+" "+values[2]+" "+values[3]);
          break;
    case 'f':
          output.flush();  // 出力バッファに残っているデータを全て書き出し  
          output.close();  // ファイルを閉じる
          break;
    case '1':
    case '2':
    case '3':
    case '4':
      calibValues[key-'1'] = aveValues[key-'1'];
      break;
  }
}

void serialEvent(Serial myPort) {
  if (myPort.available() >= 2*SENSOR_NUM-1) {
    String cur = myPort.readStringUntil('\n');
    if (cur != null) {
      String[] parts = split(cur, ",");
      if (parts.length == SENSOR_NUM) {
        for (int i = 0; i < SENSOR_NUM; i++) {
          //print(parts[i]);
          //print(" ");
          values[i] = float(parts[i]);
        }
      }
    }
  }
}

//update average values by using all past datas and latest data
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
  
//update average value
void reloadArray(float aveave[], float average){
  for(int i = 0; i < aveave.length-1; i++){
    aveave[i] = aveave[i+1];
  }
  aveave[aveave.length-1] = average;
}
import processing.serial.*;

Serial myPort;
PFont display;
String hoverStr = "";
String touchStr = "";
String gestureStr = "";
String lastGestureStr = "";
String modeStr = "";

int mode = 0;

int sensorNum = 1;
int averageNum = 20;

float[] values = new float[sensorNum];//rare 4 sensor data at one frame
String[] message = new String[2];    //file open Message
int message_num = 0;

int[][] TouchTime = new int[4][100];
int[][] ReleaseTime = new int[4][100];
int[][] NearTime = new int[4][100];
int ci = 0;

PrintWriter output;    // PrintWriter
int hour, minute, second;    //time
int test = 0;

void setup() {

  size(500, 500); //width = 500*n

  myPort = new Serial(this, "/dev/cu.usbmodem1411", 9600);
  //myPort = new Serial(this, "/dev/cu.usbmodem1421", 11520);

  display = loadFont("Serif-48.vlw");
  textFont(display, 48);
  
  message[0] = "no open";
  message[1] = "open";
  NearTime[0][0] = 0;
}

void draw() {
  background(255);  //white
  stroke(0,0,0);  //black
  fill(0,0,0);
  textSize(48);
  text("NOBITAPE", 50, 70);
  textSize(20);
//  text(message[message_num], 100, 250);
//  text(values[0], 350, 250);
  text("Tape's length",150,300);
//  if((70-NearTime[0][0])*2 < 0){
//    text("0 mm",200,350);
//  }else{
    text((NearTime[0][0])+" mm",200,350);
//  }
/*
  if(values[0] > 10){
    NearTime[0][0] = (int)values[0];
  }else{
    NearTime[0][0] = 0;
  }
  */
  println(values[0]);
}

//キー操作でファイル開いたり閉じたり
void keyPressed(){
  if(key == 'o'){
      output = createWriter("test.txt");
      message_num = 1;
  }else if(key == 'c'){
      output.flush();
      output.close();
      message_num = 0;
  }else if(key == 'q'){
    NearTime[0][0]+=10*Math.random();
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
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
}

void draw() {
  background(255);  //white
  stroke(0,0,0);  //black
  fill(0,0,0);
  textSize(48);
  text("TANA-BIRAKI", 50, 70);
  textSize(20);
//  text(message[message_num], 100, 250);
//  text(values[0], 350, 250);
  text("Newer Data",150,300);
  if(test > 0){
  text("Near： No."+NearTime[0][ci]+": "+NearTime[1][ci]+":"+NearTime[2][ci]+":"+NearTime[3][ci],200,350);
  }
  if(test > 1){
  text("Open： No."+TouchTime[0][ci]+": "+TouchTime[1][ci]+":"+TouchTime[2][ci]+":"+TouchTime[3][ci],200,370);
  }
  if(test > 2){
  text("Release： No."+ReleaseTime[0][ci]+": "+ReleaseTime[1][ci]+":"+ReleaseTime[2][ci]+":"+ReleaseTime[3][ci],200,390);
  }
  if(values[0] > 40 && test == 0){
    test = 1;
    NearTime[0][ci] = 0;
    NearTime[1][ci] = hour();
    NearTime[2][ci] = minute();
    NearTime[3][ci] = second();
    output.println("N,"+NearTime[0][ci]+","+NearTime[1][ci]+","+NearTime[2][ci]+","+NearTime[3][ci]); 
} 
  if(values[0] > 500 && test == 1){
    test = 2;
    TouchTime[0][ci] = 0;
    TouchTime[1][ci] = hour();
    TouchTime[2][ci] = minute();
    TouchTime[3][ci] = second();
    output.println("T,"+TouchTime[0][ci]+","+TouchTime[1][ci]+","+TouchTime[2][ci]+","+TouchTime[3][ci]); 
}
  if(values[0] < 40 && test > 0 && test != 3){
    test = 3;
    ReleaseTime[0][ci] = 0;
    ReleaseTime[1][ci] = hour();
    ReleaseTime[2][ci] = minute();
    ReleaseTime[3][ci] = second();
    output.println("R,"+ReleaseTime[0][ci]+","+ReleaseTime[1][ci]+","+ReleaseTime[2][ci]+","+ReleaseTime[3][ci]);
    //ci++;
  }
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
//http://shirotsuku.sakura.ne.jp/blog/?p=192

import processing.serial.*;

Serial myPort;
int val;
int [] x = new int[600];
int [] y = new int[600];
int graphmin = 0;
int graphmax = 255;

int speed = 60000;

void setup() 
{
  frameRate(speed);
  size(700, 350);
  myPort = new Serial(this, "/dev/cu.usbserial-AH02OBZM", 9600);
  textSize(20);
  for (int i = 0; i < x.length; i++){
    x[i] = i;
    y[i] = (graphmax)/2;
  }  
}
 
void draw()
{
    background(255);
 

    for (int i = 0; i < y.length - 1; i++){
      y[i] = y[i+1];
    }
    y[y.length - 1] = val;
 
    fill(0);
    text(graphmin,10,310);
    text(graphmax,10,54);
    fill(0,0,0);
    text(val,width-40,100);
     
    //drow graph
    pushMatrix();
    translate(50,300);
    scale(1,-1);
    fill(0);
    stroke(255);
    rect(0,0,width-100,256);
    stroke(0,255,0);
    for (int i = 0; i < x.length - 1; i++){
      line(x[i],y[i],x[i+1],y[i+1]);
    }
    popMatrix();
}
 
void serialEvent(Serial myPort){
  val = myPort.read();
}
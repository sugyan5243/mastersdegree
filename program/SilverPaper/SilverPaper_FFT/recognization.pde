public class recognization{
  /*
  //ジェスチャ認識
  boolean startRecognition = false;
  boolean finishGesture = false;
  boolean isGotHover = false;
  boolean isStartedHikidasi = false;
  boolean isStartedSimai = false;
  int isNotHoveredCount = 0;
  String gestureStr = "";
  
  //タッチ点を描画
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
  
  void initGestureFlag(){
    isStartedHikidasi = false;
    isStartedSimai = false;
  }
  
  //引き出しジェスチャの認識
  void checkHikidashiGesture(float values[]){
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
  */
}
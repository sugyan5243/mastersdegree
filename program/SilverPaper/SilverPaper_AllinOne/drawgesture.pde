public class drawgesture{
/*
  //キャリブレーション(タッチ位置推定用)
  boolean calibration = false;
  float[] baseValues = new float[sensorNum];
  float[] calibValues = new float[sensorNum];
  
  //円形フレーム用
  int circleDiameter = 120;
  int ellipseMax = 300;
  
  //円形ジェスチャ用フレーム描画
  void drawCircleFrame(){
    stroke(0);
    noFill();
    ellipse(width-100,70,circleDiameter,circleDiameter);
  }
  
  
  
  //引き出しジェスチャ用フレーム描画
  void drawHikidashiFrame(){
    stroke(0,0,0);
    noFill();
    rect(graphWidth+200,0,100,250);
    
    fill(#bfbfbf);
    rect(graphWidth+200,0,100,50);
    rect(graphWidth+200,200,100,50);
  }
  
  
  
  //引き出しジェスチャ用点描画
  void drawHikidashiData(float calibs[], float bases[], float values[]){
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
        transdata -= 200*(upping[i]/range[i]);
        if(i == 1)
        transdata += 200*(upping[i]/range[i]);
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
    translate(graphWidth+250,125);
    ellipse(0, 0, 10, 10);
    popMatrix();
    popMatrix();
    popStyle();
  }
  */
}
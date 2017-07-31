class PlaceCircle{
  int graphPos[] = new int[2];
  int graphDiameter, dotDiameter;
  
  color frameColor, dotColor;
  
  PlaceCircle(int graphPosX, int graphPosY, int gDiameter, int dDiameter){
    graphPos[0] = graphPosX;
    graphPos[1] = graphPosY;
    graphDiameter = gDiameter;
    dotDiameter = dDiameter;
  }
  
  void changeGraphDesign(color fColor, color dColor){
    frameColor = fColor;
    dotColor = dColor;
  }
  
  void drawCircle(float calibs[], float values[], float bases[], float nons[]){
    drawDot(calibs, values, nons);
    drawCircleFrame(frameColor);
  }

  void drawCircleFrame(color frameColor){
    stroke(frameColor);
    noFill();
    ellipse(graphPos[X],graphPos[Y],graphDiameter,graphDiameter);
    fill(COLOR_BLACK);
  }
  
  void drawDot(float calibs[], float values[], float nons[]){
    float[] linklihood = new float[4];
    float[] touchPos = new float[2];
    float scale = 1.0f;
    
    for(int i=0; i<4; i++){
      if(calibs[i] != nons[i])
        linklihood[i] = (values[i] - nons[i]) / (calibs[i] - nons[i]);
      else
        linklihood[i] = 0;
      if(linklihood[i]>1.0f) linklihood[i] = 1.0f;
    }
    touchPos[X] = -1.0f * linklihood[1] + linklihood[3];
    touchPos[Y] = -1.0f * linklihood[0] +  linklihood[2];
    if(sqrt(touchPos[X] * touchPos[X] + touchPos[Y] * touchPos[Y]) > 1.0f)
      scale = 1.0f / sqrt(touchPos[X] * touchPos[X] + touchPos[Y] * touchPos[Y]);
    scale *= graphDiameter/2;    
    
    println(linklihood[0]+":"+linklihood[1]+":"+linklihood[2]+":"+linklihood[3]+":"+touchPos[X]+":"+touchPos[Y]);
    
    ellipse(graphPos[X]+touchPos[X]*scale,graphPos[Y]+touchPos[Y]*scale, dotDiameter, dotDiameter);
  }
  
  void drawDot(float calibs[], float values[], float bases[], float nons[]){
    float range[] = new float[SENSOR_NUM];
    float[] upping = new float[SENSOR_NUM];
    float[] data = new float[SENSOR_NUM];
    float[] transdata = new float[SENSOR_NUM];
    float touchPos[] = new float[2];
    int over = 0;
  
    pushMatrix();
    pushStyle();
    stroke(0);
    noFill();
    ellipse(graphPos[0],graphPos[1],graphDiameter,graphDiameter);
  
    //データいじり
    for(int i = 0;i < values.length; i++){
      calibs[i]-=nons[i];
      values[i]-=nons[i];
      bases[i]-=nons[i];
      if(values[0]+values[1]+values[2]+values[3] < GRAPH_MIN) break;
      range[i] = calibs[i] - bases[i];
      upping[i] = values[i] - bases[i];
      data[i] = upping[i]/range[i];
      
      //限界突破チェック
      if((data[i] > 1.0f)||(values[i] > GRAPH_MAX)){
        transdata[i] = graphDiameter/2;
        over = i+1;
      }else{
        transdata[i] = data[i]*(float)graphDiameter/2;
      }
      if(i == 0 || i == 1){
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
    } else {
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
    translate(DISPLAY_WIDTH/2,DISPLAY_HEIGHT/2);
    ellipse(0, 0, 30, 30);
    popMatrix();
    popMatrix();
  }
}
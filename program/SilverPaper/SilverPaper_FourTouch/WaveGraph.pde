class WaveGraph {
  int graphPos[] = new int[2];
  int graphSize[] = new int[2];
  
  color frameColor, lineColor;
  int strokeWeight;
  
  WaveGraph(int graphPosX, int graphPosY, int graphSizeX, int graphSizeY){
    graphPos[0] = graphPosX;
    graphPos[1] = graphPosY;
    graphSize[0] = graphSizeX;
    graphSize[1] = graphSizeY;
  }
  
  void changeGraphDesign(color fColor, color lColor, int sWeight){
    frameColor = fColor;
    lineColor = lColor;
    strokeWeight = sWeight;
  }
  
  void drawGraph(float value[]){
    drawGraphData(strokeWeight, lineColor, value, true);
    drawGraphFrame(frameColor);
  }

  void drawGraphFrame(color frameColor){
    stroke(frameColor);
    noFill();
    rect(graphPos[X],graphPos[Y],graphSize[X],graphSize[Y]);
    fill(COLOR_BLACK);
  }
  
  // fillMode false: wave line only true: fill wave
  void drawGraphData(int strokeWeight, color lineColor, float value[], boolean fillMode){
    strokeWeight(strokeWeight);
    stroke(lineColor);
    fill(lineColor);
    for(int i = 0; i < value.length-1; i++){
      if(!fillMode)
        line(graphPos[X]+i*(graphSize[X]/(float)(AVERAGE_NUM*AVE_AVERAGE_NUM))
          ,graphPos[Y]+graphSize[Y]-calcWaveHeight(graphSize[Y],value[i])
          ,graphPos[X]+(i+1)*(graphSize[X]/(float)(AVERAGE_NUM*AVE_AVERAGE_NUM))
          ,graphPos[Y]+graphSize[Y]-calcWaveHeight(graphSize[Y],value[i+1]));
      else
        line(graphPos[X]+i*(graphSize[X]/(float)(AVERAGE_NUM*AVE_AVERAGE_NUM))
          ,graphPos[Y]+graphSize[Y]
          ,graphPos[X]+(i+1)*(graphSize[X]/(float)(AVERAGE_NUM*AVE_AVERAGE_NUM))
          ,graphPos[Y]+graphSize[Y]-calcWaveHeight(graphSize[Y],value[i]));
    }
  }
  
  float calcWaveHeight(int graphHeight, float value){
    //GRAPH_MAX;
    if(value > GRAPH_MAX)
      return graphHeight;
    return value*graphHeight/GRAPH_MAX;
  }
  
  //draw graph class
  void drawGraphFrame(float value[][]){
    stroke(0,0,0);  //black
    noFill();
    rect(graphPos[X],graphPos[Y],(value[0].length-1)*(graphSize[X]/(float)(AVERAGE_NUM*AVE_AVERAGE_NUM)),graphSize[Y]);
    fill(0,0,0);
  //text("0", 40, graphSize[Y]);
  //text("500", 20, convToGraphPoint(500));
  //tenline(graphPos[X],(int)convToGraphPoint(500),(graphPos[X]/2)+graphSize[X],(int)convToGraphPoint(500));
  //text("[arb. unit]", 0, 15);
  //text("20 [num]", (graphPos[X]/2)+10+graphSize[X], graphSize[Y]);
  //  text("[num]", (graphyoko/2)+10+graphWidth, graphHeight);
  
  }
  
  //波形描画
  void drawGraphData(float value[][]){
    strokeWeight(2);
    for(int i = 0; i < value.length; i++){
      changeColor(i);
      for(int j = 0; j < value[i].length-1; j++){
        line(graphPos[X]+j*(graphSize[X]/(float)(AVERAGE_NUM*AVE_AVERAGE_NUM)),convToGraphPoint(value[i][j])
          ,graphPos[X]+(j+1)*(graphSize[X]/(float)(AVERAGE_NUM*AVE_AVERAGE_NUM)),convToGraphPoint(value[i][j+1]));
      }
    }
  }
  
  //値をグラフの点に変換
  float convToGraphPoint(float value){
    return DISPLAY_HEIGHT-(DISPLAY_HEIGHT-graphSize[Y]) - (value*(graphSize[Y]/GRAPH_MAX));
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
}
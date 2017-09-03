public class DrawGraph{
  int startX;
  int startY;
  int dataStart = 80;  //パラメータの開始X(負の値として計算される)
  int graphWidth;
  int graphHeight;
  int graphMax;
  float powLevel;
  
  //グラフのフレームを描画
  void drawGraphFrame(int X, int Y, int Width, int Height, int GMax, int GLine, String Bottom, String TUnit, String BUnit, float[] value, float pow){
    startX = X;
    startY = Y;
    graphWidth = Width;
    graphHeight = Height;
    graphMax = GMax;
    powLevel = pow;
    
    stroke(0,0,0);  //black
    noFill();
    rect(startX,startY,graphWidth,graphHeight);
    fill(0,0,0);

    text(Bottom, startX-dataStart+60, startY+graphHeight+20);
    text(String.valueOf(GMax), startX-dataStart+30, startY+15);
    text(TUnit, startX-dataStart+30, startY-20);
    text(String.valueOf(GLine), startX-dataStart+20, convToGraphPoint(GLine));
    tenline(startX,(int)convToGraphPoint(GLine),startX+graphWidth,(int)convToGraphPoint(GLine));
    text(BUnit, startX+graphWidth+10, startY+graphHeight+20);
    for(int x = 0; x < value.length; x++){
      changeColor(x);
      text("sensor"+(x+1)+": "+value[x], startX+x*130, startY+graphHeight+30);
    }
  }

  //グラフの点々を描画
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

  //グラフを描画
  void drawGraphData(float value[][], int dataNum){
    float X1, X2, Y1, Y2;
    int x,y;
    
    strokeWeight(2);
    for(x = 0; x < value.length; x++){
      changeColor(x);
      for(y = 0; y < value[x].length-1; y++){
        X1 = startX + y * (graphWidth / (float)dataNum);
        X2 = startX + (y+1) * (graphWidth / (float)dataNum);
        
        Y1 = convToGraphPoint(value[x][y] * powLevel);
        Y2 = convToGraphPoint(value[x][y+1] * powLevel);
        
        line(X1,Y1,X2,Y2);
      }
      X1 = startX + y * (graphWidth / (float)dataNum);
      X2 = startX + graphWidth;
      Y1 = convToGraphPoint(value[x][y-1] * powLevel);
      Y2 = convToGraphPoint(value[x][y] * powLevel);
      line(X1,Y1,X2,Y2);
    }
  }
  
  //値をグラフの点に変換
  float convToGraphPoint(float value){
    float ans = startY+graphHeight - (float)value*(graphHeight/(float)graphMax);
    if(ans < startY){
      return startY;
    }else{
    return ans;
    }
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
}
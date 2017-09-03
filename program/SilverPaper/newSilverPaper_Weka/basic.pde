public class Basic{

  //リストを更新
  float[] updateAve(float[][] Ave, float[] values){
    int x,y;
    float[] ans = new float[Ave.length];
    float sum;
    
    for(x = 0; x < Ave.length; x++){
      ans[x] = 0;
      for(y = 0; y < Ave[x].length-1; y++){
        Ave[x][y] = Ave[x][y+1];
        ans[x] += Ave[x][y];
    }
      Ave[x][y] = values[x];
      ans[x] += Ave[x][y];
      ans[x] /= Ave[x].length;
    }
    
    return ans;
  }

  float[][] updateList(float[][] List, float[] Mlist){
    int x,y;
    
    for(x = 0; x < List.length; x++){
      for(y = 0; y < List[x].length-1; y++){
        List[x][y] = List[x][y+1];
      }
      List[x][y] = Mlist[x];
    }
    
    return List;
  }
}
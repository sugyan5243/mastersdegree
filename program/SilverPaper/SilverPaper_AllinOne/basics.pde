public class Basics{
  //aveValuesを再読み込み
  float[] reloadaveValues(float oldNumValues[][],float newValues[]){
    float newave[] = new float[oldNumValues.length];
    for(int x = 0; x < oldNumValues.length; x++){
      for(int y = 0; y < oldNumValues[x].length -1; y++){
        oldNumValues[x][y] = oldNumValues[x][y+1];
        newave[x] += oldNumValues[x][y+1];
      }
    oldNumValues[x][oldNumValues[x].length-1] = newValues[x];
    newave[x] += newValues[x];
    newave[x] /= oldNumValues[x].length;
    }  
    return newave;
  }
  
  //aveaveValuesを再読み込み
  float[][] reloadaveaveValues(float aveaveValues[][], float aveValues[], int sensorNum, int dataNum){
    for(int x = 0; x < sensorNum; x++){
      for(int y = 0; y < dataNum-1; y++){
        aveaveValues[x][y] = aveaveValues[x][y+1];
      }
      aveaveValues[x][dataNum-1] = aveValues[x];
    }
    return aveaveValues;
  }
}
/*

//2結線ROM(values[0] = データ, values[1] = リセット)
void twolinerom(float values[]){
  if(values[1] >= one_threshold){
    isReadROM = false;
  }else if(!isReadROM){
    isReadROM = true;
    if(100 < values[0] && values[0] < zero_threshold){
      ROM+= "0";
    }else if(one_threshold < values[1]){
      ROM+= "1";
    }
  }
}
*/



public class ROM{
  int zero_threshold = 350;
  int one_threshold = 1000;
  boolean isReadROM = false;  //読込を行ってから次の読込に遷移するまで
  boolean isStartROM = false;  //読込開始(基準:zero_threshold以上の値となったとき)

  
  //単一結線ROMテスト(values[0] = データ)
  String onelinerom(float value, String ROM){
    if(zero_threshold < value){
      isStartROM = true;
    }
    if(isStartROM){
      if(zero_threshold < value && value < one_threshold){
        isReadROM = false;
      }else if(!isReadROM){
        isReadROM = true;
        if(values[0] < zero_threshold){
          ROM+= "0";
        }else if(one_threshold < value){
          ROM+= "1";
        }
      }
    }
    return ROM;
  }
}
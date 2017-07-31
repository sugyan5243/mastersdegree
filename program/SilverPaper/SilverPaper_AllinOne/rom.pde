public class ROM{
//  int out_threshold = 150;
  int out_threshold = 30;
  int zero_threshold = 100;
  int one_threshold = 200;
  int i = 100;
  boolean isReadROM = false;  //読込を行ってから次の読込に遷移するまで
  boolean isStartROM = false;  //読込開始(基準:zero_threshold以上の値となったとき)
  boolean test = false;

  
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
          //ROM+= "0";
        }else if(one_threshold < value){
          //ROM+= "1";
        }
      }
    }
    return ROM;
  }
  
  //リセット部分に触れた場合
  Boolean ResetROM(float value){
    if(one_threshold < value){
      return true;
    }else{
      return false;
    }
  }
  
  //傾きが急かどうか
  Boolean KatamukiROM(float value1, float value2){
    if(abs(value1 - value2) > 100){
      return true;
    }else{
      return false;
    }
  }
  
  //黒線間の最小値を返す，値が枠外ならば終了させる
  float ReturnMin(float value, float Now){
    if(value < out_threshold){
      return 0;
    }
    
    if(Now > value){
      return value;
    }else{
      return Now;
    }
  }
  float ReturnMax(float value, float Now){
    if(Now < value){
      return value;
    }else{
      return Now;
    }
  }

  //ROMの値を返す
  String ReturnROMValue(float value, String ROM){
    if(zero_threshold < value && value < one_threshold){
      ROM += "1";
    }else if(value < zero_threshold){
      ROM += "0";
    }
    return ROM;
  }

  //2結線ROM(values[0] = データ, values[1] = リセット)
  String twolinerom(float values[], String ROM){
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
    return ROM;
  }
}
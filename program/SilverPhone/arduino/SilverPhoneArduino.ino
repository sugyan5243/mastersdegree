//CapSenseを使わないで電圧値をシリアル通信にて受信する(できた!)

//回路から得られる電圧値(0~1023)
float volt1 = 0.0;
float volt2 = 0.0;
float volt3 = 0.0;
float volt4 = 0.0;
float volt5 = 0.0;

//参照電圧(取得できる最大電圧値 = 1024の値)
float Vref = 5.0;

//ローパスフィルタ
float lowpass = 0.9;

void setup() {
  //シリアル通信のボーレート(1秒間に何ビットのデータを送るか)を9600(=1bit104u秒)に
  Serial.begin(9600);
}

void loop() {
  volt1 = analogRead(14);
  volt1 = (volt1 / 1024.0) *Vref;    //実際の電圧値への変換
  volt2 = analogRead(15);
  volt2 = (volt2 / 1024.0) *Vref;    //実際の電圧値への変換
  volt3 = analogRead(16);
  volt3 = (volt3 / 1024.0) *Vref;    //実際の電圧値への変換
  volt4 = analogRead(17);
  volt4 = (volt4 / 1024.0) *Vref;    //実際の電圧値への変換
  
  Serial.print(volt1);
  Serial.print(",");
  Serial.print(volt2);
  Serial.print(",");
  Serial.print(volt3);
  Serial.print(",");
  Serial.print(volt4);
  Serial.println("");
}

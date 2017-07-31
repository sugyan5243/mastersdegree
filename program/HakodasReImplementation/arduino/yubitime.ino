int pin = 0;
int test = 0;
unsigned long Tstart;
unsigned long Tend;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  int val;
  int i;
  val = analogRead(pin);
//  Serial.println(val);
    if(val < 930){
      Tstart = micros();
      Serial.println("YUBI now");
      for(; val < 930;){
        val = analogRead(pin);
        delay(100);
      }
      Tend = micros();
      Serial.print("YUBI TIME:");
      Serial.println((Tend-Tstart)/100000);
    }
    test++;
    delay(100);
}


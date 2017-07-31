#define PIN 0
#define TS 950

#define COVERMAX 900
#define COVERPUSH 850
#define PUSHMIN 700

#define DOWNMAX 950
#define DOWNUP 935
#define UPMIN 920

int sensor;
unsigned long sensum = 0;
int senave;
int count;
int check;

void setup() {
  Serial.begin(9600);
}

void loop() {
  sensor = analogRead(PIN);

  Identify_Gesture();
  if((check == 0) && (count == 0)&&(sensor < TS)){
    for(; sensor < TS;){
      sensor = analogRead(PIN);
      count++;
      sensum += sensor;

      if(count >= 30){
        check = Ccheck();
      }
      delay(10);
    }
  }
  delay(10);
}

int Ccheck(){
  senave = sensum/count;
  if((PUSHMIN < senave) && (senave <= COVERPUSH)){
    return 1;
  }else if((COVERPUSH < senave) && (senave <= COVERMAX)){
    return 2;
  }
}

void Identify_Gesture(){
  if(check == 1){
    Serial.println("PUSH");
  }else if(check == 2){
    Serial.println("COVER");
  }else if((check == 0) && (count != 0)){
    senave = sensum/count;
    if((UPMIN < senave) && (senave <= DOWNUP)){
      Serial.println("UP");
    }else if((DOWNUP < senave) && (senave <= DOWNMAX)){
      Serial.println("DOWN");
    }
  }

  check = 0;
  count = 0;
  sensum = 0;
  delay(500);
}


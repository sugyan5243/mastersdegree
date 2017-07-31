#define PIN 0
#define PUSH 1
#define COVER 2

#define SENSOR 950
#define COVERORPUSH 880

#define CPUD 30

int count = 0;
int check = 0;
unsigned long sensum[CPUD] = {0,};
int avebef;
int aveaft;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
}

void loop() {
  int j;
  int sensor;

  //photorefrector check
  sensor = analogRead(PIN);

  //COVER
  if(check == COVER){
    Serial.println("COVER");
    check = 0;
    for(j = 0; j < CPUD; j++){
      sensum[j] = 0;
    }
    count = 0;
    delay(500);

  //PUSH
  }else if(check == PUSH){
    Serial.println("PUSH");
    check = 0;
    for(j = 0; j < CPUD; j++){
      sensum[j] = 0;
    }
    count = 0;
    delay(500);

  //UP or DOWN
  }else if((check == 0)&&(count != 0)){
    avebef = 0;
    aveaft = 0;

    Serial.println(count);
    for(j = 0; j < count/2; j++){
      avebef += sensum[j];
      sensum[j] = 0;
    }
    for(j = count/2; j < count; j++){
      aveaft += sensum[j];
      sensum[j] = 0;
    }

    Serial.print(avebef);
    Serial.print(" ");
    Serial.println(aveaft);

    if(avebef > aveaft){
      Serial.println("UP");
    }else{
      Serial.println("DOWN");
    }

    count = 0;
    delay(500);
  }

  //other,finger is now
  else if(sensor < SENSOR){
    for(count = 0; sensor < SENSOR; count++){
      sensor = analogRead(PIN);

      //COVER or PUSH
      if(count >= CPUD){
        aveaft = 0;
        for(j = 0;j < CPUD;j++){
          aveaft += sensum[j];
        }
        aveaft = aveaft/CPUD;
        if((700 < aveaft)&&(aveaft <= COVERORPUSH)){
          check = PUSH;
        }else if((COVERORPUSH < aveaft)&&(aveaft <= 950)){
          check = COVER;
        }
          sensor = 1000;
      }else{
         //check process
         sensum[count] += sensor;
      }
      Serial.println(count);
      delay(10);
    }
  }
  delay(10);
}


#define PIN 0
#define PUSH 1
#define COVER 2

#define SENSOR 1020
#define CORP 180

#define CPUD 30

int count = 0;
int check = 0;
int sensum[CPUD] = {0,};
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
    Identify(sensum);
    Covers(&check, &count);
    delay(500);
  //PUSH
  }else if(check == PUSH){
    Identify(sensum);
    Pushs(&check, &count);
    delay(500);

  //UP or DOWN
  }else if((check == 0)&&(count != 0)){
    UpDown(&count, sensum);
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
        if(aveaft < CORP){
          check = COVER;
        }else{
          check = PUSH;
        }
          sensor = 10000;
      }else{
         //check process
         sensum[count] += 1023-sensor;
      }
      Serial.println(sensum[count]);
      delay(10);
    }
  }
  delay(100);
}


void Identify(int *sensum){
  int i = 0;
  for(i = 0;i < CPUD; i++){
    sensum[i] = 0;
  }
}


void Covers(int *chk, int *cnt){
    Serial.println("COVER");
    *chk = 0;
    *cnt = 0;
}


void Pushs(int *chk, int *cnt){
  Serial.println("PUSH");
  *chk = 0;
  *cnt = 0;
}


void UpDown(int *cnt, int *sensum){
    int bef = 0;
    int aft = 0;
    int i;

    Serial.println(*cnt);
    for(i = 0; i < *cnt/2; i++){
      bef += sensum[i];
      sensum[i] = 0;
    }
    bef = bef/(*cnt/2);
    for(i = *cnt/2; i < *cnt; i++){
      aft += sensum[i];
      sensum[i] = 0;
    }
    aft = aft/(*cnt/2);

    Serial.print(bef);
    Serial.print(" ");
    Serial.println(aft);

    if(bef > aft){
      Serial.println("UP");
    }else{
      Serial.println("DOWN");
    }

    *cnt = 0;
}


void UpDown2(int *cnt, int *sensum){
    int bef = 0;
    int aft = 0;
    int i;

    Serial.println(*cnt);
    for(i = *cnt-5; i < *cnt; i++){
      aft += sensum[i];
      sensum[i] = 0;
    }
    aft = aft/4;
    Serial.print("It's ");
    Serial.println(aft);

    if(aft < 100){
      Serial.println("UP");
    }else{
      Serial.println("DOWN");
    }

    *cnt = 0;
}


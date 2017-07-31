int pin = 0;
int yline = 950;
int cors = 0; //Time

int check = 0;
unsigned long yubinum = 0;
int yave;
int PUSH = 1;
int COVER = 2;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
}

void loop() {
  int yubi;

  //photorefrector check
  yubi = analogRead(pin);

  //COVER
  if(check == COVER){
    Serial.println("COVER");
    check = 0;
    cors = 0;
    yubinum = 0;
    delay(500);

  //PUSH
  }else if(check == PUSH){
    Serial.println("PUSH");
    check = 0;
    cors = 0;
    yubinum = 0;
    delay(500);

  //UP or DOWN
  }else if((check == 0)&&(cors != 0)){
    yave = yubinum/cors;
    if((900 <= yave)&&(yave < 938)){
      Serial.println("UP");
    }if((938 <= yave)&&(yave < 950)){
      Serial.println("DOWN");
    }

//    Serial.print(yubinum); Serial.print(" "); Serial.println(cors);
    Serial.println(yubinum/cors);

    cors = 0;
    yubinum = 0;
    delay(500);
  }

  //other,finger is now
  else if(yubi < yline){
    for(; yubi < yline;){
      yubi = analogRead(pin);

       //check process
      cors++;
      yubinum += yubi;

      //COVER or PUSH
      if(cors >= 30){
        yave = yubinum/cors;
        if((700 < yave)&&(yave <= 850)){
          check = PUSH;
        }else if((850 < yave)&&(yave <= 950)){
          check = COVER;
        }
      }

      delay(10);
    }
  }
  delay(10);
}


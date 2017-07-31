#define PIN 0
void setup() {
  Serial.begin(9600);
}

void loop() {
  int sensor;
  sensor = analogRead(PIN);
  Serial.write(sensor);
}

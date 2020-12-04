void setup() {
  pinMode(3, INPUT_PULLUP);
  // put your setup code here, to run once:
  Serial.begin(115200);
}

void loop() {
  // put your main code here, to run repeatedly:
  Serial.println(digitalRead(3));
}

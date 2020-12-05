void setup() {
  // put you()r setup code here, to run once:
Serial.begin(500000,SERIAL_8N1);
}

void loop() {
  // put your main code here, to run repeatedly:
  if(Serial.available()>0){
    int incomingByte = Serial.read();

    Serial.print("i got: ");
    Serial.println(incomingByte,DEC);
    } 
}

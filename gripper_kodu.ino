int i =2 ;
int g=3;
void setup() {
 Serial.begin (9600);
  pinMode(i, OUTPUT);
  pinMode(g, OUTPUT);
}

void loop() {
  digitalWrite(i, HIGH);   
  delay(1500);                     
  digitalWrite(i, LOW);    
  delay(1000);
  digitalWrite(g, HIGH);   
  delay(1500);                       
  digitalWrite(g, LOW);    
  delay(1000);   
}

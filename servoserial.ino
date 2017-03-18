 int val; // serialden gelen data
#include <Servo.h>

Servo myservo;  

int pos = 0;    // servo pozisyonu

void setup() {
  myservo.attach(2);  // 2ye bağla
Serial.begin(9600);
}

void loop() {

  if(Serial.available())
  {
    val=Serial.read();  
  }
  else{
    val=0;
    }
    for (pos = 0; pos <= val; pos += 1) { // 0dan alınan değere göre 1er derece ilerlet
    
    myservo.write(pos);             
    delay(15);                       
  }
  
}

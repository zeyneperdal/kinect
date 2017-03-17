 int val; // Data received from the serial port
#include <Servo.h>

Servo myservo;  // create servo object to control a servo
// twelve servo objects can be created on most boards

int pos = 0;    // variable to store the servo position

void setup() {
  myservo.attach(2);  // attaches the servo on pin 9 to the servo object
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
    for (pos = 0; pos <= val; pos += 1) { // goes from 0 degrees to 180 degrees
    // in steps of 1 degree
    myservo.write(pos);              // tell servo to go to position in variable 'pos'
    delay(15);                       // waits 15ms for the servo to reach the position
  }
  
}

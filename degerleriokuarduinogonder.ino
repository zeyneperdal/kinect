#include <Servo.h>

float temp1, temp2, temp3, temp4; 

int servo1Pin=2;
int servo2Pin=3;
int servo3Pin;
int servo4Pin;


void updateServo (int pin, int pulse){
 digitalWrite(pin, HIGH);
 delayMicroseconds(pulse);
 digitalWrite(pin, LOW);
} 

int pulse1 = 500;
int pulse2 = 2500;
int pulse3 = 2500;
int pulse4 = 500;
 


int speedServo = 0;
unsigned long previousMillis = 0;
long interval = 20; 

void setup() {

   pinMode (servo1Pin, OUTPUT); 
   pinMode (servo2Pin, OUTPUT);
    Serial.begin(9600); 
}

void loop() {
  if (Serial.available())
  {
 temp1 = Serial.read();
 temp2 = Serial.read();
 temp3 = Serial.read();
 temp4 = Serial.read();
  }
  else{
    temp1,temp2,temp3,temp4=0;
    }

//pulse9 = (int)map(temp1,0,180,2500,500); //rotation

pulse2 = (int)map(temp2,0,180,2500,500); //right Elbow
pulse1 = (int)map(temp3,0,180,2500,500); //right Shoulder
pulse4 = (int)map(temp4,0,180,500,2500); //right Knee
pulse3 = (int)map(temp1,0,180,2500,500); //right Hip 

unsigned long currentMillis = millis();
 if(currentMillis - previousMillis > interval) {
 previousMillis = currentMillis;

 updateServo(servo1Pin, pulse3);
 updateServo(servo2Pin, pulse4);
// updateServo(servo3Pin, pulse5);
 //updateServo(servo4Pin, pulse6);
 }
} 



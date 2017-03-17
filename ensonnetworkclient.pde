import processing.net.*;
import processing.serial.*;

Serial myPort;

PFont font; 

Client c;

String input;

float data[] = new float[5];
PShape s; 

void setup()
{
 size(640, 700);
 background(255);
 stroke(0);
 frameRate(10);
 // Serverın IP adresi ve portu
 c = new Client(this, "127.0.0.1", 12345); // TODO:Sonradan değiştir
 textAlign(CENTER);
 s = loadShape("deneme.svg");
 shapeMode(CENTER);
 smooth();
//  println(Serial.list());
// if (serial) {
  
  String portName = Serial.list()[0];
//String portName = "COM5"; //  Serial.list()[0] yazdıgımda burda hata veriyor
myPort = new Serial(this, portName, 9600);
// }
 
 
} 
void draw()
{
 background(0);
 // Serverdan gelen datayı al
 if (c.available() > 0) {
 input = c.readString();
 input = input.substring(0, input.indexOf("\n")); 
 data = float(split(input, ' ')); // ayrılmış değerleri diziye gönder
 for (int i = 0 ; i < data.length; i++) { 
    if(data[i] > PI/2) { data[i] = PI/2; }
 if(data[i] < -PI/2) { data[i] = PI/2; }
 }
 }
 shape(s, 300, 300, 300, 400);
 
  //robot kol çizim
  drawLimb(150, 210, PI, data[2], data[1], 50); //çizimde sağ el
  drawLimb(170, 385, PI/2, data[4], data[3], 50); //çizimde sağ ayak
 //yuvarlaklar
  stroke(200);
 fill(200);
 for (int i = 0; i < data.length; i++) {
 pushMatrix();
 translate(50+i*65, height/1.2);
 noFill();
 ellipse(0, 0, 60, 60);
 text("Servo " + i + "\n" + round(degrees(data[i])), 0, 55);
 rotate(data[i]);
 line(0, 0, 30, 0);
 popMatrix();
 } 
//  if (serial)
  sendSerialData();
} 
void drawLimb(int x, int y, float angle0, float angle1, float angle2, float limbSize) {
 pushStyle();
 strokeCap(ROUND);
 strokeWeight(50);
 stroke(24, 150, 131);
 pushMatrix();
 translate(x, y);
 rotate(angle0);
 rotate(angle1);
 line(0, 0, limbSize, 0);
 translate(limbSize, 0);
 rotate(angle2);
 line(0, 0, limbSize, 0);
 popMatrix();
 popStyle();
} 
void sendSerialData() {

 for (int i=0;i<data.length;i++) {
 int serialAngle = (int)map(data[i], -PI/2, PI/2, 0, 180);
 myPort.write(serialAngle);

 }

}


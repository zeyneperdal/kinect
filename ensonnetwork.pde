import processing.net.*;
import SimpleOpenNI.*;

SimpleOpenNI  kinect;
Server s;

color[]       userClr = new color[]{ color(255,0,0),
                                     color(0,255,0),
                                     color(0,0,255),
                                     color(255,255,0),
                                     color(255,0,255),
                                     color(0,255,255)
                                   };
PVector com = new PVector();                                   
PVector com2d = new PVector();                                   


// Sağ Kol Vektörleri
PVector rHand = new PVector();
PVector rElbow = new PVector();
PVector rShoulder = new PVector();
// Sağ Bacak Vektörleri
PVector rFoot = new PVector();
PVector rKnee = new PVector();
PVector rHip = new PVector();
// Sol Kol Vektörleri
PVector lHand = new PVector();
PVector lElbow = new PVector();
PVector lShoulder = new PVector();
// Sol Bacak Vektörleri
PVector lFoot = new PVector();
PVector lKnee = new PVector();
PVector lHip = new PVector();
 
float[] angles = new float[5]; 

void setup()
{
  size(640,480);
  
  kinect = new SimpleOpenNI(this);
  kinect.setMirror(true);
  if(kinect.isInit() == false)
  {
     println("SimpleOpenNI baslatilamadi, kamera baglanmamis olabilir, baglantilarini kontrol et!"); 
     exit();
     return;  
  }
  
  // enable depthMap generation 
  kinect.enableDepth();
   
  // enable skeleton generation for all joints
  kinect.enableUser();
 
  background(200,0,0);

  stroke(0,0,255);
  strokeWeight(3);
  smooth();  
   s = new Server(this, 12345); // Start a simple server on a port 
}

void draw()
{
  kinect.update();
  image(kinect.depthImage(),0,0);
  
  
   if(kinect.isTrackingSkeleton(1))
    {
     
      updateAngles();
   //   println(angles);
      
      drawSkeleton(1);
      
      //sokete açıları yazdır
      s.write(angles[0] + " " + angles[1] + " " + angles[2] + " " + angles[3] + " " + angles[4] + "\n"); 
      
      
    }  
  
  /*
  // iskeleti çiz
  int[] userList = kinect.getUsers();
  for(int i=0;i<userList.length;i++)
  {
    if(kinect.isTrackingSkeleton(userList[i]))
    {
      stroke(userClr[ (userList[i] - 1) % userClr.length ] );
      
      updateAngles();
      println(angles);
      
      drawSkeleton(1);
    }      
      
    // kütle merkezi çiz
    if(kinect.getCoM(userList[i],com))
    {
      kinect.convertRealWorldToProjective(com,com2d);
      stroke(100,255,0);
      strokeWeight(1);
      beginShape(LINES);
        vertex(com2d.x,com2d.y - 5);
        vertex(com2d.x,com2d.y + 5);

        vertex(com2d.x - 5,com2d.y);
        vertex(com2d.x + 5,com2d.y);
      endShape();
      
      fill(0,44,100);
      text(Integer.toString(userList[i]),com2d.x,com2d.y);
    }*/
      
}

// seçilen eklemler ile iskelet çiz
void drawSkeleton(int userId)
{
  pushStyle();
  stroke(255,0,0);
  strokeWeight(5);
  //Pozisyonları yazdır
  //TODO:180 e normalize et!
/*
  PVector jointPos = new PVector();
  kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_NECK,jointPos);
  println(jointPos);
  println("pokerface"); 
*/
  
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);

  kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);

  kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);

  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);

  kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);

  kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);  
  popStyle();
}

// -----------------------------------------------------------------
// SimpleOpenNI events

void onNewUser(SimpleOpenNI curkinect, int userId)
{
  println("Yeni Kullanici - Kullanici Id: " + userId);
  if(curkinect.isTrackingSkeleton(1))
    return;
  println("\tIskelet takibini baslat");
  if(userId ==1)
  {
      curkinect.startTrackingSkeleton(userId);
  }

  if(userId >1)
  {
     curkinect.stopTrackingSkeleton(userId);
  }
}

void onLostUser(SimpleOpenNI curkinect, int userId)
{
  println("Kullanici Cikti - Kullanici Id: " + userId);
}

void onVisibleUser(SimpleOpenNI curkinect, int userId)
{
  //println("onVisibleUser - userId: " + userId);
}


void keyPressed()
{
  switch(key)
  {
  case ' ':
    kinect.setMirror(!kinect.mirror());
    break;
  }
}  

float angle(PVector a, PVector b, PVector c) {

 float angle01 = atan2(a.y - b.y, a.x - b.x);
 float angle02 = atan2(b.y - c.y, b.x - c.x);
 float ang = angle02 - angle01;
 return ang;
} 
void updateAngles() {
  //1. parametre kullanici id si yani 1
  //2.parametre koordinatlarını cıkartmak istediğimiz bölge
  //3. parametre PVectorler(en basta tanımladık)
  
  
  

 /*
 // Left Leg
 kinect.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_LEFT_FOOT, lFoot);
 kinect.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_LEFT_KNEE, lKnee);
 kinect.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_LEFT_HIP, lHip);
 
 */
  // Left Arm
 kinect.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_LEFT_HAND, lHand);
 kinect.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_LEFT_ELBOW, lElbow);
 kinect.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_LEFT_SHOULDER, lShoulder);
 // Right Arm
 kinect.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_RIGHT_HAND, rHand);
 kinect.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_RIGHT_ELBOW, rElbow);
 kinect.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_RIGHT_SHOULDER, rShoulder);
 // Right Leg
 kinect.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_RIGHT_FOOT, rFoot);
 kinect.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_RIGHT_KNEE, rKnee);
 kinect.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_RIGHT_HIP, rHip); 
  angles[0] = atan2(PVector.sub(rShoulder, lShoulder).z, PVector.sub(rShoulder, lShoulder).x); 
 
 kinect.convertRealWorldToProjective(rFoot, rFoot);
 kinect.convertRealWorldToProjective(rKnee, rKnee);
 kinect.convertRealWorldToProjective(rHip, rHip);

 kinect.convertRealWorldToProjective(lFoot, lFoot);
 kinect.convertRealWorldToProjective(lKnee, lKnee);
 kinect.convertRealWorldToProjective(lHip, lHip);
 kinect.convertRealWorldToProjective(lHand, lHand);
 kinect.convertRealWorldToProjective(lElbow, lElbow);
 kinect.convertRealWorldToProjective(lShoulder, lShoulder);

 kinect.convertRealWorldToProjective(rHand, rHand);
 kinect.convertRealWorldToProjective(rElbow, rElbow);
 kinect.convertRealWorldToProjective(rShoulder, rShoulder);
 /*
 // Left-Side Angles
 angles[1] = angle(lShoulder, lElbow, lHand);
 angles[2] = angle(rShoulder, lShoulder, lElbow);
 angles[3] = angle(lHip, lKnee, lFoot);
 angles[4] = angle(new PVector(lHip.x, 0), lHip, lKnee);
 // Right-Side Angles
 angles[5] = angle(rHand, rElbow, rShoulder);
 angles[6] = angle(rElbow, rShoulder, lShoulder );
 angles[7] = angle(rFoot, rKnee, rHip);
 angles[8] = angle(rKnee, rHip, new PVector(rHip.x, 0));
 */
 
 //sağ taraf ölçüleri
 angles[1] = angle(rHand, rElbow, rShoulder);
 angles[2] = angle(rElbow, rShoulder, lShoulder );
 angles[3] = angle(rFoot, rKnee, rHip);
 angles[4] = angle(rKnee, rHip, new PVector(rHip.x, 0));
 
} 


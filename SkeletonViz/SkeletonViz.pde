import processing.opengl.*;

import oscP5.*;
import netP5.*;

OscP5 oscP5;

Map<String, Float[]> skeleton = new HashMap<String, Float[]>();
boolean debugOn = false;

ArrayList<String[]> bones = new ArrayList<String[]>(); 

void setup() 
{
    size(800, 600, OPENGL);
    oscP5 = new OscP5(this, "128.237.249.228", 7110); // Set this in your broadcast program
    smooth();
    noStroke();
  
    bones.add(new String[] { "/Head", "/ShoulderCenter", "/Spine", "/HipCenter" });
    bones.add(new String[] { "/ShoulderCenter", "/ShoulderLeft", "/ElbowLeft", "/WristLeft", "/HandLeft" });
    bones.add(new String[] { "/ShoulderCenter", "/ShoulderRight", "/ElbowRight", "/WristRight", "/HandRight" }); 
    bones.add(new String[] { "/HipCenter", "/HipLeft", "/KneeLeft", "/AnkleLeft", "/FootLeft" });
    bones.add(new String[] { "/HipCenter", "/HipRight", "/KneeRight", "/AnkleRight", "/FootRight" });  
}

void oscEvent(OscMessage msg) 
{
  try
  {
    if(debugOn)
    {
      // msg.print();  This prints the entire message
      if(msg.addrPattern().startsWith("/"))
      {
        println(msg.addrPattern());
      }
    }
   if(msg.addrPattern().startsWith("/") && msg.typetag().equals("fff")) 
   {    
     skeleton.put(msg.addrPattern(), new Float[] { msg.get(0).floatValue(), msg.get(1).floatValue(), msg.get(2).floatValue() });      
   }
  }
  catch(Exception e)
  {
    e.printStackTrace();
  }
}


// This draw just puts an ellipse for all joints
void draw()
{
  background(255, 255, 255);  
  
  fill(0, 0, 0);    
  // Draw joints
  for(String s : skeleton.keySet()) 
  {
    Float[] f = skeleton.get(s);
    pushMatrix();
      translate(f[0]*width + width/2, f[1]*height*-1 + height/2, -f[2]*250);
      ellipse(0, 0, 20, 20);
    popMatrix();
  }
  
  // Draw bones
  strokeWeight(2);
  stroke(255, 0, 128, 100);
  for(String[] b : bones) 
  {
    pushMatrix();
    beginShape(LINES);
    for(int i = 0; i < b.length - 1; i++)
    {
      Float[] f1 = skeleton.get(b[i]);
      Float[] f2 = skeleton.get(b[i + 1]);
      if(f1 != null && f2 != null)
      {
          vertex(f1[0]*width + width/2, f1[1]*height*-1 + height/2, -f1[2]*250);
          vertex(f2[0]*width + width/2, f2[1]*height*-1 + height/2, -f2[2]*250);
          
          //translate(f[0]*width + width/2, f[1]*height*-1 + height/2, -f[2]*250);
          //ellipse(0, 0, 20, 20);
      }
    }
    endShape();
    popMatrix();
  }
}

//// This draw just tracks hand only
//void draw()
//{
//  background(255);
//  fill(0, 0, 0);    
//  Float[] f = skeleton.get("/HandRight");
//  if(f != null)
//  {
//    pushMatrix();
//      translate(f[0]*width + width/2, f[1]*height*-1 + height/2, -f[2]*250);
//      ellipse(0, 0, 10, 10);
//    popMatrix();
//  }
//}



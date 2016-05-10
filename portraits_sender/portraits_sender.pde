import processing.net.*;
import processing.video.*;

Client myClient;

Capture cam;

void setup() {
  frameRate(16);
  colorMode(HSB);
  
  myClient = new Client(this, "127.0.0.1", 5204);  
  
  String[] cameras = Capture.list();

  println("Available cameras:");
  for (int i = 0; i < cameras.length; i++) {
    println(cameras[i]);
  }

  // The camera can be initialized directly using an element
  // from the array returned by list():
  // cam = new Capture(this, cameras[0]);
  // Or, the settings can be defined based on the text in the list
  cam = new Capture(this, 320, 180, "FaceTime HD Camera (Built-in)", 30);
  
  // Start capturing the images from the camera
  cam.start();
}

 

void draw() {
  // take pic
  if (cam.available() == true) {
    cam.read();
    PImage newFrame = cam.get();
    newFrame.loadPixels();
    
    String[] ps = new String[newFrame.pixels.length];
    for (int i=0; i < newFrame.pixels.length; i++) {
      ps[i] = (String)(newFrame.pixels[i]);
    }
    println( join(ps, ",") );
  }
}

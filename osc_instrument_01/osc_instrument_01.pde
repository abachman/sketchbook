import java.util.regex.Pattern;
import oscP5.*;
import netP5.*;
import procontroll.*;
import net.java.games.input.*;

ControllIO controll;
ControllDevice pad;
OscP5 oscP5;
NetAddress myRemoteLocation;

void setup() {
  size(400,400, P2D);
  frameRate(25);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,12000);
  
  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device, 
   * application. usage see below. for testing purposes the listening port
   * and the port of the remote location address are the same, hence you will
   * send messages back to this sketch.
   */
  myRemoteLocation = new NetAddress("127.0.0.1",12000);

  // controller
  pad = null;
  controll = ControllIO.getInstance(this);
  controll.printDevices();
  pad = controll.getDevice(0);
//  Pattern p = Pattern.compile("Logitech");
//  for(int i = 0; i < controll.getNumberOfDevices(); i++){
//    ControllDevice device = controll.getDevice(i);
//    println("FOUND DEVICE: " + device.getName());
//    if (p.matcher(device.getName()).matches()) {
//      pad = device;
//      println("FOUND DEVICE: " + device.getName());
//    }
//  }

}

void draw() {
  background(0);  
}

void mousePressed() {
  /* in the following different ways of creating osc messages are shown by example */
  OscMessage myMessage = new OscMessage("/test");
  
  myMessage.add(123); /* add an int to the osc message */
  myMessage.add(12.34); /* add a float to the osc message */
  myMessage.add("some text"); /* add a string to the osc message */
  myMessage.add(new byte[] {0x00, 0x01, 0x10, 0x20}); /* add a byte blob to the osc message */
  myMessage.add(new int[] {1,2,3,4}); /* add an int array to the osc message */

  /* send the message */
  oscP5.send(myMessage, myRemoteLocation); 
}


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());
}




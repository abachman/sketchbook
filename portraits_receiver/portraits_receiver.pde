import processing.net.*;

Server myServer;

void setup() {
  myServer = new Server(this, 5204);
  frameRate(16);
}

void draw() {
   Client thisClient = myServer.available();
  // If the client is not null, and says something, display what it said
  if (thisClient !=null) {
    String whatClientSaid = thisClient.readString();
    if (whatClientSaid != null) {
      println(thisClient.ip() + "t" + whatClientSaid);
    } 
  } 

}

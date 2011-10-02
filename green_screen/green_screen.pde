import processing.video.*;

/**
 * Frame Differencing
 * by Golan Levin.
 *
 * GSVideo version by Andres Colubri.
 *
 * Quantify the amount of movement in the video frame using frame-differencing.
 */


// import codeanticode.gsvideo.*;

int numPixels;
int[] referenceFrame;
int threshold = 120;
boolean LOADED = false;

PImage bg;
Capture video;
//GSCapture video;

void setup() {
  size(640, 480); // Change size to 320 x 240 if too slow at 640 x 480
  // Uses the default video input, see the reference if this causes an error
  // video = new GSCapture(this, width, height, "/dev/video0", 24);
  video = new Capture(this, width, height, 24);
  numPixels = video.width * video.height;
  // Create an array to store the previously captured frame
  referenceFrame = new int[numPixels];
  bg = loadImage("beach.jpg");

  loadPixels();
}

int pcount = 0;
void draw() {
  if (video.available()) {
    // When using video to manipulate the screen, use video.available() and
    // video.read() inside the draw() method so that it's safe to draw to the screen
    video.read(); // Read the new frame from the camera
    video.loadPixels(); // Make its pixels[] array available

    if (!LOADED) {
      for (int i = 0; i < numPixels; i++) { // For each pixel in the video frame...
        color currColor = video.pixels[i];
        referenceFrame[i] = currColor;
        pixels[i] = currColor;
      }
      LOADED = true;
      updatePixels();
      println("Loaded referenceFrame");
    }

    // background(0);
    image(bg, 0, 0);
    
    int movementSum = 0; // Amount of movement in the frame
    for (int i = 0; i < numPixels; i++) { // For each pixel in the video frame...
      color currColor = video.pixels[i];
      color prevColor = referenceFrame[i];
      // Extract the red, green, and blue components from current pixel
      int currR = (currColor >> 16) & 0xFF; // Like red(), but faster
      int currG = (currColor >> 8) & 0xFF;
      int currB = currColor & 0xFF;
      // Extract red, green, and blue components from previous pixel
      int prevR = (prevColor >> 16) & 0xFF;
      int prevG = (prevColor >> 8) & 0xFF;
      int prevB = prevColor & 0xFF;
      // Compute the difference of the red, green, and blue values
      int diffR = abs(currR - prevR);
      int diffG = abs(currG - prevG);
      int diffB = abs(currB - prevB);

      if (diffR + diffB + diffG > threshold) {
        pixels[i] = currColor;
        pcount++;
      }  else {
        // pixels[i] = color(0,30);
        // pixels[i] = get(bg, int(i % height), int(i / height));
      }
    }
    // println(pcount);
    pcount = 0;

    updatePixels();
  }
}

/**
 * Brightness Tracking
 * by Golan Levin.
 *
 * GSVideo version by Andres Colubri.
 *
 * Tracks the brightest pixel in a live video signal.
 */

import codeanticode.gsvideo.*;

GSCapture video;

void setup() {
  size(640, 480); // Change size to 320 x 240 if too slow at 640 x 480
  // Uses the default video input, see the reference if this causes an error
  video = new GSCapture(this, width, height, "/dev/video0", 30);
  // smooth();
  println(video.height);
  println(video.width);
  background(0);
}

int LINELEN = 200;
int curdot = 0;
boolean LINEPOP=false;
int i=0;
int linex[] = new int[LINELEN];
int liney[] = new int[LINELEN];

void draw() {
  if (video.available()) {
    video.read();
    image(video, 0, 0, width, height); // Draw the webcam video onto the screen
    int brightestX = 0; // X-coordinate of the brightest video pixel
    int brightestY = 0; // Y-coordinate of the brightest video pixel
    float brightestValue = 0; // Brightness of the brightest video pixel
    // Search for the brightest pixel: For each row of pixels in the video image and
    // for each pixel in the yth row, compute each pixel's index in the video
    video.loadPixels();
    int index = 0;
    for (int y = 0; y < video.height; y++) {
      for (int x = 0; x < video.width; x++) {
        // Get the color stored in the pixel
        int pixelValue = video.pixels[index];
        // Determine the brightness of the pixel
        float pixelBrightness = brightness(pixelValue);
        // If that value is brighter than any previous, then store the
        // brightness of that pixel, as well as its (x,y) location
        if (pixelBrightness > brightestValue) {
          brightestValue = pixelBrightness;
          brightestY = y;
          brightestX = x;
        }
        index++;
      }
    }
    // Draw a large, yellow circle at the brightest pixel
    // fill(255, 204, 0);
    // ellipse(brightestX, brightestY, 4, 4);
    linex[curdot] = brightestX;
    liney[curdot] = brightestY;
    curdot = (curdot + 1) % LINELEN;
    // println(curdot);
  }
  stroke(200, 200, 0);
  if (curdot > 0 || LINEPOP) {
    LINEPOP = true;
    for (i=1; i < linex.length; i++) {
      // if (linex[i] < 0) break;
      line(linex[i], liney[i], linex[i-1], liney[i-1]);
    }
  }
}

void keyPressed() {
  if (key == ' ') background(0);
}

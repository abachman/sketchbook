import codeanticode.gsvideo.*;

GSCapture cam;

void setup() {
  size(640, 480);

  cam = new GSCapture(this, 320, 240);
}

void draw() {
  if (cam.available() == true) {
    cam.read();
    image(cam, 160, 100);
  }
}

/*
 * Working capture examples:
 *  Background Subtraction
 *  Brightness Thresholding
 *  Brightness Tracking
 *  Frame Differencing
 */

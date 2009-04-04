void initSticks() {
  // D Pad
  device.plug(this, "handleDpad", ControllIO.WHILE_PRESS, 0);
  cooliehat = device.getStick(0);
  cooliehat.setMultiplier(1.2);
  
  // left stick
  /*
  movementStick = device.getStick(1);
  ControllSlider transX = device.getSlider("X Axis");
  ControllSlider transY = device.getSlider("Y Axis");
  transX.setMultiplier(cw);
  transY.setMultiplier(ch);
  movementStick = new ControllStick(transX,transY);
  movementStick.setTolerance(0.06);
   
  // right stick
  ControllSlider sliderX = device.getSlider("Z Axis");
  sliderX.setTolerance(0.06);
  sliderX.setMultiplier(0.1);
  ControllSlider sliderY = device.getSlider("Z Rotation");  
  sliderY.setMultiplier(5);
  //transformStick = new ControllStick(sliderX,sliderY);
  */
}

void handleDpad(){
  transX += 1;
  transY += 1;
}

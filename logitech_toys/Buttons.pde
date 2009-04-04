boolean buttons[];

void initButtons() {
  buttons = new boolean[10];
  for (int b = 1; b < buttons.length; b++) {
    _setCallback("b" + b + "Press", "b" + b + "Release", b);
  } 
}

void _setCallback(String funcOn, String funcOff, int but) {
  device.plug(this, funcOn, ControllIO.ON_PRESS, but);
  device.plug(this, funcOff, ControllIO.ON_RELEASE, but);
}

void b1Release() {buttons[1] = false;}
void b2Release() {buttons[2] = false;}
void b3Release() {buttons[3] = false;}
void b4Release() {buttons[4] = false;}
void b5Release() {buttons[5] = false;}
void b6Release() {buttons[6] = false;}
void b7Release() {buttons[7] = false;}
void b8Release() {buttons[8] = false;}
void b9Release() {buttons[9] = false;}
void b10Release() {mover.skewoff = !mover.skewoff;}

void b1Press() {buttons[1] = true;}
void b2Press() {buttons[2] = true;}
void b3Press() {buttons[3] = true;}
void b4Press() {buttons[4] = true;}
void b5Press() {buttons[5] = true;}
void b6Press() {buttons[6] = true;}
void b7Press() {buttons[7] = true;}
void b8Press() {buttons[8] = true;}
void b9Press() {
  mover.colorize = !mover.colorize;
}

void b10Press() {
  mover.skewon = !mover.skewon;
  if (myChannel.state==Ess.PLAYING) {
    //myChannel.fadeTo(0, 300);
    myChannel.pause();
  }
  else {
    //myChannel.fadeTo(mover.hw / height, 300);
    myChannel.resume();    
  }
}

void checkButtons() {
  if (buttons[5]) b5Action();
  if (buttons[6]) b6Action();
  if (buttons[7]) b7Action();
  if (buttons[8]) b8Action();

  if (buttons[1]) b1Action();
  if (buttons[2]) b2Action();
  if (buttons[3]) b3Action();
  if (buttons[4]) b4Action();
  
  //if (buttons[9]) b9Action();
}

void b1Action() {
  // top left
  fill(0,0,200,70);
  rect(0,0,cw,ch);
}

void b2Action() { 
  // bottom left
  fill(0,0,200,70);
  rect(0,ch,cw,height);
}

void b3Action() {
  // bottom right
  fill(0,0,200,70);
  rect(cw,ch,width,height);
}

void b4Action() {
  // top right
  fill(0,0,200,70);
  rect(cw,0,width,ch);
}

void b5Action() {
  // top left
  //mover.blip1();
  fill(200,0,0);
  rect(0,0,cw,ch);
}

void b6Action() { 
  // top right
  //mover.blip2();
  fill(200,0,0);
  rect(cw,0,width,ch);
}

void b7Action() {
  // bottom left
  fill(200,0,0);
  rect(0,ch,cw,height);
}

void b8Action() {
  // bottom right
  fill(200,0,0);
  rect(cw,ch,width,height);
}

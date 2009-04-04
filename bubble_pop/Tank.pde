class Tank extends Unit {
  Tank () {
    super(width/2, height/2, 5);
    setSpeed(4);
  } 
  
  void update(float _x, float _y) {
    // TANK
    // _x and _y are the coordinates of the aiming point
    if (keysPressed['w'] || keysPressed['5'])
      y -= speed;
    if (keysPressed['s'] || keysPressed['2'])
      y += speed;
    if (keysPressed['a'] || keysPressed['1'])
      x -= speed;
    if (keysPressed['d'] || keysPressed['3'])
      x += speed;

    if (x < 0) x = 0;
    else if (x > width) x = width;
    if (y < 0) y = 0;
    else if (y > height) y = height;
    
    t = y-rad;
    b = y+rad;
    l = x-rad;
    r = x+rad;
  } 
}

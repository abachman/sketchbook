class Ship {
  int y;
  float x;
  float vx, mx;
  
  Ship(int x) {
    this.x = (float)x;
    this.y = height - 30;
    this.mx = 5.0;
  }
  
  void draw() {
    fill(255);
    rectMode(CENTER);
    rect(this.x, this.y, 20, 30);
  }
  
  void move(int dir) {
    if (dir == 0) {
      // stopping factor
      if (this.vx < 0) this.vx += 0.4;
      else if (this.vx > 0) this.vx -= 0.4;
    } else {
      // acceleration
      this.vx = this.vx + (0.4 * dir);
      
      if (this.vx < -this.mx) {
        this.vx = -this.mx;
      } else if (this.vx > this.mx) {
        this.vx = this.mx;
      }
    }
    
    float nx = this.x + this.vx;
    if (nx < width - 20 && nx > 20) {
      this.x = nx;  
    } else {
      this.vx = 0;
    }
  }
}
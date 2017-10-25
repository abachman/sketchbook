class Dot {
  int x, y, r;
  boolean isDead;
  
  Dot(int x) {
    this.isDead = false;
    this.x = x;
    this.y = height - 30;
    this.r = 4;
  }
  
  void draw() {
    fill(200, 100, 255);
    rect(this.x, this.y, this.r * 2, this.r * 10);
    //ellipse(this.x, this.y, this.r * 2, this.r * 2);
  }
  
  Dot move() {
    this.y -= 12;
    return this;
  }
  
  void kill() {
    this.isDead = true;
  }
}
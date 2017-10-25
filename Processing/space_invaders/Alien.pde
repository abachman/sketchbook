class Alien {
  int x, y, r, hits;
  boolean isDead;
  
  Alien(int x) {
    this.isDead = false;
    this.x = x;
    this.y = -10;
    this.r = 18;
    this.hits = 0;
  }
  
  void draw() {
    fill(200, 100, 50);
    int d = (this.r * 2) + (4 * this.hits);
    ellipse(this.x, this.y, d, d);
  }
  
  boolean isHit(Dot dot) {
    return dist(this.x, this.y, dot.x, dot.y) < this.r + dot.r;
  }
  
  Alien move() {
    this.y += 24;
    return this;
  }
  
  void kill() {
    if (this.hits++ > 3) {
      this.isDead = true; 
    }
  }
}
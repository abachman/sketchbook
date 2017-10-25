Ship ship;
boolean[] keys = new boolean[256];

int counter;

ArrayList<Dot> dots = new ArrayList<Dot>();
ArrayList<Alien> aliens = new ArrayList<Alien>();

void spawn() {
  aliens.add(
    new Alien(
      (int)random(30, width - 30)
    )
  );
}

void setup() {
  noStroke();
  size(600, 900);
  ship = new Ship(width / 2);
  
  for (int n=0; n < keys.length; n++) {
    keys[n] = false;
  }
  
  counter = 0;
  
  spawn();
}

void draw() {
  background(51);
  
  if (keys[LEFT]) {
    ship.move(-1);
  } else if (keys[RIGHT]) {
    ship.move(1);
  } else {
    ship.move(0);
  }
  
  if (keys[32] && counter % 3 == 0) {
    dots.add(new Dot((int)ship.x));
  }
  
  for (int j = 0; j < aliens.size(); j++) {
    Alien a = aliens.get(j);
    if (counter % 40 == 0) {
      a.move();
    }
    a.draw();
  }
  
  for (int i = 0; i < dots.size(); i++) {
    Dot dot = dots.get(i);
    dot.move().draw();
    if (dot.y < 0) {
      dot.kill();
    }
    
    for (int j = 0; j < aliens.size(); j++) {
      Alien a = aliens.get(j);
      if (a.isHit(dot)) {
        a.kill();
        dot.kill();
      }
    }
  }
  
  for (int i = dots.size() - 1; i >= 0; i--) {
    Dot dot = dots.get(i);
    if (dot.isDead) {
      dots.remove(i);
    }
  }
  
  for (int i = aliens.size() - 1; i >= 0; i--) {
    Alien a = aliens.get(i);
    if (a.isDead) {
      aliens.remove(i);
    }
  }
  
  if (counter % 80 == 0) {
    aliens.add(
      new Alien(
        (int)random(30, width - 30)
      )
    );
  }

  counter += 1;
  
  ship.draw();
  
}

void keyPressed() { 
  keys[keyCode] = true;
}

void keyReleased() {
  keys[keyCode] = false;
}
ArrayList<Boid> flock = new ArrayList<Boid>();
Boid pickedBoid;

void setup() {
  size(1280,720);
  for (int i=0; i<100; i++) {
    flock.add(new Boid());
  }

  strokeWeight(1);
  stroke(255);
}

void draw() {
  background(51);

  for (Boid b : flock) {
    b.flock(flock);
  }

  for (Boid b : flock) {
    b.update();
    b.show();
  }
}

void mouseClicked() {
  float leastDistance = 10000;
  
  for (Boid b : flock) {
    float d = dist(mouseX, mouseY, b.pos.x, b.pos.y);
    
    if (d < leastDistance) {
      leastDistance = d;
      pickedBoid = b;
    }
  }
}

class Bubble {
  float radius = random(2,5);
  PVector pos = new PVector(random(radius, width-radius), random(radius,height-radius));
  PVector buddy;
  boolean growing = true;
  ArrayList<Bubble> blacklisted = new ArrayList();
  
  Bubble() {
  }

  void update() {
    radius++;
    for (Bubble b : bubbles) {
      if (this != b 
          && PVector.dist(this.pos, b.pos) < this.radius+b.radius) {
        this.growing = false;
        //this.buddy = b.pos.copy();
        break;
      } else if (this.pos.x + this.radius > width
          || this.pos.x - this.radius < 0
          || this.pos.y + radius > height
          || this.pos.y - radius < 0) {
            this.growing = false;
            break;
      }
    }
    //if (this.radius > 50) {
    //  this.growing = false;
    //}
  }
  
  void show() {
    stroke(255);
    noFill();
    if (!turnOffCircles) { 
      ellipse(pos.x, pos.y, radius*2, radius*2);
    }
    if (!turnOffLines && buddy != null) {
      line(this.pos.x, this.pos.y, buddy.x, buddy.y);
    }
  }
}
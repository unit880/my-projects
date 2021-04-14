class Bubble {
  // the circle's starting radius
  float radius = random(2,5);
  // our starting position vector
  PVector pos = new PVector(random(radius, width-radius), random(radius,height-radius));
  // a circle's buddy is who it will connect to in the future, just a pvector to draw a line to.
  PVector buddy;
  // growing is what keeps track of if we'll continue to update or not
  boolean growing = true;
  // this keeps track of the bubble that we don't want to connect this one to
  Bubble blacklisted;
  
  // just in case we'd want to add anything to the constructor
  Bubble() {}

  void update() {
    // increase radius while growing
    radius++;
    
    // then for every bubble...
    for (Bubble b : bubbles) {
      // we check if it touches another one or the wall, and if it does we stop it from growing,
      // and break out of the loop because it's done.
      
      if ((this != b && PVector.dist(this.pos, b.pos) < this.radius+b.radius) || // for other circles
          (this.pos.x + this.radius > width || this.pos.x - this.radius < 0 || // if the radius+x position leaves the boundaries
           this.pos.y + radius > height || this.pos.y - radius < 0)) { // and if the radius+y position leaves the boundaries
            this.growing = false;
            break;
      }
    }
  }
  
  // this just shows the circle/line at the end
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

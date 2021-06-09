class Splash {
  constructor(x,z) {
    this.pos = createVector(x, height-1, z);
    this.vel = createVector(0, 0);
    this.acc = createVector(random(-3, 3), random(-3, -5));
    this.sunk = false;
  }
  
  update() {
    this.vel.add(this.acc);
    this.pos.add(this.vel);
    
    this.acc.x += (wind/this.pos.z);
    this.acc.y += (gravity/(this.pos.z*2.5));
    
    this.acc.mult(0.2);
    

    
    if (this.pos.y > height-5) {
      this.sunk = true;
    }
  }
  
  show() {
    stroke(255);
    fill(255);
    strokeWeight(this.pos.z)
    point(this.pos.x, this.pos.y);
  }
}
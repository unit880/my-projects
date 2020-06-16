class Drop {
  constructor() {
    this.pos = createVector(random(0,width), 
                             random(0,height),
                             random(1,3));
  }
  
  update() {
    this.pos.x = this.pos.x + (wind/this.pos.z);
    this.pos.y = this.pos.y + (gravity/this.pos.z);
    
    if (this.pos.y > height) {
      this.pos.y = -10;
      
      for (let i=0; i<3; i++) {
        splashes.push(new Splash(this.pos.x,
                                   this.pos.z));
      }
    }
    
    if (this.pos.x > width) {
      this.pos.x = 0;
    } else if (this.pos.x < 0) {
      this.pos.x = width;
    }
  }
  
  show() {
    stroke(255);
    strokeWeight(this.pos.z);
    line(this.pos.x, this.pos.y, this.pos.x+wind, this.pos.y+gravity);
  }
}
class Leaf { 
  PVector pos;
  boolean reached = false;
  int lifespan = 0;
  
  Leaf() {
    // Give the leaf a random position in 3d space
    pos = PVector.random3D();
    // Alter the position to be further from the others
    pos.mult(random(width/2));
  }
  
  void show() {
    this.lifespan++;
    // Show the leaf at it's position
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    ellipse(0, 0, 4, 4);
    popMatrix();
  }
}
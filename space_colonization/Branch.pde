class Branch {
  PVector pos;
  PVector parent;
  PVector dir;
  PVector originalDir;
  int count = 0;
  int len = 5;
  
  Branch(PVector parent, PVector pos, PVector dir) {
    this.pos = pos;
    this.parent = parent;
    this.dir = dir;
    // Keep track of original direction for when we need to reset it
    this.originalDir = dir.copy();
  }
  
  // Function for finding the next direction
  Branch next() {
    PVector nextDir = PVector.mult(this.dir, this.len);
    PVector nextPos = PVector.add(this.pos, this.dir);
    Branch nextBranch = new Branch(this.pos, nextPos, nextDir.normalize());
    return nextBranch;
  }
  
  // Function to reset a branch
  void reset() {
    this.dir = originalDir.copy();
    count = 0;
  }
  
  void show() {
    if (parent != null) {
      line(parent.x, parent.y, parent.z, pos.x, pos.y, pos.z);
    }
  }
}
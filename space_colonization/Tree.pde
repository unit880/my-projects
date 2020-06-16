class Tree {
  ArrayList<Leaf> leaves = new ArrayList();
  ArrayList<Branch> branches = new ArrayList();
  Branch root;
  
  // Constructor for the tree
  Tree(int leaves) {
    for (int i=0; i<leaves; i++) {
      this.leaves.add(new Leaf());
    }
    root = new Branch(null, new PVector(0, 0, 0), new PVector(0, -1));
    branches.add(root);
    
    boolean found = false;
    Branch current = root;
      while (!found) {
      for (int i=0; i<this.leaves.size(); i++) {
        float d = PVector.dist(current.pos, this.leaves.get(i).pos);
        if (d<maxDist) {
          found = true;
        }
      }
      if (!found) {
        Branch branch = current.next();
        current = branch;
        branches.add(branch);
      }
    }
  }
  
  // Update function for the tree
  void grow() {

    // For every leaf    
    for (int i=0; i<leaves.size(); i++) {
      // Loop through and get the closest branch
      Leaf leaf = leaves.get(i);
      Branch closestBranch = null;
      float record = 1000000;
      for (int j=0; j<branches.size(); j++) {
        Branch branch = branches.get(j);
        float d = PVector.dist(leaf.pos, branch.pos);
        // if distance is less than minimum distance, the leaf has been reached
        if (d < minDist) {
          leaf.reached = true;
          closestBranch = null;
          break;
        // Keep track of the closest branch and how close it is
        } else if (closestBranch == null || d < record) {
          closestBranch = branch;
          record = d;
        }
      }
      
      // Grow the branch towards its leaf
      if (closestBranch != null) {
        PVector newDir = PVector.sub(leaf.pos, closestBranch.pos);
        newDir.normalize();
        PVector offset = PVector.random3D();
        offset.setMag(0.03);
        closestBranch.dir.add(newDir);
        closestBranch.dir.add(offset);
        closestBranch.count++;
      }
    }

    // Remove any leaves that have been reached    
    for (int i=leaves.size()-1; i>0; i--) {
      if (leaves.get(i).reached) {
        leaves.remove(i);
      }
    }
    
    // Reset and add a new child branch to a parent branch that needs it
    for (int i=branches.size()-1; i>=0; i--) {
      Branch branch = branches.get(i);
      if (branch.count > 0) {
        branch.dir.div(branch.count);
        branches.add(branch.next());
      }
      branch.reset();
    }
  }
  
  void show() {
    for (int i=leaves.size()-1; i>=0; i--) {
      Leaf leaf = leaves.get(i);
      leaf.show();
      if (leaf.lifespan > width*0.70) {
        leaves.remove(i);
      }
    }
    
    for (int i=0; i<branches.size(); i++) {
      Branch branch = branches.get(i);
      float sw = map(i, 0, branches.size(), 5, 0.5);
      strokeWeight(sw);
      branch.show();
    }
  }
}
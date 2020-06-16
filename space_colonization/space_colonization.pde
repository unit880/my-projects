import peasy.*;


Tree tree;
int maxDist = 100;
int minDist = 15;
PeasyCam cam;

void setup() {
  size(700, 700, P3D);
  cam = new PeasyCam(this, width);
  tree = new Tree(500);
  stroke(255);
}

void draw() {
  background(51);
  tree.show();
  tree.grow();
}
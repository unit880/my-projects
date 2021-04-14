// Made by: unit880
// Circle Packing Constellations w/ blacklisting

// the circles
ArrayList<Bubble> bubbles;
// how many attempts we have of placing circles, here we stop at 1,000
int attempts;
int attemptsCap = 1000;
// FALSE means turning on displaying the circles
boolean turnOffCircles = false;
// FALSE means turning on the displaying of which circles have touched, ending their lifetime
boolean turnOffLines = false;
boolean generatedShortest;

// You can click in the display to generate a new set of circle packing

void setup() {
  fullScreen();
  
  // initialize our variables
  attempts = 0;
  generatedShortest = false;
  bubbles = new ArrayList();
  bubbles.add(new Bubble());
  
  // while the map has not been generated
  while (!generatedShortest) {
    
    // here we make new bubbles, and make sure they're not overlaying each other
    // in the future it might be nice to add poisson disc sampling?
    
    Bubble temp = new Bubble();
    boolean valid = true;
    for (Bubble b : bubbles) {
      if (PVector.dist(temp.pos, b.pos) < (temp.radius+b.radius)) {
        valid = false;
        attempts++;
        break;
      }
    }
    
    // if they don't, we add it to the arraylist
    if (valid) {
      bubbles.add(temp);
    }
    
    // grow the bubbles and see if they touch each other
    // if they do, we stop them from updating in the future
    for (Bubble b : bubbles) {
      if (b.growing) {
        b.update();
      }
    }
    
    // when the attempts reach our cap, we stop and do all of our dot-connecting
    if (attempts == attemptsCap) {
      for (Bubble b : bubbles) {
        // set a min distance higher than any screen is typically longest at it's diagonal,
        // so that no matter how far points are away it'll be lower than this
        float minDist = 100000;
        for (Bubble a : bubbles) {
          // we check for three things connecting the point:
          // that it does not connect to itself
          // that it is not already connected to the other point
          // and then finally, if the distance is less than previous distances it's seen
          if (a != b && b.blacklisted != a && PVector.dist(b.pos, a.pos) < minDist) {
            // then if all these are true, we connect them and blacklist the other point for the one it's already connected to
            minDist = PVector.dist(b.pos, a.pos);
            b.buddy = a.pos;
            a.blacklisted= b;
          }
        }
      }
      // this breaks the loop, and we're free
      generatedShortest = true;
    }
  }
}

// and here we just draw the finished map
void draw() {
  background(51);
  
  for (Bubble b : bubbles) {
    b.show();
  }
}

// here we find our commands for generating new maps, 
// and turning off certain visual aspects
void mousePressed() {
  if (mouseButton == LEFT) {
    setup();
  } else if (mouseButton == RIGHT) {
    turnOffCircles = !turnOffCircles;
  }
}

void keyPressed() {
  if (key == TAB) {
    turnOffLines = !turnOffLines;
  }
}

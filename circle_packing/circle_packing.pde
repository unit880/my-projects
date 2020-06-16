ArrayList<Bubble> bubbles;
int attempts;
// FALSE means turning on displaying the circles
boolean turnOffCircles = false;
// FALSE means turning on the displaying of which circles have touched, ending their lifetime
boolean turnOffLines = false;
boolean generatedShortest;

// You can click in the display to generate a new set of circle packing

void setup() {
  fullScreen(2);
  attempts = 0;
  generatedShortest = false;
  bubbles = new ArrayList();
  bubbles.add(new Bubble());
  
  while (!generatedShortest) {
    Bubble temp = new Bubble();
    boolean valid = true;
    for (Bubble b : bubbles) {
      if (PVector.dist(temp.pos, b.pos) < (temp.radius+b.radius)) {
        valid = false;
        attempts++;
        break;
      }
    }
    if (valid) {
      bubbles.add(temp);
    }
    
    for (Bubble b : bubbles) {
      if (b.growing) {
        b.update();
      }
    }
    
    if (attempts == 1000) {
      for (Bubble b : bubbles) {
        float minDist = 10000;
        for (Bubble a : bubbles) {
          if (a != b && !b.blacklisted.contains(a) && PVector.dist(b.pos, a.pos) < minDist) {
            minDist = PVector.dist(b.pos, a.pos);
            b.buddy = a.pos;
            a.blacklisted.add(b);
          }
        }
      }
      generatedShortest = true;
    }
  }
}

void draw() {
  background(51);
  
  for (Bubble b : bubbles) {
    b.show();
  }
}

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
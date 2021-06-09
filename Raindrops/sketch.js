let wind;
let gravity;
let drops;
let splashes;

function setup() {
  createCanvas(windowWidth, windowHeight);
  
  wind = random(-2,2);
  gravity = random((displayWidth/windowWidth)*17, (displayHeight/windowHeight)*20);
  drops = [];
  splashes = [];
  
  let dropAmount = (windowWidth+windowHeight)/20;

  for (let i=0; i<dropAmount; i++) {
    drops.push(new Drop(random(width), random(height)));
  }
}

function draw() {
  background(72);

  for (let i=0; i<drops.length; i++) {
    drops[i].update();
    drops[i].show();
  }
  
  for (let i=splashes.length-1; i>=0; i--) {
    splashes[i].update();
    splashes[i].show();

    if (splashes[i].sunk) {
      splashes.splice(i, 1);
    }
  }
}

function windowResized() {
  resizeCanvas(windowWidth, windowHeight);
  gravity = random((displayWidth/windowWidth)*17, (displayHeight/windowHeight)*20);

  let dropDifference = ((windowWidth+windowHeight)/20)-drops.length;

  if (dropDifference >= 0) {
    for (let i=0; i<dropDifference; i++) {
      drops.push(new Drop());
    }
  } else {
    drops.splice(0, abs(dropDifference));
  }
}
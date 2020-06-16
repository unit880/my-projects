var wind;
var gravity;
var drops;
var splashes;

function setup() {
  createCanvas(600, 600);
  
  wind = random(-2,2);
  gravity = random(7,10);
  drops = [];
  splashes = [];
  
  for (let i=0; i<100; i++) {
    drops[i] = new Drop();
  }
}

function draw() {
  background(72);

  for (let i=0; i<drops.length; i++) {
    drops[i].update();
    drops[i].show();
  }
  
  for (let i=splashes.length-1; i>=0; i--) {
    if (splashes[i].sunk) {
      splice(splashes[i], 1);
    }
    
    splashes[i].update();
    splashes[i].show();
  }
}
int cols, rows;
int scale = 20;
int w = 1400;
int h = 1700;
float flight_speed = 0;

float[][] terrain;

void setup() {
  size(600, 600, P3D);
  cols = w/scale;
  rows = h/scale;
  terrain = new float[cols][rows];


}

void draw() {
  
  flight_speed -= 0.04;
  
  float yoff = flight_speed;
  for (int y=0; y<rows-1; y++) {
    float xoff = 0;
    for (int x=0; x<cols; x++) {
      terrain[x][y] = map(noise(xoff,yoff), 0, 1, -75, 75);
      xoff += .075;
    }
    yoff += .075;
  }
  
  background(50);
  noStroke();
  fill(200);
  lights();
  
  translate(width/2, height/2);
  rotateX(PI/3);
  translate(-w/2, -h/2);

  for (int y=0; y<rows-1; y++) {
    beginShape(TRIANGLE_STRIP);
    for (int x=0; x<cols; x++) {
      vertex(x*scale, y*scale, terrain[x][y]);
      vertex(x*scale, (y+1)*scale, terrain[x][y+1]);
    }
    endShape();
  }

}

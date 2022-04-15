import processing.serial.*;
Serial controller_serial_port;

int mapX = 10000;
int mapY = 10000;
PVector ballPosition = new PVector(400,400);

Ball ball = new Ball(1, -300, 500);

void setup() {
  size(800,800);
  background(255);
  
}

void draw() {
  ball.drawSelf();
  
  // 1. order balls by size.
  //2. start with smallest ball - if center is within bigger radius of bigger center then get eaten
  //3. iterate through where they only check for balls bigger than them.
}

PVector redrawMap(PVector location) {
  // take their position and redefine it according to the new "center" as long as its in limits
  location.x = ballPosition.x + location.x;
  location.y = ballPosition.y + location.y;
  
  return location;
}

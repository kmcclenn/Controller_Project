import processing.serial.*;
Serial controller_serial_port;

int mapX = 10000;
int mapY = 10000;

Ball ball = new Ball(1, -300, 500);

void setup() {
  size(800,800);
  background(255);
  
}

void draw() {
  ball.drawSelf();
}

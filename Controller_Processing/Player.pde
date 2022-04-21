class Player {// make class player - then ball extends player 
  int diameter;
  color ballColor;
  color strokeColor;
  boolean active;
  
  float maxAccel;
  float speedMag;
  int counterSinceBeginning;
  int switchRate; // rate at which speed changes
  float speedCons; // constant for inverse prop relationship between speed and dist: speedMag = speedCons/diameter
  PVector position;
  PVector speed;
  PVector acceleration;
  
  
  Player(float _x, float _y) {
    
    position = new PVector(_x, _y);
    speed = new PVector(sqrt(speedMag), sqrt(speedMag));
    acceleration = new PVector(0,0);
    active = true;
    maxAccel = 2;
    speedMag = 2;
    counterSinceBeginning = 0;
    strokeColor = color(0,0,0);
    ballColor = color(random(255), random(255), random(255));
    diameter = 30;
    switchRate = 50;
    speedCons = 60;
  }
  
  void run() {
    if (active) {
      
      move();
      //accelerate();
      drawSelf();
      //println("running run");
    }
    counterSinceBeginning++;
  }
  
  void drawSelf() {
    //background(51);
    
    stroke(strokeColor);
    fill(ballColor);
    //print("drawing circle. xpos: " + position.x + ", ypos: " + position.y + ", diameter: " + diameter);
    circle(position.x, position.y, diameter);
  }
  
  void move() {
    position.add(speed);
  }
  
  void accelerate() {
    int maxWidth = mapX/2 - diameter;
    if (position.x > maxWidth || position.x < -maxWidth || position.y > maxWidth || position.y < -maxWidth) {
      speed.add(acceleration.mult(-1));
    } else {
      speed.add(acceleration);
    }
    
  }
  
  
  
  
  void eatBall(int size) {
    
    diameter += size;
  }
  
  void getEaten() {
    
    active = false;
  }
  
  
}

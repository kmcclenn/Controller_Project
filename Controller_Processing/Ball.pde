class Ball {
  int diameter = 30;
  color ballColor = color(random(255), random(255), random(255));
  color strokeColor = color(0,0,0);
  int aiType; // different function for ai
  boolean visible;
  
  
  /// TYPES ///
  // 1: Only goes for your ball.
  // 2. Goes towards nearest ball.
  // 3. Goes in random direction.
  ////////////
  
  PVector position;
  PVector speed;
  PVector acceleration;
  
  Ball(int _aiType, float _x, float _y) {
    aiType = _aiType;
    position = new PVector(_x, _y);
    speed = new PVector(0, 0);
    acceleration = new PVector(0,0);
    visible = true;
  }
  
  void run() {
    if (visible) {
      changeSpeed();
      move();
      accelerate();
      drawSelf();
    }
  }
  
  void drawSelf() {
    background(255);
    
    stroke(strokeColor);
    fill(ballColor);
    circle(position.x, position.y, diameter);
    
  }
  
  void move() {
    position.add(speed);
  }
  
  void accelerate() {
    speed.add(acceleration);
  }
  
  void changeSpeed(PVector ballToTarget) {
    if (aiType == 1) {
    } else if (aiType == 2) {
    } else if (aiType == 3) {
      acceleration.x = random(15);
      acceleration.y = random(15);
    } else {
      print("Invalid AI Type");
    }
  }
  
  PVector findNearestBall() {
    // finds nearest ball and returns pvector of its coordinates
  }
  
  PVector findUserBall() {
    // finds the player's ball and returns pvector of its coordinates.
  }
  
  void eatBall(int size) {
    diameter += size;
  }
  
  void getEaten() {
    visible = false;
  }
  
}

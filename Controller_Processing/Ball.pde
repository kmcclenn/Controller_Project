class Ball {
  int diameter = 30;
  color ballColor = color(random(255), random(255), random(255));
  color strokeColor = color(0,0,0);
  int aiType; // different function for ai
  boolean visible;
  float k; // gravitational constant
  float maxAccel;
  float speedMag;
  
  
  
  /// TYPES ///
  // 0: Only goes for your ball.
  // 1. Goes towards nearest ball.
  // 2. Goes in random direction.
  ////////////
  
  PVector position;
  PVector speed;
  PVector acceleration;
  PVector nearestBall; // position of
  
  Ball(int _aiType, float _x, float _y) {
    aiType = _aiType;
    position = new PVector(_x, _y);
    speed = new PVector(sqrt(speedMag), sqrt(speedMag));
    acceleration = new PVector(0,0);
    visible = true;
    k = 1;
    maxAccel = 2;
    speedMag = 2;
    
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
    //background(51);
    
    stroke(strokeColor);
    fill(ballColor);
    circle(position.x, position.y, diameter);
  }
  
  void move() {
    position.add(speed);
  }
  
  void accelerate() {
    int maxWidth = 5000 - diameter;
    if (position.x > maxWidth || position.x < -maxWidth || position.y > maxWidth || position.y < -maxWidth) {
      speed.add(acceleration.mult(-1));
    } else {
      speed.add(acceleration);
    }
    
  }
  
  void changeSpeed() {
    
    if (aiType == 0) {
    } else if (aiType == 1) {
      PVector.fromAngle(angleToPoint(nearestBall), speed);
      
      //acceleration.x = min(k/xdist squared, maxAccel);
     //if (nearestBall.x > position.x) {
     //  acceleration.x = abs(acceleration.x);
     //} else if (nearestBall.x < position.x) {
     //  acceleration.x = -1 * abs(acceleration.x);
     //} else {
     //  acceleration.x = 0;
     //}
     
     // same with y
     
     // acceleration.x = - mimumum between (1/dist^2) and a certain value (2?)
      //acceleration.y = ;
    } else if (aiType == 2) {
      PVector.fromAngle(random(0, 2*PI), speed);
    } else {
      print("Invalid AI Type");
    }
    speed = speed.setMag(speedMag);
  }
  
  float angleToPoint(PVector destination) {
    float slope = (destination.y - position.y)/(destination.x - position.x);
    float angle = atan(slope);
    if (destination.x < position.x) {
      angle += PI;
    }
    return angle;
  }
  
  void setNearestBall(PVector nearestBallInput) {
    nearestBall = nearestBallInput;
    //print(nearestBall);
    // finds nearest ball and returns pvector of its coordinates
  }
  
  void findUserBall() {
    // finds the player's ball and returns pvector of its coordinates.
  }
  
  void eatBall(int size) {
    diameter += size;
  }
  
  void getEaten() {
    visible = false;
  }
  
  int getSize() {
    return diameter;
  }
  
}

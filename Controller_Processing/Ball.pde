class Ball extends Player {
  
  int aiType; // different function for ai
 
  float k; // gravitational constant
  
  
  
  
  /// TYPES ///
  // 0: Only goes for your ball.
  // 1. Goes towards nearest ball.
  // 2. Goes in random direction.
  ////////////
  Ball nearestBall; 
  Player userBall; 
  
  Ball(int _aiType, float _x, float _y) {
    super(_x, _y);
    aiType = _aiType;
    k = 1;
    
    
  }
  
  @Override
  void run() {
    if (active) {
      move();
      drawSelf();
      changeSpeedMag();
      changeSpeedDirec();
    }
    counterSinceBeginning++;
  }
  
  @Override
  void drawSelf() {
    stroke(strokeColor);
    fill(ballColor);
    //print("drawing circle. xpos: " + position.x + ", ypos: " + position.y + ", diameter: " + diameter);
    if ((abs(position.x - userBall.position.x) < (width/2 + diameter/2)) && (abs(position.y - userBall.position.y) < (height/2 + diameter/2))) {
      circle(mappedPosition.x, mappedPosition.y, diameter);
    }
    
  }
  
  void changeSpeedMag() {
    speedMag = max(speedCons/diameter, 0.5); // bigger goes slower! // needs work. but good for now.
  }
  
  void changeSpeedDirec() {
    // AI might be better if all of them have the functionality that if nearest ball is bigger - go away. if nearest ballis smaller go towards. maybe 
    if (counterSinceBeginning % switchRate == 0) {
    
      if (aiType == 0) {
        
        PVector.fromAngle(angleToPoint(userBall.position), speed);
        if (diameter < userBall.diameter) {
          speed.mult(-1);
        }
      } else if (aiType == 1) {
        
        PVector.fromAngle(angleToPoint(nearestBall.position), speed);
        if (diameter < nearestBall.diameter) {
          speed.mult(-1);
        }
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
  }
  
  float angleToPoint(PVector destination) {
    float slope = (destination.y - position.y)/(destination.x - position.x);
    float angle = atan(slope);
    if (destination.x < position.x) {
      angle += PI;
    }
    return angle;
  }
  
  void setNearestBall(Ball nearestBallInput) {
    nearestBall = nearestBallInput;
    //print(nearestBall);
    // finds nearest ball and returns pvector of its coordinates
  }
  
  void setUserBall(Player userBallInp) {
    // finds the player's ball and returns pvector of its coordinates.
    userBall = userBallInp;
  }
  
  int getSize() {
    return diameter;
  }
  
}

class Ball extends Player {
  
  int aiType; // different function for ai
 
  float k; // gravitational constant
  
  
  
  
  /// TYPES ///
  // 0: Only goes for your ball.
  // 1. Goes towards nearest ball.
  // 2. Goes in random direction.
  ////////////
  PVector nearestBall; // position of

  
  Ball(int _aiType, float _x, float _y) {
    super(_x, _y);
    aiType = _aiType;
    k = 1;
    
    
  }
  
  @Override
  void run() {
    if (active) {
      move();
      drawSelf(mappedPosition.x, mappedPosition.y);
      changeSpeedMag();
      changeSpeedDirec();
    }
    counterSinceBeginning++;
  }
  
  
  void changeSpeedMag() {
    speedMag = max(speedCons/diameter, 0.5); // bigger goes slower! // needs work. but good for now.
  }
  
  void changeSpeedDirec() {
    // AI might be better if all of them have the functionality that if nearest ball is bigger - go away. if nearest ballis smaller go towards. maybe 
    if (counterSinceBeginning % switchRate == 0) {
    
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
  
  int getSize() {
    return diameter;
  }
  
}

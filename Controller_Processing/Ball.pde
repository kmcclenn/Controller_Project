class Ball extends Player {

  int aiType; // different function for ai

  /// TYPES ///
  // 0: Only goes for or away your ball depending on size.
  // 1. Goes towards or away nearest ball depending on size.
  // 2. Goes in random direction.
  ////////////
  Ball nearestBall;
  Player userBall;

  Ball(int _aiType, float _x, float _y) {
    super(_x, _y);
    aiType = _aiType;
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



  void changeSpeedDirec() {
    // 3 different ai types
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
      } else if (aiType == 2) {

        PVector.fromAngle(random(0, 2*PI), speed);
      } else {
        print("Invalid AI Type");
      }
      speed = speed.setMag(speedMag);
    }
  }

  // finds the angle from the ball's center to a point
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
  }

  void setUserBall(Player userBallInp) {
    userBall = userBallInp;
  }

  int getSize() {
    return diameter;
  }
}

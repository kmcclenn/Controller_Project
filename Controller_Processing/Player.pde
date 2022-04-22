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
  PVector mappedPosition; // the actual position the the ball is in - not the position relative to the start and assuming that the player is ACTUALLY moving
  

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
    mappedPosition = position;
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
    
    circle(width/2, height/2, diameter);
    
    
  }
  
  void move() {
    if (position.x + diameter/2 < mapX/2 && position.x - diameter/2 > -mapX/2 && position.y + diameter/2 < mapY/2 && position.y - diameter/2 > -mapY/2) {
      position.add(speed); // position of where it would be if background wasn't shifting - for reference
      mappedPosition.add(speed); // actual position
    }
    
    if (position.x + diameter/2 >= mapX/2) {
      position.x -= diameter/2;
    } else if (position.x - diameter/2 <= -mapX/2) {
      position.x += diameter/2;
    } else if (position.y + diameter/2 >= mapY/2) {
      position.y -= diameter/2;
    } else if (position.y - diameter/2 <= -mapY/2) {
      position.y += diameter/2;
    }
    //if ((position.x > mapX/2 || position.x < -mapX/2) && (position.y > mapY/2 || position.y < -mapY/2)) {
    //  position.add(speed.mult(-1));
    //} else if (position.x > mapX/2 || position.x < -mapX/2) {
    //  position.x -= speed.x;
    //  position.y += speed.y;
    //} else if (position.y > mapY/2 || position.y < -mapY/2) {
    //  position.x += speed.x;
    //  position.y -= speed.y;
    //} else {
    //  position.add(speed);
    //}
  }
 
  //void accelerate() {
  //  int maxWidth = mapX/2 - diameter;
    
  //    speed.add(acceleration.mult(-1));
  //  } else {
  //    speed.add(acceleration);
  //  }
    
  //
  
  
  
  
  void eatBall(int size) {
    
    diameter += size;
  }
  
  void getEaten() {
    
    active = false;
  }
  
}

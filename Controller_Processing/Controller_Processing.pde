import processing.serial.*;
import java.util.Collections;
import java.util.Comparator;
Serial controller_serial_port;

int mapX = 10000;
int mapY = 10000;
PVector ballPosition = new PVector(400,400);
int startBallNumber = 50;

ArrayList<Ball> computerBalls = new ArrayList();// create array list with 50 balls or something

// METHOD FOR EATING //
  // 1. order balls by size.
  //2. start with smallest ball - if center is within bigger radius of bigger center then get eaten
  //3. iterate through where they only check for balls bigger than them.

void setup() {
  size(800,800);
  background(51);
  for (int i=0; i < startBallNumber; i++) {
    int randomX = 10*(int(random(-500, 500))); // multiplied by 10 so they start at least 10 apart
    int randomY = 10*(int(random(-500, 500)));
    int randomAI = int(random(3));
    computerBalls.add(new Ball(randomAI, randomX, randomY));
  }
  print(computerBalls);
}

void draw() {
  
  Collections.sort(computerBalls, Comparator.comparingInt(Ball::getSize)); // step 1. see below
  
  // loops through balls to find the nearest one to each.
  for (int i = 0; i < computerBalls.size(); i++) {
    
    
    // set nearest ball chunk
    PVector nearestBall = new PVector(0,0);
    float distanceFromBall = 10000; // set as high number to start
    for (int j=0; j < computerBalls.size(); j++) {
      if ((computerBalls.get(i).position.dist(computerBalls.get(j).position) < distanceFromBall) || (i != j)) {
        nearestBall = computerBalls.get(j).position;
      }
      computerBalls.get(i).setNearestBall(nearestBall);   
    }
    
    // redraw map/coords chunk
    computerBalls.get(i).position = redrawMap(computerBalls.get(i).position);
    
    //eat chunk 
    for (int j=i+1; j < computerBalls.size(); j++) { // step 2. only loops through balls bigger
      // if distance between centers is less than the difference between the radii
      if (computerBalls.get(i).position.dist(computerBalls.get(j).position) < (0.5*(computerBalls.get(j).diameter - computerBalls.get(i).diameter))) { 
        computerBalls.get(j).eatBall(computerBalls.get(j).diameter);
        computerBalls.get(i).getEaten();
      }
    }
    //print("ball run:" + i);
    //run!!!!!
    computerBalls.get(i).run();
  }
}

PVector redrawMap(PVector location) {
  // take their position and redefine it according to the new "center" as long as its in limits
  location.x = location.x - ballPosition.x;
  location.y = location.y - ballPosition.y;
  
  return location;
}

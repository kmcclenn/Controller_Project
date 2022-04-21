import processing.serial.*;
import java.util.Collections;
import java.util.Comparator;
Serial controller_serial_port;

int mapX = 2000;
int mapY = 2000;
PVector ballPosition = new PVector(0,0);
int startBallNumber = 75;
int backgroundColor = 153;
int startFoodNumber = 200;

ArrayList<Ball> computerBalls = new ArrayList();// create array list with 50 balls or something
ArrayList<Food> computerFoods = new ArrayList();

// METHOD FOR EATING //
  // 1. order balls by size.
  //2. start with smallest ball - if center is within bigger radius of bigger center then get eaten
  //3. iterate through where they only check for balls bigger than them.

void setup() {
  size(800,800);
  background(backgroundColor);
  for (int i=0; i < startBallNumber; i++) {
    int randomX = 10*(int(random(-mapX/20, mapX/20))); // multiplied by 10 so they start at least 10 apart
    int randomY = 10*(int(random(-mapY/20, mapY/20)));
    int randomAI = int(random(3));
    computerBalls.add(new Ball(1, randomX, randomY));
    
  }
  
  for (int i=0; i < startFoodNumber; i++) {
    int randomX = 10*(int(random(-mapX/20, mapX/20))); // multiplied by 10 so they start at least 10 apart
    int randomY = 10*(int(random(-mapY/20, mapY/20)));
    computerFoods.add(new Food(randomX, randomY));
    
  }
  
  // debug if:
  int counter = 0;
  for (int i=0; i < computerBalls.size(); i++) {
    print("position " + computerBalls.get(i).position);
    if (computerBalls.get(i).position.x < 500 && computerBalls.get(i).position.x > 0 && computerBalls.get(i).position.y < 500 && computerBalls.get(i).position.y > 0) {
      counter++;
    }
  }
  print("counter in frame: " + counter);
  //print(computerBalls);
}

void draw() {
  background(backgroundColor);
  Collections.sort(computerBalls, Comparator.comparingInt(Ball::getSize)); // step 1. see below
  
  // loops through balls to find the nearest one to each.
  ballLoop:
  for (int i = 0; i < computerBalls.size(); i++) {
    
    
    // set nearest ball chunk
    PVector nearestBall = new PVector(0,0);
    float distanceFromBall = 100000; // set as high number to start
    for (int j=0; j < computerBalls.size(); j++) {
      if ((computerBalls.get(i).position.dist(computerBalls.get(j).position) < distanceFromBall) && (i != j)) {
        nearestBall = computerBalls.get(j).position;
        distanceFromBall = computerBalls.get(i).position.dist(nearestBall);
        //print("if ran");
      }
      //println(distanceFromBall);
      //print(nearestBall);
    }
    computerBalls.get(i).setNearestBall(nearestBall);
    
    // redraw map/coords chunk 
    computerBalls.get(i).position = redrawMap(computerBalls.get(i).position);
    
    //eat chunk 
    for (int j=i+1; j < computerBalls.size(); j++) { // step 2. only loops through balls bigger
      // if distance between centers is less than the difference between the radii
      
      if (ballInBall(computerBalls.get(j).position, computerBalls.get(i).position, computerBalls.get(j).diameter, computerBalls.get(i).diameter)) { 
        if (computerBalls.get(i).active) {
          computerBalls.get(j).eatBall(computerBalls.get(i).diameter);
        }
        computerBalls.get(i).getEaten();
        
        continue ballLoop;
      }
    }
    
    //see if over any food!
    foodLoop:
    for (int j=0; j < computerFoods.size(); j++) {
      if (ballInBall(computerBalls.get(i).position, computerFoods.get(j).position, computerBalls.get(i).diameter, computerFoods.get(j).diameter)) {
        if (computerFoods.get(j).active) {
          computerBalls.get(i).diameter += computerFoods.get(j).diameter;
        }
        
        computerFoods.get(j).getEaten();
        continue foodLoop;// maybe remove from array list too?
      }
    
    }
    
    
    //run!!!!!
    computerBalls.get(i).run();
  }
  for (int i=0; i < computerFoods.size(); i++) {
    computerFoods.get(i).drawSelf();
  }
  
  //println("draw method run");
  int missingFood = startFoodNumber - computerFoods.size();
  for (int i=0; i < missingFood; i++) {
    int randomX = 10*(int(random(-mapX/20, mapX/20))); // multiplied by 10 so they start at least 10 apart
    int randomY = 10*(int(random(-mapY/20, mapY/20)));
    computerFoods.add(new Food(randomX, randomY));
  }
  print(computerFoods.size());
  print(computerBalls.get(2).nearestBall);
}

PVector redrawMap(PVector location) {
  // take their position and redefine it according to the new "center" as long as its in limits
  location.x = location.x - ballPosition.x;
  location.y = location.y - ballPosition.y;
  
  return location;
}

boolean ballInBall(PVector ball1, PVector ball2, int ball1Diam, int ball2Diam) {
  //ball1 must be larger than ball2
  float ballDist = ball1.dist(ball2);
  float radiiDiff = 0.5*(ball1Diam - ball2Diam);
  boolean test = (ballDist < radiiDiff);
  return test;
}

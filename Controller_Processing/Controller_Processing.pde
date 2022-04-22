import processing.serial.*;
import java.util.Collections;
import java.util.Comparator;
Serial controller_serial_port;

int mapX = 10000;
int mapY = 10000;
PVector ballPosition = new PVector(0,0);
int startBallNumber = 75;
int backgroundColor = 153;
int startFoodNumber = 1500;

ArrayList<Ball> computerBalls = new ArrayList();// create array list with 50 balls or something
ArrayList<Food> computerFoods = new ArrayList();
Player player;

// METHOD FOR EATING //
  // 1. order balls by size.
  //2. start with smallest ball - if center is within bigger radius of bigger center then get eaten
  //3. iterate through where they only check for balls bigger than them.

void setup() {
  
  size(800,800);
  player = new Player(width/2, height/2);
  background(backgroundColor);
  for (int i=0; i < startBallNumber; i++) {
    int randomX = 10*(int(random(-mapX/20, mapX/20))); // multiplied by 10 so they start at least 10 apart
    int randomY = 10*(int(random(-mapY/20, mapY/20)));
    int randomAI = int(random(3));
    computerBalls.add(new Ball(randomAI, randomX, randomY));
    
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

  //not sure if these are correct
  PVector topRight = new PVector(mapX/2 - player.position.x + width/2, mapY/2 - player.position.y + height/2);
  PVector bottomRight = new PVector(mapX/2 - player.position.x + width/2, -mapY/2 - player.position.y + height/2);
  PVector topLeft = new PVector(-mapX/2 - player.position.x + width/2, mapY/2 - player.position.y + height/2);
  PVector bottomLeft = new PVector(-mapX/2 - player.position.x + width/2, -mapY/2 - player.position.y + height/2);
  
  //println(topLeft);
 
  //borders
  
  
  background(backgroundColor);
  line(topRight.x, topRight.y, bottomRight.x, bottomRight.y);
  line(bottomRight.x, bottomRight.y, bottomLeft.x, bottomLeft.y);
  line(bottomLeft.x, bottomLeft.y, topLeft.x, topLeft.y);
  line(topLeft.x, topLeft.y, topRight.x, topRight.y);
  //circle(400, 300, 20);
  player.run();
  //println(player.position);
  //player.position.x = mouseX; // for now.
  //player.position.y = mouseY;
  Collections.sort(computerBalls, Comparator.comparingInt(Ball::getSize)); // step 1. see below
  
  
  
  
  for (int i=0; i < computerFoods.size(); i++) {
    computerFoods.get(i).drawSelf();
    computerFoods.get(i).mappedPosition = redrawMap(computerFoods.get(i).position); // keep original position original.
    
  }
  
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
    computerBalls.get(i).mappedPosition = redrawMap(computerBalls.get(i).position);
    
    
    //eat chunk 
    for (int j=i+1; j < computerBalls.size(); j++) { // step 2. only loops through balls bigger
      // if distance between centers is less than the difference between the radii
      
      if (ballInBall(computerBalls.get(j).position, computerBalls.get(i).position, computerBalls.get(j).diameter, computerBalls.get(i).diameter)) { 
        if (computerBalls.get(i).active) {
          computerBalls.get(j).eatBall(computerBalls.get(i).diameter);
        }
        computerBalls.get(i).getEaten();
        //println(computerBalls.get(j).speedMag);
        continue ballLoop;
      }
    }
    
    // player chunk
    // 1. if player in ball.
    if (ballInBall(computerBalls.get(i).position, player.position, computerBalls.get(i).diameter, player.diameter)) {
      if (player.active) {
        computerBalls.get(i).eatBall(player.diameter);
      }
      player.getEaten();
      // GAME OVER
    } else if (ballInBall(player.position, computerBalls.get(i).position, player.diameter, computerBalls.get(i).diameter)) { // 2. ball in player
      if (computerBalls.get(i).active) {
        player.eatBall(computerBalls.get(i).diameter);
      }
      computerBalls.get(i).getEaten();
      continue ballLoop;
    }
    
    //see if over any food!
    foodLoop:
    for (int j=0; j < computerFoods.size(); j++) {
      
      // AI balls eating food
      if (ballInBall(computerBalls.get(i).position, computerFoods.get(j).position, computerBalls.get(i).diameter, computerFoods.get(j).diameter)) {
        if (computerFoods.get(j).active) {
          computerBalls.get(i).eatBall(computerFoods.get(j).diameter);
        }
        
        computerFoods.get(j).getEaten();
        computerFoods.remove(j);
 
        continue foodLoop;// maybe remove from array list too?
      }
      
      // player ball eating food
      if (ballInBall(player.position, computerFoods.get(j).position, player.diameter, computerFoods.get(j).diameter)) {
        if (computerFoods.get(j).active) {
          player.eatBall(computerFoods.get(j).diameter);
        }
        computerFoods.get(j).getEaten();
        continue foodLoop;
      }
    
    }
    
    
    //run!!!!!
    computerBalls.get(i).run();
  }
  
  
  //println("draw method run");
  int missingFood = startFoodNumber - computerFoods.size();
  for (int i=0; i < missingFood; i++) {
    int randomX = 10*(int(random(-mapX/20, mapX/20))); // multiplied by 10 so they start at least 10 apart
    int randomY = 10*(int(random(-mapY/20, mapY/20)));
    computerFoods.add(new Food(randomX, randomY));
  }
  //println(computerFoods.size());
  //println(player.position);
}

PVector redrawMap(PVector origPosition) {
  // take their position and redefine it according to the new "center" as long as its in limits
  PVector location = new PVector(0,0);
  location.x = origPosition.x - player.position.x + width/2;
  location.y = origPosition.y - player.position.y + height/2;
  
  return location;
}

boolean ballInBall(PVector ball1, PVector ball2, int ball1Diam, int ball2Diam) {
  //ball1 must be larger than ball2
  float ballDist = ball1.dist(ball2);
  float radiiDiff = 0.5*(ball1Diam - ball2Diam);
  boolean test = (ballDist < radiiDiff);
  return test;
}


// Temporary controls
void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      player.speed.x = -player.speedMag;
      player.speed.y = 0;
    } else if (keyCode == RIGHT) {
      player.speed.x = player.speedMag;
      player.speed.y = 0;
    }
  }
}

void keyReleased() {
  player.speed.x = 0;
  player.speed.y = 0;
  
}

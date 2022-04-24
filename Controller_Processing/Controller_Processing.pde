import processing.serial.*;
import java.util.Collections;
import java.util.Comparator;
Serial controller_serial_port;


// set AI 0

int mapX = 6000;
int mapY = 6000;
PVector ballPosition = new PVector(0,0);
int startBallNumber = 200;
int backgroundColor = 153;
int startFoodNumber = 1500;
boolean playing = false;
String message = "";
int timeSinceEnd = 0;

PFont f;

ArrayList<Ball> computerBalls = new ArrayList();// create array list with 50 balls or something
ArrayList<Food> computerFoods = new ArrayList();
Player player;

void setup() {
  //find_and_connect_to_usb_controller("usbserial");
  f = createFont("Arial",16,true);
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
  //controller_serial_port.clear();
}

void find_and_connect_to_usb_controller(String controller_serial_name) {
  int serial_port = -1;
  // Loop through all available usb devices
  for (int i = 0; i < Serial.list().length; i++) {
    // If the desired name is present then store the port number and stop looking
    if (Serial.list()[i].indexOf(controller_serial_name) >= 0) {
      serial_port = i;
      break;
    }
  }
  // If the named device is found then establish a connection
  if (serial_port >= 0) {
    controller_serial_port = new Serial(this, Serial.list()[serial_port], 9600);
  }
  // If the named device is not found then print an error message to console and exit the program
  else {
    println("Unable to find device named " + controller_serial_name + " in this list of available devices. Check the name of your device in the list below and adjust the code in the [setup] method.");
    printArray(Serial.list());
    exit();
  }
}

void draw() {
  //println(playing);
  if (playing) {
    run();
  } else {
    background(backgroundColor);
    if (message != "") {
      endScreen(message);
      
      
    }
    println(timeSinceEnd);
    if (millis() - timeSinceEnd > 5000) {
      exit();
    }
  }
  
}

void run() {
  
  if (player.diameter > width) {
    // YOU WIN!!!!!!!!!!
    playing = false;
    message = "You win!!!";
    timeSinceEnd = millis();
  }
  
  // corner locations
  PVector bottomRight = new PVector(mapX/2 - player.position.x + width/2, mapY/2 - player.position.y + height/2);
  PVector topRight = new PVector(mapX/2 - player.position.x + width/2, -mapY/2 - player.position.y + height/2);
  PVector bottomLeft = new PVector(-mapX/2 - player.position.x + width/2, mapY/2 - player.position.y + height/2);
  PVector topLeft = new PVector(-mapX/2 - player.position.x + width/2, -mapY/2 - player.position.y + height/2);
  

  
  background(backgroundColor);
  line(topRight.x, topRight.y, bottomRight.x, bottomRight.y);
  line(bottomRight.x, bottomRight.y, bottomLeft.x, bottomLeft.y);
  line(bottomLeft.x, bottomLeft.y, topLeft.x, topLeft.y);
  line(topLeft.x, topLeft.y, topRight.x, topRight.y);

  player.run();
  Collections.sort(computerBalls, Comparator.comparingInt(Ball::getSize)); // step 1. see below
  
  for (int i=0; i < computerFoods.size(); i++) {
    computerFoods.get(i).drawSelf();
    computerFoods.get(i).mappedPosition = redrawMap(computerFoods.get(i).position); // keep original position original.
  }
  
  // loops through balls to find the nearest one to each.
  ballLoop:
  for (int i = 0; i < computerBalls.size(); i++) {
    
    
    // set nearest ball chunk
    Ball nearestBall = new Ball(0,0,0);
    float distanceFromBall = 100000; // set as high number to start
    for (int j=0; j < computerBalls.size(); j++) {
      if ((computerBalls.get(i).position.dist(computerBalls.get(j).position) < distanceFromBall) && (i != j)) {
        nearestBall = computerBalls.get(j);
        distanceFromBall = computerBalls.get(i).position.dist(nearestBall.position);
        //print("if ran");
      }
      //println(distanceFromBall);
      //print(nearestBall);
    }
    if (computerBalls.get(i).position.dist(player.position) < distanceFromBall) {
      Ball playerBall = new Ball(0, player.position.x, player.position.y);
      playerBall.diameter = player.diameter;
      nearestBall = playerBall;
    }
   
    computerBalls.get(i).setNearestBall(nearestBall);
    
    // set user ball chunk.
    computerBalls.get(i).setUserBall(player);
    
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
      
      // end.
      
      playing = false;
      message = "You lose...";
      timeSinceEnd = millis();
      
      //endScreen("You lose...");
      break ballLoop;
      
    } else if (ballInBall(player.position, computerBalls.get(i).position, player.diameter, computerBalls.get(i).diameter)) { // 2. ball in player
      if (computerBalls.get(i).active) {
        player.eatBall(computerBalls.get(i).diameter);
      }
      computerBalls.get(i).getEaten();
      continue ballLoop;
    }
    
    // see of other ball has won
    if (computerBalls.get(i).diameter > width) {
      
      playing = false;
      message = "You lose...";
      timeSinceEnd = millis();
      break ballLoop;
      
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

void endScreen(String message) {
  
  textFont(f,30);
  text(message,30,height/2);
  
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
  if (key == ' ') {
    playing = true;
  } else if (key == CODED) {
    if (keyCode == LEFT) {
      player.speed.x = -player.speedMag;
      player.speed.y = 0;
    } else if (keyCode == RIGHT) {
      player.speed.x = player.speedMag;
      player.speed.y = 0;
    } else if (keyCode == DOWN) {
      player.speed.x = 0;
      player.speed.y = player.speedMag;
    } else if (keyCode == UP) {
      player.speed.x = 0;
      player.speed.y = -player.speedMag;
    }
  }
}

void keyReleased() {
  player.speed.x = 0;
  player.speed.y = 0;
  
}

// Listener method that triggers when a serial event occurs
void serialEvent(Serial port) {
  // Grab any incoming controller data and send it off to be processed
  handle_control_data(port.readStringUntil(']'));
  player.speed = player.speed.setMag(player.speedMag);
}

// Check for a data stream that is incomplete or out of order
// This is most likely to occur when the program first starts and picks up data mid-transmission
String scrub_data(String data) {
  if (data == null) return "";
  // Look for data that is in the format "[a,b,c,]"
  int opening_brace_index = data.lastIndexOf("[");
  int closing_brace_index = data.lastIndexOf("]");
  // If either brace is missing or out of order then abort by returning an empty string
  if (opening_brace_index < 0 || closing_brace_index < 0 || opening_brace_index > closing_brace_index) return "";
  // Only return the LAST data in that is in proper braces. In case 2 data sets are present we want to use only the newest set.
  return data.substring(opening_brace_index+1, closing_brace_index);
}

// Parse the data stream and use the values as needed
void handle_control_data(String data) {
  String scrubbed_data = scrub_data(data);
  // Ideally the processing code will run much faster than data is streaming in via usb
  // So we will only take action when data is available
  int data_index = 0;
  String data_string = "";
  int data_value = 0;
  while (scrubbed_data.length() > 1 && data_index < scrubbed_data.length()) {
    try {
      data_string = scrubbed_data.substring(0, scrubbed_data.indexOf(","));
      scrubbed_data = scrubbed_data.substring(scrubbed_data.indexOf(",")+1, scrubbed_data.length());
      data_value = Integer.parseInt(data_string);
    }
    catch (NumberFormatException ex) {
      println("WARNING: Bad Data - data is expected to be a number. Non-number data has been ignored.");
    }
    if (data_index == 0) {
      // horizontal pin
      player.speed.x = data_value;
    } else if (data_index == 1) {
      // vertical_pin
      player.speed.y = -data_value; // negative because y axes are flipped here. - i think
    } else if (data_index == 2) {
      // button
      if (data_value == 1) playing = true;
    } else if (data_index == 3) {
      // distance
      // maybe w RGB - to make it easy. if not then figure it out.
    }
    
    data_index++;
  }
}

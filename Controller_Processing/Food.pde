class Food {
  int weight;
  color foodColor;
  PVector position;
  PVector mappedPosition;
  int diameter;
  boolean active;
  
  Food(float _x, float _y) {
    position = new PVector(_x, _y);
    mappedPosition = position;
    foodColor = color(random(255), random(255), random(255));
    weight = 1;
    diameter = 10;
    active = true;
  }
  
  void drawSelf() {
    if (active) {
      fill(foodColor);
      circle(mappedPosition.x, mappedPosition.y, diameter);
    }
  }
  
  void getEaten() {
    active = false;
  }
}

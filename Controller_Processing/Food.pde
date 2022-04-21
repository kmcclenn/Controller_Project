class Food {
  int weight;
  color foodColor;
  PVector position;
  int diameter;
  boolean active;
  
  Food(float _x, float _y) {
    position = new PVector(_x, _y);
    foodColor = color(random(255), random(255), random(255));
    weight = 1;
    diameter = 10;
    active = true;
  }
  
  void drawSelf() {
    if (active) {
      fill(foodColor);
      circle(position.x, position.y, diameter);
    }
  }
  
  void getEaten() {
    active = false;
  }
}

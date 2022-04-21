class Food {
  int weight;
  color foodColor;
  PVector position;
  int diameter;
  boolean visible;
  
  Food(float _x, float _y) {
    position = new PVector(_x, _y);
    foodColor = color(random(255), random(255), random(255));
    weight = 1;
    diameter = 10;
    visible = true;
  }
  
  void drawSelf() {
    if (visible) {
      circle(position.x, position.y, diameter);
    }
  }
  
  void getEaten() {
    visible = false;
  }
}

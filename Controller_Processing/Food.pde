class Food {
  int weight;
  color foodColor;
  PVector position;
  int diameter;
  
  Food(float _x, float _y) {
    position.x = _x;
    position.y = _y;
    foodColor = color(random(255), random(255), random(255));
    weight = 1;
    diameter = 10;
  }
  
  void drawSelf() {
    circle(position.x, position.y, diameter);
  }
}

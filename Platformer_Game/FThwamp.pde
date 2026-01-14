class FThwomp extends FGameObject {
  
  
   
  int direction = L;
  int speed = 50;
  int frame = 0;
  
  FThwomp(float x, float y) {
    super();
    setPosition(x, y);
    setName("thwamp");
    setRotatable(false);
    setStatic(true);
  }
  void act() {
    animate();
    collide();    
    move();
    
    
  }
  
  void animate() {
     if (frame >= thwomp.length) frame = 0;
      if (frameCount % 5 == 0) {
      if (direction == R) attachImage(thwomp[frame]);
      if (direction == L) attachImage(reverseImage(thwomp[frame]));
      frame++;
    }
  }  
  
  void collide() {
    if(isTouching("player")) {
      if(player.getY() < getY()-gridSize/2) {
        world.remove(this);
        enemies.remove(this);
        player.setVelocity(player.getVelocityX(), -300);
      } else {
        player.lives--;
        player.setPosition(0,0);
      }
    }
  }
  void move() {
    
  }
}

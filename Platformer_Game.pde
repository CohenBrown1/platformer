import fisica.*;
FWorld world;
color white = color(255, 255, 255);
color black = color(0, 0, 0);
color green = color(34, 177, 76);
color red = color(255, 0, 0);
color blue = color(63, 72, 204);
color orange = color(255, 127, 39);
color treeTrunkBrown = color(185, 122, 87);
color cyan = color(153, 217, 234);
color grey = color(127, 127, 127);
color purple = color(163, 73, 164);
color yellow = color(100,10,100);

PImage map, ice, brick, treeTrunk, spike, spring, treeIntersect, treeMiddle, treeEndWest, treeEndEast, wall, bridge;

PImage[] idle;
PImage[] jump;
PImage[] run;
PImage[] action;
PImage[] goomba;

int gridSize = 32;
float zoom = 1;
boolean upkey, downkey, leftkey, rightkey, wkey, akey, skey, dkey, qkey, ekey, spacekey;
FPlayer player;
ArrayList<FGameObjects> terrain;
ArrayList<FGameObjects> enemies;

void setup() {
  size(600, 600);
  Fisica.init(this);
  terrain = new ArrayList<FGameObjects>();
  enemies = new ArrayList<FGameObjects>();
  loadImages();
  loadWorld(map);
  loadPlayer();
}
 
 void loadImages() {
  map = loadImage("map.png");
  brick = loadImage("brick.png");
  ice = loadImage("ice.png");
  ice.resize(32, 32);
  treeTrunk = loadImage("tree_trunk.png");
  spike = loadImage("spike.png");
  spring = loadImage("spring.png");
  treeIntersect = loadImage("tree_intersect.png");
  treeMiddle = loadImage("treetop_center.png");
  treeEndEast = loadImage("treetop_e.png");
  treeEndWest = loadImage("treetop_w.png");
  bridge = loadImage("bridge_center.png");
  wall = loadImage("brick.png");
  
  idle = new PImage[2];
  idle[0] = loadImage("idle0.png");
  idle[1] = loadImage("idle1.png");
  
  jump = new PImage[1];
  jump[0] = loadImage("jump0.png");
  
  run = new PImage[3];
  run[0] = loadImages("runright0.png");
  run[1] = loadImages("runright1.png");
  run[2] = loadImages("runright2.png");
  action = idle;
  
  goomba = new PImage [2];
  goomba[0] = loadImage("goomba0.png");
  goomba[0].resize(gridSize, gridSize);
  goomba[1] = loadImage("goomba1.png");
  goomba[1].resize(gridSize, gridSize);
 }

void loadWorld(PImage img) {
  world = new FWorld(-3000, -3000, 3000, 3000);
  world.setGravity(0, 900);

  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      color c = img.get(x, y);
      color s = img.get(x, y+1);
      color w = img.get(x-1, y);
      color e = img.get(x+1, y);
      FBox b = new FBox(gridSize, gridSize);
      b.setPosition(x*gridSize, y *gridSize);
      b.setStatic(true);
      if (c == black) {
        b.attachImage(brick);
        b.setName("stone");
        world.add(b);
      } else if (c == cyan) {
        b.setFriction(0);
        b.attachImage(ice);
        b.setName("ice");
        world.add(b);
      } else if (c == treeTrunkBrown) {
        b.attachImage(treeTrunk);
        b.setSensor(true);
        b.setName("tree trunk");
        world.add(b);
      } else if (c == grey) {
        b.attachImage(spike);
        b.setName("spike");
        world.add(b);
      } else if (c == purple) {
        b.attachImage(spring);
        b.setName("spring");
        b.setRestitution(2);
        world.add(b);
      } else if (c == green && s == treeTrunkBrown) {
        b.attachImage(treeIntersect);
        b.setName("treetop");
        world.add(b);
      } else if (c == green && w == green & e== green) {
        b.attachImage(treeMiddle);
        b.setName("treetop");
        world.add(b);
      } else if (c == green && w != green) {
        b.attachImage(treeEndWest);
        b.setName("treetop");
        world.add(b);
      } else if (c == green && e != green) {
        b.attachImage(treeEndEast);
        b.setName("treetop");
        world.add(b);
      } else if (c == pink) {
        FBridge br = new FBridge(x*gridSize, y*gridSize);
        terrain.add(br);
        world.add(br);
      } else if (c == yellow) {
        FGoomba gmb = new FGoomba(x*gridSize, y*gridSize);
        enemies.add(gmb);
        world.add(gmb);
      } else if (c == orange) {
        b.setFriction(4);
        b.setName("wall");
        world.add(b);
      }
    }
  }
}
void loadPlayer() {
  player = new FPlayer();
  world.add(player);
}

void draw() {
  background(white);
  drawWorld();
  actWorld();
  player.act();
}

void actWorld () {
  player.act();
  for (int i = 0; i < terrain.size(); i++) {
    FGameObject t = terrain.get(i);
    t.act();
  }
  for (int i = 0; i < enemies.size(); i++) {
    FGameObject e = enemies.get(i);
    e.act();
  }
}

void drawWorld() {
  pushMatrix();
  translate(-player.getX()*zoom+width/2, -player.getY()*zoom+height/2);
  scale(zoom);
  world.step();
  world.draw();
  popMatrix();
}

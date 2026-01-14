import fisica.*;
FWorld world;

final int INTRO = 0;
final int GAME = 1;
final int PAUSE = 2;

int mode;

color white = color(255, 255, 255);
color black = color(0, 0, 0);
color green = color(34, 177, 76);
color red = color(237, 28, 36);
color blue = color(63, 72, 204);
color orange = color(255, 127, 39);
color treeTrunkBrown = color(185, 122, 87);
color cyan = color(153, 217, 234);
color grey = color(127, 127, 127);
color purple = color(163, 73, 164);
color yellow = color(255,242,0);
color pink = color(255,174,201);
color banana = color(239, 228, 176);

PImage background, map, ice, brick, treeTrunk, spike, spring, treeIntersect, treeMiddle, treeEndWest, treeEndEast, wall, bridge;

PImage[] idle;
PImage[] jump;
PImage[] run;
PImage[] action;
PImage[] goomba;
PImage[] lava;
PImage[] thwomp;

int gridSize = 32;
float zoom = 1;
boolean upkey, downkey, leftkey, rightkey, wkey, akey, skey, dkey, qkey, ekey, spacekey;
FPlayer player;
ArrayList<FGameObject> terrain;
ArrayList<FGameObject> enemies;

void setup() {
  size(600, 600, P2D);
  Fisica.init(this);
  terrain = new ArrayList<FGameObject>();
  enemies = new ArrayList<FGameObject>();
  loadImages();
  loadWorld(map);
  loadPlayer();
}
 
 void loadImages() {
  background = loadImage("background.jpg");
  background.resize(600,600);
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
  run[0] = loadImage("runright0.png");
  run[1] = loadImage("runright1.png");
  run[2] = loadImage("runright2.png");
  action = idle;
  
  goomba = new PImage [2];
  goomba[0] = loadImage("goomba0.png");
  goomba[0].resize(gridSize, gridSize);
  goomba[1] = loadImage("goomba1.png");
  goomba[1].resize(gridSize, gridSize);
  
  thwomp = new PImage [2];
  thwomp[0] = loadImage("thwomp0.png");
  thwomp[1] = loadImage("thwomp1.png");
  
  lava = new PImage [6];
  lava[0] = loadImage("lava0.png");
  lava[0].resize(gridSize, gridSize);
  lava[1] = loadImage("lava1.png");
  lava[1].resize(gridSize, gridSize);
  lava[2] = loadImage("lava2.png");
  lava[2].resize(gridSize, gridSize);
  lava[3] = loadImage("lava3.png");
  lava[3].resize(gridSize, gridSize);
  lava[4] = loadImage("lava4.png");
  lava[4].resize(gridSize, gridSize);
  lava[5] = loadImage("lava5.png");
  lava[5].resize(gridSize, gridSize);
 }

void loadWorld(PImage img) {
  world = new FWorld(-10000, -10000, 10000, 10000);
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
        b.setFriction(4);
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
        b.attachImage(wall);
        b.setFriction(4);
        b.setName("wall");
        world.add(b);
      } else if (c == red) {
        FLava Lava = new FLava(x*gridSize, y*gridSize);
        terrain.add(Lava);
        world.add(Lava);
      } else if (c == banana) {
        FThwomp Thwomp = new FThwomp(x*gridSize,y*gridSize);
        terrain.add(Thwomp);
        b.setFriction(100);
        world.add(Thwomp);
      }
    }
  }
}
void loadPlayer() {
  player = new FPlayer();
  world.add(player);
}

void draw() {
  background(background);
  drawWorld();
  actWorld();
  player.act();
  modeFrameWork();
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

void modeFrameWork() {
   if (mode == INTRO) {
    intro();
  } else if (mode == GAME) {
    game();
  } else if (mode == PAUSE) {
    pause();
  }
}

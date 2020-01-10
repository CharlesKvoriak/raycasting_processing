//works 
//wasd to move, q and e to turn
class ray{
  int x, y;
  float xstop, ystop;
  float slope, rotation;
  boolean col = false;
  int walpos;
  ray(int xpos, int ypos, float r){
    x = xpos;
    y = ypos;
    rotation = r;
    slope = sin(r)/cos(r);
  }
  
  void collides(int axis, int[] p1, int[] p2){ //0 = x, 1 = y    
  slope = sin(rotation)/cos(rotation);
    if(axis == 1){
      if(slope*(p1[0]-x)+y > p1[1] && slope*(p1[0]-x)+y < p2[1] && ((cos(rotation)>0&&(x-p1[0])<0) || (cos(rotation)<0&&(x-p1[0])>0)) && sq(p1[0]-x)+sq(slope*(p1[0]-x)) < sq(ystop-y) + sq(xstop-x)){
        xstop = p1[0];
        ystop = slope*(p1[0]-x)+y;
        walpos = floor(ystop);
        col = true;
      } 
    }
    
    if(axis == 0){
      if(((p1[1]-y)/slope)+x > p1[0] && ((p1[1]-y)/slope)+x < p2[0] && ((sin(rotation)<0&&(y-p1[1])>0) || (sin(rotation)>0&&(y-p1[1])<0)) && sq(p1[1]-y)+sq(((p1[1]-y)/slope)) < sq(ystop-y) + sq(xstop-x)){
        xstop = ((p1[1]-y)/slope)+x;
        ystop = p1[1];
        walpos = floor(xstop)-p1[0];
        col = true;
      }
    }
  }
  
  int calcDist(){
    return floor(sqrt(sq(x-xstop)+sq(y-ystop)));
  }
  
  void reset(){
    xstop = 2000;
    ystop = 2000;
    col=false;
  }
}

ray[] rays = new ray[1000];
int[][][] walls = {{{0, 0}, {1000, 0}, {0}}, {{0, 0}, {0, 1000}, {1}}, {{1000, 0}, {1000, 1000}, {1}}, {{0, 1000}, {1000, 1000}, {0}}, {{400, 300}, {400, 900}, {1}}, {{200, 300}, {800, 300}, {0}}, {{900, 200}, {900, 900}, {1}}};

PImage bricks;

void setup(){
  size(1000, 1000);
  for(int i = 0; i < width; i++){
    rays[i] = new ray(100, 200, 0.00157*i);
  }
  bricks = loadImage("bricks.jpeg");
  println(300/1000.0);
  stroke(0, 0, 255);
  //noLoop();
}

void draw(){
  background(255);
  if(keyPressed){
    switch(key){
      case 'w':
        for(int i = 0; i<width; i++){
          rays[i].y += floor(sin(rays[width/2].rotation)*10);
          rays[i].x += floor(cos(rays[width/2].rotation)*10);
        }
      break;
        
      case 'a':
        for(int i = 0; i<width; i++){
          rays[i].y += floor(sin(rays[width/2].rotation-PI/2)*10);
          rays[i].x += floor(cos(rays[width/2].rotation-PI/2)*10);
        }
      break;
       
      case 's':
        for(int i = 0; i<width; i++){
          rays[i].y += floor(sin(rays[width/2].rotation+PI)*10);
          rays[i].x += floor(cos(rays[width/2].rotation+PI)*10);
        }
      break;

      case 'd':
          for(int i = 0; i<width; i++){
          rays[i].y += floor(sin(rays[width/2].rotation+PI/2)*10);
          rays[i].x += floor(cos(rays[width/2].rotation+PI/2)*10);
          }
      break;
        
      case 'q':
        for(int i = 0; i<width; i++){
          rays[i].rotation = (rays[i].rotation - 0.1 + TWO_PI)%TWO_PI;
          rays[i].slope = sin(rays[i].rotation)/cos(rays[i].rotation);
        }
        //println(sin(look.rotation)/cos(look.rotation));
      break;
        
      case 'e':
        for(int i = 0; i<width; i++){
          rays[i].rotation = (rays[i].rotation + 0.1 + TWO_PI)%TWO_PI;
          rays[i].slope = sin(rays[i].rotation)/cos(rays[i].rotation);
        }
        //println(sin(look.rotation)/cos(look.rotation));
      break;
    }
  }
  
  boolean col1;
  boolean col2;
  
  loadPixels();
  bricks.loadPixels();
  for(int i = 0; i<width; i++){
    for(int j = 0; j < walls.length; j++){
      rays[i].collides(walls[j][2][0], walls[j][0], walls[j][1]);
    }
    
    if(rays[i].col){
      for(int j= 0; j< height; j++){
        if(j > abs(height/2 - (10000/rays[i].calcDist())) && j < height/2 + (10000/(rays[i].calcDist()))){
          pixels[j*width+i] = color(0, 0, 255/(rays[i].calcDist()/100.0));   
        }
      }
      //line(i, 500-10000/(rays[i].calcDist()), i, 500+10000/(rays[i].calcDist()));
    }
    rays[i].reset();
  }
  updatePixels();
}
float r;
float g;
float b;
int x = 0;
int speed = 2;
int y = 0;

void setup(){
  size(500,500);
  smooth();
  }
  
void draw(){
  r = random(255);
  g = random(255);
  b = random(255);
  background(255);
 
 
 x = x + speed; //add speed to x location for movement
 if ((x > width) || (x < 0)){
 speed = speed * (-1); // if reaches edge, will turn around
 }
  
 stroke(0);
 ellipse(100,x,100,100);
 
  
  y = y + (speed); //add speed to x location for movement
 if ((y > width) || (y < 0)){
 speed = speed * (-1); // if reaches edge, will turn around
 }
 stroke(0);
 ellipse(x,y,50,50);
 
 }

void mousePressed(){
  
  fill(r,g,b);
  
}
float r;
float g;
float b;

void setup(){
  size(500,500);
  background(255);
  }
  
void draw(){
  r = random(255);
  g = random(255);
  b = random(255);
  
  rect(250,250,100,100);
  
 }

void mousePressed(){
  
  if(mouseX >= 250 && mouseX <= 350 && mouseY >= 250 && mouseY <= 350) {
  fill(r,g,b);
  }
}
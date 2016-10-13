PGraphics bg;
boolean isFirst = false;
boolean isSecond = false;
boolean isThird = false;

void setup() {
  size(1000, 1000);
  bg = createGraphics(width, height);
}

void draw() {
  if (!isFirst) {
    fill(0);
  } else {
    fill(100);
  }
  ellipse(100, 100, 100, 100);
  if (!isSecond) {
    fill(100);
  } else {
    fill(0);
  }
  ellipse(200, 200, 100, 100);
  if (!isThird) {
    fill(255);
  } else {
    fill(0);
  }
  ellipse(300, 300, 100, 100);
  bg.beginDraw();
  bg.background(2);
  bg.fill(0);
  bg.ellipse(100, 100, 100, 100);
  bg.fill(100);
  bg.ellipse(200, 200, 100, 100);
  bg.fill(200);
  bg.ellipse(300, 300, 100, 100);
  bg.endDraw();
}

void mouseMoved() {
  int c = bg.get(mouseX, mouseY);
  if (red(c) == 0) {
    isFirst = true;
    isSecond = false;
    isThird = false;
  } else if (red(c) == 100) {
    isSecond = true;
    isFirst = false;
    isThird = false;
  } else if (red(c) == 200) {
    isThird = true;
    isFirst = false;
    isSecond = false;
  } else {
    isFirst = false;
    isSecond = false;
    isThird = false;
  }
}
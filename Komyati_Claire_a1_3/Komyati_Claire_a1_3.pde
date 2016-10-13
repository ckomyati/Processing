
boolean barGraphButton = true;

// create array for data
int[] prices; 
String[] names;

//for hover factor
int barX, barY; //position of bars
int barSize; //diameter of rect
boolean barOver = false;

void setup() {
  size(600, 500);
  smooth();
  surface.setResizable(true);

  //barX = 
  //barY = 
  // load data from csv file
  String[] data = loadStrings("data_barAndLine.csv");

  //use number of columns to set length
  prices = new int[data.length];
  names = new String[data.length];
  for (int i=0; i<data.length; i++) {
    //split into 2 strings
    String[] price = splitTokens(data[i], ",");
    // put 2nd string into int array
    prices[i] = int(price[1]);
    names[i] = price[0];
  }
}

void draw() {
  background(255);
  fill(0, 0, 0);

  if (barGraphButton) {

    //drawBarGraph() {
    //set bar width according to # of rows of data
    float w = (float) ((width/prices.length)*.95);

    //set height of bars
    for (int i=1; i<prices.length; i++) {
      //hover and show info
      float h = prices[i];
      float x = (i*w)+w/2.9;
      float y = .85*height - (h+40);

      

      if ( overBar( x, y, w*.85, h ) ) {
        pushMatrix();
        String str = names[i] + ", " + prices[i];
        translate( x + str.length(), y - 30 );
        textSize(12);
        textAlign( LEFT, BOTTOM );
        rotate(radians(-70));
        fill(0, 179, 179);
        text( str, 0, 0 );
        popMatrix();
      }
      //draw the bar
     
      rect(x, y, w*.85, h);
      fill(0,0,0);
    }


    //draw labels on x axis for names
    for (int i = 1; i < names.length; ++i) {
      String l = names[i];
      //text (l, (i*w)+w/2.9,.95*height); //write the label
      pushMatrix(); //start the pushpop process
      translate( ((i*w)+w/2.9) + 15, height*.86);
      rotate(radians(-90));
      textAlign( CENTER, BOTTOM );
      textSize(10);
      text(l, 0, 0);
      popMatrix(); //end pushpop process
    }

    // Title Text
    textSize(24);
    textAlign(CENTER);
    fill(0);
    text("Price of Fruits", width/2, height/6);
    //draw the axes line (x1, y1, x2, y2) that change with size
    line(width/prices.length, height/prices.length, width/prices.length, (height*prices.length)*.05); //yaxis
    line(width/prices.length, .84*height - 20, (width*prices.length)*.08, .84*height - 20); //xaxis
    // labels the axes, x first y second
    fill(0, 0, 0);
    textSize(15);
    text("item", width*.5, height*.97); 
    pushMatrix();
    //move the origin to the pivot point
    translate(width*.05, height*.5);
    //pivot the grid
    rotate(radians(-90));
    //draw again at origin
    fill(0, 0, 0);
    textSize(15); 
    text("price($)", 0, 0);
    popMatrix();

    //create Toggle Button to display bar or line graph
    color C1 = color(204, 255, 255);

    if (barGraphButton) {
      fill(C1);
      rect(width*.8, height/25, 100, 25);

      //text during bar graph view
      textSize(10);
      fill(0);
      text("switch to line view", width*.8+50, height/25+13);
    } else {
      fill(C1);
      rect(width*.8, height/25, 100, 25);
      textSize(10);
      text("switch to bar view", width*.8+50, height/25+13);
    }
  } else if (!barGraphButton) {

    strokeWeight(.5);
    smooth();

    //set bar width according to # of rows of data
    float w = (float) ((width/prices.length)*.95);

    //set height of bars
    for (int i=1; i<prices.length; i++) {
      //hover and show info
      float h = prices[i];
      float x = (i*w)+w/2.9;
      float y = .85*height - (h+40);


      if ( overBar( x, y, w*.85, h ) ) {
        pushMatrix();
        String str = names[i] + ", " + prices[i];
        translate( x + str.length(), y - 30 );
        textSize(12);
        textAlign( LEFT, BOTTOM );
        rotate(radians(-70));
        text( str, 0, 0 );
        popMatrix();
      }
      //draw the point
      ellipse(x+15, y, 5, 5);
    }
    {
      //hover and show info
      for (int i=1; i<prices.length-1; i++) {
        float h = prices[i];
        float x = (i*w)+w/2.9;
        float y = .85*height - (h+40);
        float h1 = prices[i+1];
        float x1 =  ((i+1)*w)+w/2.9;
        float y1 = .85*height - (h1+40);
        //draw the line
        line(x+15, y, x1 + 15, y1);
      }
    }



    //draw labels on x axis for names
    for (int i = 1; i < names.length; ++i) {
      String l = names[i];
      pushMatrix(); //start the pushpop process
      translate( ((i*w)+w/2.9) + 15, height*.86);
      rotate(radians(-90));
      textAlign( CENTER, BOTTOM );
      textSize(10);
      text(l, 0, 0);
      popMatrix(); //end pushpop process
    }

    //create Toggle Button to display bar or line graph
    color C1 = color(204, 255, 255);
    color C2 = color(0, 0, 0);
    if (barGraphButton) {
      fill(C1);
      rect(width*.8, height/25, 100, 25);

      //text during bar graph view
      textSize(10);
      fill(0);
      text("switch to line view", width*.8+50, height/25+13);
    } else {
      fill(C1);
      rect(width*.8, height/25, 100, 25);
      textSize(10);
      fill(C2);
      text("switch to bar view", width*.8+50, height/25+13);
    }

    // Title Text
    textSize(24);
    textAlign(CENTER);
    fill(0);
    text("Price of Fruits", width/2, height/6);
    //draw the axes line (x1, y1, x2, y2) that change with size
    line(width/prices.length, height/prices.length, width/prices.length, (height*prices.length)*.05); //yaxis
    line(width/prices.length, .85*height - 25, (width*prices.length)*.08, .85*height - 25); //xaxis
    // labels the axes, x first y second
    fill(0, 0, 0);
    textSize(15);
    text("item", width*.5, height*.97); 
    pushMatrix();
    //move the origin to the pivot point
    translate(width*.05, height*.5);
    //pivot the grid
    rotate(radians(-90));
    //draw again at origin
    fill(0, 0, 0);
    textSize(15); 
    text("price($)", 0, 0);
    popMatrix();
  }
}


void mouseClicked() {
  // click from Bar graph to Line graph
  if (barGraphButton) {
    if (mouseX > width*.8 && mouseX < (width*.8)+100 && mouseY > height/25 && mouseY < height/25+25) {
      barGraphButton = false;
    }
  } else {
    // Click from Line graph to Bar graph
    if (mouseX > width*.8 && mouseX < (width*.8)+100 && mouseY > height/25 && mouseY < height/25+25) {
      barGraphButton = true;
    }
  }
}

boolean overBar(float x, float y, float width, float height) {
  if (mouseX >= x && mouseX <= x+width && mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}
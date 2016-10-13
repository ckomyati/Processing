/*
acknowledgement - 
 I referenced code from this person's project on parallel coordinates:
 http://visthis.blogspot.com/2012/10/assignment-3-parallel-coordinates.html
 in order to make the framework of the axes/lines/read in the data
 */


FloatTable data;


//set up variables
int xmin = 25; 
int xmax = 975; 

int ymin = 25; 
int ymax = 575; 


int colPad = 15; 

int numCols; 
int numSamples;
int selectedCol; 
int newCol; 
float linespace;
float newFilterVal; 
float clickVal; 
float minDiff; 
float maxDiff; 
int kval = 3; 
int kidx = 1; 
int clusterOn = 0; 

float[] filterMin; 
float[] filterMax; 

int[] colInvert; 
int[] colIdx; 
int[] colIdxNew; 

PFont labelFont;
PFont numberFont; 
PFont titleFont; 


void setup() {
  size(1000, 600);
  surface.setResizable(true);

  //set up data from planets 
  data = new FloatTable("planets.txt"); 

  numCols = data.getColumnCount(); 
  numSamples = data.getRowCount();
  colInvert = new int[numCols];
  for (int idx = 0; idx < numCols; idx++) {
    colInvert[idx] = 0;
  }

  filterMin = new float[numCols]; 
  filterMax = new float[numCols];

  for (int col = 0; col < numCols; col++) {
    filterMin[col] = data.getColumnMin(col); 
    filterMax[col] = data.getColumnMax(col);
  }

  colIdxNew = new int[numCols]; 
  colIdx = new int[numCols];
  for (int idx = 0; idx < numCols; idx++) {
    colIdx[idx] = idx;
  }
}

void draw() {
  background(255); 

  numCols = data.getColumnCount(); 
  numSamples = data.getRowCount();  
  linespace = floor(800/numCols);



  stroke(0); 
  strokeWeight(1); 

  //black line axes
  for (int col = 0; col < numCols; col++) {
    //line((col*linespace)+xmin+10, ymin+10, (col*linespace)+xmin+10, ymax-10); //not resizeable
    line((col*linespace)+(width*.035), (height*.07), (col*linespace)+(width*.035), (height*.93));//resizable
  }

  drawTitle();
  drawAxisLabels();
  drawLines();
  drawFilterBoxes();
}

void drawTitle() {
  titleFont = createFont("Veranda", 12); 

  textFont(titleFont);
  fill(0); 
  textAlign(CENTER, CENTER); 
  text("Planets as \n Parallel \n Coordinates", .85*width, .3*height);
}


void drawAxisLabels() {

  fill(0); 
  textSize(10); 

  labelFont = createFont("Veranda", 10); 
  numberFont = createFont("Veranda", 8); 

  for (int col = 0; col < numCols; col++) { 
    String label = data.getColumnName(colIdx[col]);  

    textFont(labelFont);
    textAlign(CENTER, CENTER); 
    text(label, (col*linespace)+(width*.02), height*.97); //labels for axes 

    float colMin = data.getColumnMin(colIdx[col]); 
    float colMax = data.getColumnMax(colIdx[col]); 

    textFont(numberFont); 
    textAlign(CENTER, CENTER); 

    if (colInvert[colIdx[col]] == 0) {      //this inverts the columns, need to resize here
      //text(colMin, (col*linespace)+xmin+10, ymax-5); //not resizeable
      //text(colMax, (col*linespace)+xmin+10, ymin+5);
      text(colMin, (col*linespace)+(width*.02), (height*.03)); //resizeable
      text(colMax, (col*linespace)+(width*.02), (height*.97));
    } else if (colInvert[colIdx[col]] == 1) {
      //text(colMax, (col*linespace)+xmin+10, ymax-5);//not resizeable
      //text(colMin, (col*linespace)+xmin+10, ymin+5);
      text(colMax, (col*linespace)+(width*.02), (height*.03));//resizeable
      text(colMin, (col*linespace)+(width*.02), (height*.97));
    }
  }
}

void drawLines() {


  //decides if in filter box or not 
  for (int sample = 0; sample < numSamples; sample++) {
    int inFilter = 1; 
    for (int col = 0; col < numCols; col++) {
      float dataVal = data.getFloat(sample, colIdx[col]); 
      if (dataVal > filterMax[colIdx[col]] || dataVal < filterMin[colIdx[col]]) {
        inFilter = 0;
      }
    }


    if (inFilter == 1) {
      stroke(130, 0, 200, 300); //color,opacity
      strokeWeight(0.5);
      noFill(); 
      beginShape(); 
      for (int col = 0; col < numCols; col++) {
        float colMin = data.getColumnMin(colIdx[col]); 
        float colMax = data.getColumnMax(colIdx[col]); 
        float value = data.getFloat(sample, colIdx[col]);

        //draws the purple lines & swithes them if inverted 
        if (colInvert[colIdx[col]] == 0) {
          //float y = map(value, colMin, colMax, ymax-15, ymin+15); //not resizable
          //vertex((col*linespace)+xmin+10, y);
          float y = map(value, colMin, colMax, (height*.1), (height*.9)); //resizable
          vertex((col*linespace)+(height*.05), y);
        } else if (colInvert[colIdx[col]] == 1) {
          //float y = map(value, colMax, colMin, ymax-15, ymin+15);  //not resizable
          //vertex((col*linespace)+xmin+10, y);
          float y = map(value, colMax, colMin, (height*.1), (height*.9));  //resizable
          vertex((col*linespace)+(height*.1), y);
        }
      }
      endShape();
    } else if (inFilter == 0) {
      stroke(0, 0, 0, 40); 
      strokeWeight(0.5);
      noFill(); 
      beginShape(); 
      for (int col = 0; col < numCols; col++) {
        float colMin = data.getColumnMin(colIdx[col]); 
        float colMax = data.getColumnMax(colIdx[col]); 
        float value = data.getFloat(sample, colIdx[col]);

        if (colInvert[colIdx[col]] == 0) {
          float y = map(value, colMin, colMax, ymax-15, ymin+15);
          vertex((col*linespace)+xmin+10, y);
        } else if (colInvert[colIdx[col]] == 1) {
          float y = map(value, colMax, colMin, ymax-15, ymin+15); 
          vertex((col*linespace)+xmin+10, y);
        }
      }
      endShape();
    }
  }
}

void mousePressed() {
  if (mouseY > ymax && mouseY < 600) {
    for (int col = 0; col < numCols; col++) {
      if (mouseX >= (col*linespace)+xmin+10-(linespace/3) && mouseX <= (col*linespace)+xmin+10+(linespace/3)) {
        if (colInvert[colIdx[col]] == 0) {
          colInvert[colIdx[col]] = 1;
        } else if (colInvert[colIdx[col]] == 1) {
          colInvert[colIdx[col]] = 0;
        }
      }
    }
  }
  if (mouseY > ymin+10 && mouseY < ymax-20) {
    clickVal = mouseY; 
    for (int col = 0; col < numCols; col++) {
      if (mouseX > (col*linespace)+xmin+10-colPad && mouseX < (col*linespace)+xmin+10+colPad) {
        selectedCol = col;
      }
    }
  }
}


void mouseReleased() {
  if (mouseY > ymin+10 && mouseY < ymax-20) {
    for (int col = 0; col < numCols; col++) { 
      if (mouseX > (col*linespace)+xmin+10-colPad && mouseX < (col*linespace)+xmin+10+colPad) {
        newCol = col;

        if (newCol != selectedCol) {
          updateColIdx();
        } else if (newCol == selectedCol) {
          newFilterVal = mouseY; 
          updateFilterVals();
        }
      }
    }
  }
}

void updateColIdx() {

  if (newCol > selectedCol) {
    for (int col = 0; col < numCols; col++) {
      if (col == newCol) {
        colIdxNew[col] = colIdx[selectedCol];
      } else if (col < selectedCol) {
        colIdxNew[col] = colIdx[col];
      } else if (selectedCol <= col && newCol > col) {
        colIdxNew[col] = colIdx[col+1];
      } else if (col > newCol) {
        colIdxNew[col] = colIdx[col];
      }
    }
  } else if (newCol < selectedCol) {
    for (int col = 0; col < numCols; col++) {
      if (col == newCol) {
        colIdxNew[col] = colIdx[selectedCol];
      } else if (col < newCol) {
        colIdxNew[col] = colIdx[col];
      } else if (newCol < col && selectedCol >= col) {
        colIdxNew[col] = colIdx[col-1];
      } else if (col > selectedCol) {
        colIdxNew[col] = colIdx[col];
      }
    }
  }

  for (int idx = 0; idx < numCols; idx++) {
    colIdx[idx] = colIdxNew[idx];
  }
}

void drawFilterBoxes() {
  rectMode(CORNERS); 
  fill(0, 0, 0, 75); 
  noStroke();
  for (int col = 0; col < numCols; col++) {
    if (colInvert[colIdx[col]] == 0) {
      float colMin = data.getColumnMin(colIdx[col]); 
      float colMax = data.getColumnMax(colIdx[col]); 
      float y1 = map(filterMax[colIdx[col]], colMin, colMax, ymax-15, ymin+15); 
      float y2 = map(filterMin[colIdx[col]], colMin, colMax, ymax-15, ymin+15);   
      rect((col*linespace)+xmin+5, y1, (col*linespace)+xmin+15, y2);
    } else if (colInvert[colIdx[col]] == 1) {
      float colMin = data.getColumnMin(colIdx[col]); 
      float colMax = data.getColumnMax(colIdx[col]);   
      float y1 = map(filterMax[colIdx[col]], colMax, colMin, ymax-15, ymin+15); 
      float y2 = map(filterMin[colIdx[col]], colMax, colMin, ymax-15, ymin+15);   
      rect((col*linespace)+xmin+5, y2, (col*linespace)+xmin+15, y1);
    }
  }
}

void updateFilterVals() {
  if (colInvert[colIdx[selectedCol]] == 0) {
    float currentMax = filterMax[colIdx[selectedCol]]; 
    float currentMin = filterMin[colIdx[selectedCol]]; 

    float colMin = data.getColumnMin(colIdx[selectedCol]); 
    float colMax = data.getColumnMax(colIdx[selectedCol]);   
    float clickValScale = map(clickVal, ymax-15, ymin+15, colMin, colMax);

    maxDiff = abs(clickValScale-currentMax); 
    minDiff = abs(clickValScale-currentMin);
  } else if (colInvert[colIdx[selectedCol]] == 1) {
    float currentMax = filterMax[colIdx[selectedCol]]; 
    float currentMin = filterMin[colIdx[selectedCol]]; 

    float colMin = data.getColumnMin(colIdx[selectedCol]); 
    float colMax = data.getColumnMax(colIdx[selectedCol]);   
    float clickValScale = map(clickVal, ymax-15, ymin+15, colMax, colMin);

    maxDiff = abs(currentMax-clickValScale); 
    minDiff = abs(currentMin-clickValScale);
  }

  if (minDiff < maxDiff) {
    if (colInvert[colIdx[selectedCol]] == 0) {
      float colMin = data.getColumnMin(colIdx[selectedCol]); 
      float colMax = data.getColumnMax(colIdx[selectedCol]);   
      float yVal = map(newFilterVal, ymax-15, ymin+15, colMin, colMax);
      filterMin[colIdx[selectedCol]] = yVal;
    } else if (colInvert[colIdx[selectedCol]] == 1) {
      float colMin = data.getColumnMin(colIdx[selectedCol]); 
      float colMax = data.getColumnMax(colIdx[selectedCol]);   
      float yVal = map(newFilterVal, ymax-15, ymin+15, colMax, colMin);
      filterMin[colIdx[selectedCol]] = yVal;
    }
  } else if (minDiff > maxDiff) {
    if (colInvert[colIdx[selectedCol]] == 0) {
      float colMin = data.getColumnMin(colIdx[selectedCol]); 
      float colMax = data.getColumnMax(colIdx[selectedCol]);   
      float yVal = map(newFilterVal, ymax-15, ymin+15, colMin, colMax);
      filterMax[colIdx[selectedCol]] = yVal;
    } else if (colInvert[colIdx[selectedCol]] == 1) {
      float colMin = data.getColumnMin(colIdx[selectedCol]); 
      float colMax = data.getColumnMax(colIdx[selectedCol]);   
      float yVal = map(newFilterVal, ymax-15, ymin+15, colMax, colMin);
      filterMax[colIdx[selectedCol]] = yVal;
    }
  }
}
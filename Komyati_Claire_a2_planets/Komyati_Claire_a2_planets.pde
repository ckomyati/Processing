
FloatTable data;
FloatTable clusters; 
FloatTable clusterStats; 

int xmin = 25; 
int xmax = 975; 

int ymin = 25; 
int ymax = 575; 

int menuPad = 150; 
int colPad = 15; 

int a = 127; 

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

int[] clustColorR = new int[10]; 
int[] clustColorG = new int[10]; 
int[] clustColorB = new int[10]; 

PFont labelFont;
PFont numberFont; 
PFont titleFont; 


void setup() {
  size(1000, 600);

  data = new FloatTable("Cars.txt"); 
  clusters = new FloatTable("Cluster.txt"); 
  clusterStats = new FloatTable("carsClusterStats.txt"); 
  
  numCols = data.getColumnCount(); 
  numSamples = data.getRowCount();
  colInvert = new int[numCols];
  for (int idx = 0; idx < numCols; idx++) {
      colInvert[idx] = 0;
  }
  
  filterMin = new float[numCols]; 
  filterMax = new float[numCols];
  
  for(int col = 0; col < numCols; col++) {
   filterMin[col] = data.getColumnMin(col); 
   filterMax[col] = data.getColumnMax(col);   
  }
  
  colIdxNew = new int[numCols]; 
  colIdx = new int[numCols];
  for(int idx = 0; idx < numCols; idx++) {
     colIdx[idx] = idx;  
  }
  
  clustColorR[0] = 204;
  clustColorG[0] = 0;
  clustColorB[0] = 0;
  
    clustColorR[4] = 255;
  clustColorG[4] = 128;
  clustColorB[4] = 0;
  
    clustColorR[8] = 204;
  clustColorG[8] = 204;
  clustColorB[8] = 0;
  
    clustColorR[1] = 0;
  clustColorG[1] = 153;
  clustColorB[1] = 0;
  
    clustColorR[7] = 0;
  clustColorG[7] = 204;
  clustColorB[7] = 0;
  
    clustColorR[2] = 0;
  clustColorG[2] = 0;
  clustColorB[2] = 153;
  
    clustColorR[6] = 102;
  clustColorG[6] = 0;
  clustColorB[6] = 204;
  
    clustColorR[5] = 0;
  clustColorG[5] = 204;
  clustColorB[5] = 102;
  
    clustColorR[3] = 153;
  clustColorG[3] = 0;
  clustColorB[3] = 153;
  
    clustColorR[9] = 204;
  clustColorG[9] = 0;
  clustColorB[9] = 102;
  
}

void draw() {
  background(255); 

  numCols = data.getColumnCount(); 
  numSamples = data.getRowCount();  
  linespace = floor(800/numCols);
  

  
  stroke(0); 
  strokeWeight(1); 

  for (int col = 0; col < numCols; col++) {
    line((col*linespace)+xmin+10, ymin+10, (col*linespace)+xmin+10, ymax-10);
  }

  drawTitle();
  drawAxisLabels();
  drawLines();
  drawFilterBoxes();
 drawClusterInfo();  
  
  if(clusterOn == 1) {
   drawClusterMeans();  
  }
 
  if(keyPressed) {
  if(key == 'c') {
   if(clusterOn == 0) {
     clusterOn = 1;
   } else if(clusterOn == 1) {
     clusterOn = 0; 
   }
  }
 
 if(key == 'k') {
  if(kval == 3) {
   kval = 5; 
   kidx = 2;  
  } else if(kval == 5) {
    kval = 10; 
    kidx = 3; 
  } else if(kval == 10) {
    kval = 3; 
    kidx = 1; 
  }
 } 
   
 }
 
}

void drawTitle() {
  titleFont = createFont("Veranda", 16); 

  textFont(titleFont);
  fill(0); 
  textAlign(CENTER, CENTER); 
  text("Parallel Coordinates Tool\nCars Dataset", 855, ymin+50);
}

void drawClusterInfo() {
  titleFont = createFont("Veranda", 12); 

  textFont(titleFont);
  
  if(clusterOn == 1) {
  fill(0); 
  textAlign(LEFT); 
  text("Cluster Mode | ON", 800, ymin+170);
  } else if(clusterOn == 0) {
    fill(0,0,0,150); 
  textAlign(LEFT); 
  text("Cluster Mode | OFF", 800, ymin+170);
}

fill(0); 
textAlign(LEFT);
text("Num Clusters |", 800, ymin+200); 

if(kval == 3) {
 fill(0); 
textAlign(LEFT); 
text("3", 890, ymin+200); 
} else if(kval!= 3) {
  fill(0,0,0,150); 
textAlign(LEFT); 
text("3", 890, ymin+200);
}

if(kval == 5) {
 fill(0); 
textAlign(LEFT); 
text("5", 910, ymin+200); 
} else if(kval!= 5) {
  fill(0,0,0,150); 
textAlign(LEFT); 
text("5", 910, ymin+200);
}

if(kval == 10) {
 fill(0); 
textAlign(LEFT); 
text("10", 930, ymin+200); 
} else if(kval!= 10) {
  fill(0,0,0,150); 
textAlign(LEFT); 
text("10", 930, ymin+200);
}


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
    text(label, (col*linespace)+xmin+10, ymax+10); 

     float colMin = data.getColumnMin(colIdx[col]); 
     float colMax = data.getColumnMax(colIdx[col]); 
     
     textFont(numberFont); 
     textAlign(CENTER, CENTER); 
     
     if(colInvert[colIdx[col]] == 0) {
     text(colMin, (col*linespace)+xmin+10, ymax-5);
     text(colMax, (col*linespace)+xmin+10, ymin+5); 
     } else if(colInvert[colIdx[col]] == 1) {
       text(colMax, (col*linespace)+xmin+10, ymax-5);
       text(colMin, (col*linespace)+xmin+10, ymin+5);
     }
  }
}

void drawLines() {

  if(clusterOn == 0) {
  
  for (int sample = 0; sample < numSamples; sample++) {
    int inFilter = 1; 
    for(int col = 0; col < numCols; col++) {
      float dataVal = data.getFloat(sample,colIdx[col]); 
      if(dataVal > filterMax[colIdx[col]] || dataVal < filterMin[colIdx[col]]){
       inFilter = 0;  
      }
      
    }
    
    if(inFilter == 1) {
    stroke(255, 0, 0, a); 
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
      } 
      else if (colInvert[colIdx[col]] == 1) {
        float y = map(value, colMax, colMin, ymax-15, ymin+15); 
        vertex((col*linespace)+xmin+10, y);
      }
    }
    endShape();
  } else if(inFilter == 0) {
    stroke(0, 0, 0, 20); 
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
      } 
      else if (colInvert[colIdx[col]] == 1) {
        float y = map(value, colMax, colMin, ymax-15, ymin+15); 
        vertex((col*linespace)+xmin+10, y);
      }
    }
    endShape();
    
  }
}
  } else if(clusterOn == 1) {
  
  for (int sample = 0; sample < numSamples; sample++) {
    if(kval == 3) {
      kidx = 1; 
    } else if(kval == 5) {
      kidx = 2; 
    } else if(kval == 10) {
      kidx = 3; 
    }
    
    float sampleClustF = clusters.getFloat(sample,kidx-1);
    int sampleClust = (int) sampleClustF;
    
    int inFilter = 1; 
    for(int col = 0; col < numCols; col++) {
      float dataVal = data.getFloat(sample,colIdx[col]); 
      if(dataVal > filterMax[colIdx[col]] || dataVal < filterMin[colIdx[col]]){
       inFilter = 0;  
      }
      
    }
    
    if(inFilter == 1) {
    stroke(clustColorR[sampleClust-1], clustColorG[sampleClust-1], clustColorB[sampleClust-1], a); 
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
      } 
      else if (colInvert[colIdx[col]] == 1) {
        float y = map(value, colMax, colMin, ymax-15, ymin+15); 
        vertex((col*linespace)+xmin+10, y);
      }
    }
    endShape();
  } else if(inFilter == 0) {
    stroke(0, 0, 0, 20); 
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
      } 
      else if (colInvert[colIdx[col]] == 1) {
        float y = map(value, colMax, colMin, ymax-15, ymin+15); 
        vertex((col*linespace)+xmin+10, y);
      }
    }
    endShape();
    
  }
}
  }
}

void mousePressed() {
 if(mouseY > ymax && mouseY < 600) {
   for(int col = 0; col < numCols; col++) {
     if(mouseX >= (col*linespace)+xmin+10-(linespace/3) && mouseX <= (col*linespace)+xmin+10+(linespace/3)) {
       if(colInvert[colIdx[col]] == 0) {
          colInvert[colIdx[col]] = 1; 
      } else if(colInvert[colIdx[col]] == 1) {
          colInvert[colIdx[col]] = 0; 
        }
 }
   }
 }
 if(mouseY > ymin+10 && mouseY < ymax-20) {
   clickVal = mouseY; 
   for(int col = 0; col < numCols; col++) {
     if(mouseX > (col*linespace)+xmin+10-colPad && mouseX < (col*linespace)+xmin+10+colPad) {
      selectedCol = col; 
     }
   }
 }
 
 }
 

void mouseReleased() {
 if(mouseY > ymin+10 && mouseY < ymax-20) {
  for(int col = 0; col < numCols; col++) { 
   if(mouseX > (col*linespace)+xmin+10-colPad && mouseX < (col*linespace)+xmin+10+colPad) {
    newCol = col;
    
    if(newCol != selectedCol) {
    updateColIdx();   
    } else if(newCol == selectedCol) {
      newFilterVal = mouseY; 
      updateFilterVals(); 
    }
   }
 }
}
}

void updateColIdx() {
 
  if(newCol > selectedCol) {
  for(int col = 0; col < numCols; col++) {
  if(col == newCol) {
    colIdxNew[col] = colIdx[selectedCol]; 
  } else if(col < selectedCol) {
    colIdxNew[col] = colIdx[col];
  } else if(selectedCol <= col && newCol > col) {
    colIdxNew[col] = colIdx[col+1]; 
  } else if(col > newCol) {
    colIdxNew[col] = colIdx[col]; 
  }
 } 
 }

 else if(newCol < selectedCol) {
   for(int col = 0; col < numCols; col++) {
     if(col == newCol) {
    colIdxNew[col] = colIdx[selectedCol]; 
  } else if(col < newCol) {
    colIdxNew[col] = colIdx[col];
  } else if(newCol < col && selectedCol >= col) {
    colIdxNew[col] = colIdx[col-1]; 
  } else if(col > selectedCol) {
    colIdxNew[col] = colIdx[col]; 
  }
   }
   
 }
 
 for(int idx = 0; idx < numCols; idx++) {
   colIdx[idx] = colIdxNew[idx]; 
 }

}

void drawFilterBoxes() {
 rectMode(CORNERS); 
 fill(0,0,0,75); 
 noStroke();
 for(int col = 0; col < numCols; col++) {
   if(colInvert[colIdx[col]] == 0) {
     float colMin = data.getColumnMin(colIdx[col]); 
     float colMax = data.getColumnMax(colIdx[col]); 
     float y1 = map(filterMax[colIdx[col]], colMin, colMax, ymax-15, ymin+15); 
     float y2 = map(filterMin[colIdx[col]], colMin, colMax, ymax-15, ymin+15);   
     rect((col*linespace)+xmin+5, y1, (col*linespace)+xmin+15, y2); 
  
 } else if(colInvert[colIdx[col]] == 1) {
     float colMin = data.getColumnMin(colIdx[col]); 
     float colMax = data.getColumnMax(colIdx[col]);   
     float y1 = map(filterMax[colIdx[col]], colMax, colMin, ymax-15, ymin+15); 
     float y2 = map(filterMin[colIdx[col]], colMax, colMin, ymax-15, ymin+15);   
     rect((col*linespace)+xmin+5, y2, (col*linespace)+xmin+15, y1);
 } 
}
}

void updateFilterVals() {
if(colInvert[colIdx[selectedCol]] == 0) {
float currentMax = filterMax[colIdx[selectedCol]]; 
float currentMin = filterMin[colIdx[selectedCol]]; 

float colMin = data.getColumnMin(colIdx[selectedCol]); 
float colMax = data.getColumnMax(colIdx[selectedCol]);   
float clickValScale = map(clickVal, ymax-15, ymin+15, colMin, colMax);
     
maxDiff = abs(clickValScale-currentMax); 
minDiff = abs(clickValScale-currentMin); 

} else if(colInvert[colIdx[selectedCol]] == 1) {
  float currentMax = filterMax[colIdx[selectedCol]]; 
float currentMin = filterMin[colIdx[selectedCol]]; 

float colMin = data.getColumnMin(colIdx[selectedCol]); 
float colMax = data.getColumnMax(colIdx[selectedCol]);   
float clickValScale = map(clickVal, ymax-15, ymin+15, colMax, colMin);
     
maxDiff = abs(currentMax-clickValScale); 
minDiff = abs(currentMin-clickValScale); 
}

if(minDiff < maxDiff) {
  if(colInvert[colIdx[selectedCol]] == 0) {
     float colMin = data.getColumnMin(colIdx[selectedCol]); 
     float colMax = data.getColumnMax(colIdx[selectedCol]);   
     float yVal = map(newFilterVal, ymax-15, ymin+15, colMin, colMax);
     filterMin[colIdx[selectedCol]] = yVal;
  } else if(colInvert[colIdx[selectedCol]] == 1) {
     float colMin = data.getColumnMin(colIdx[selectedCol]); 
     float colMax = data.getColumnMax(colIdx[selectedCol]);   
     float yVal = map(newFilterVal, ymax-15, ymin+15, colMax, colMin);
     filterMin[colIdx[selectedCol]] = yVal; 
  }
} else if(minDiff > maxDiff) {
  if(colInvert[colIdx[selectedCol]] == 0) {
     float colMin = data.getColumnMin(colIdx[selectedCol]); 
     float colMax = data.getColumnMax(colIdx[selectedCol]);   
     float yVal = map(newFilterVal, ymax-15, ymin+15, colMin, colMax);
     filterMax[colIdx[selectedCol]] = yVal;
  } else if(colInvert[colIdx[selectedCol]] == 1) {
     float colMin = data.getColumnMin(colIdx[selectedCol]); 
     float colMax = data.getColumnMax(colIdx[selectedCol]);   
     float yVal = map(newFilterVal, ymax-15, ymin+15, colMax, colMin);
     filterMax[colIdx[selectedCol]] = yVal; 
  }
}
}

void drawClusterMeans() {
 for(int clust = 0; clust < kval; clust++) {
  if(kval == 3) {
    
    int inFilter = 1; 
    for(int col = 0; col < numCols; col++) {
      float dataVal = clusterStats.getFloat(clust,colIdx[col]); 
      if(dataVal > filterMax[colIdx[col]] || dataVal < filterMin[colIdx[col]]){
       inFilter = 0;  
      }
    }
      
    
    if(inFilter == 1) {
    stroke(clustColorR[clust], clustColorG[clust], clustColorB[clust]); 
    strokeWeight(3);
    noFill(); 
    beginShape(); 
    for (int col = 0; col < numCols; col++) {
      float colMin = data.getColumnMin(colIdx[col]); 
      float colMax = data.getColumnMax(colIdx[col]); 
      float value = clusterStats.getFloat(clust, colIdx[col]);

      if (colInvert[colIdx[col]] == 0) {
        float y = map(value, colMin, colMax, ymax-15, ymin+15);
        vertex((col*linespace)+xmin+10, y);
      } 
      else if (colInvert[colIdx[col]] == 1) {
        float y = map(value, colMax, colMin, ymax-15, ymin+15); 
        vertex((col*linespace)+xmin+10, y);
      }
    }
    endShape();
  } else if(inFilter == 0) {
    stroke(0, 0, 0, 20); 
    strokeWeight(3);
    noFill(); 
    beginShape(); 
    for (int col = 0; col < numCols; col++) {
      float colMin = data.getColumnMin(colIdx[col]); 
      float colMax = data.getColumnMax(colIdx[col]); 
      float value = clusterStats.getFloat(clust, colIdx[col]);

      if (colInvert[colIdx[col]] == 0) {
        float y = map(value, colMin, colMax, ymax-15, ymin+15);
        vertex((col*linespace)+xmin+10, y);
      } 
      else if (colInvert[colIdx[col]] == 1) {
        float y = map(value, colMax, colMin, ymax-15, ymin+15); 
        vertex((col*linespace)+xmin+10, y);
      }
    }
    endShape();
    
  }
} else if(kval == 5) {
    
      int inFilter = 1; 
    for(int col = 0; col < numCols; col++) {
      float dataVal = clusterStats.getFloat(clust+3,colIdx[col]); 
      if(dataVal > filterMax[colIdx[col]] || dataVal < filterMin[colIdx[col]]){
       inFilter = 0;  
      }
    }
      
    
    if(inFilter == 1) {
    stroke(clustColorR[clust], clustColorG[clust], clustColorB[clust]); 
    strokeWeight(3);
    noFill(); 
    beginShape(); 
    for (int col = 0; col < numCols; col++) {
      float colMin = data.getColumnMin(colIdx[col]); 
      float colMax = data.getColumnMax(colIdx[col]); 
      float value = clusterStats.getFloat(clust+3, colIdx[col]);

      if (colInvert[colIdx[col]] == 0) {
        float y = map(value, colMin, colMax, ymax-15, ymin+15);
        vertex((col*linespace)+xmin+10, y);
      } 
      else if (colInvert[colIdx[col]] == 1) {
        float y = map(value, colMax, colMin, ymax-15, ymin+15); 
        vertex((col*linespace)+xmin+10, y);
      }
    }
    endShape();
  } else if(inFilter == 0) {
    stroke(0, 0, 0, 20); 
    strokeWeight(3);
    noFill(); 
    beginShape(); 
    for (int col = 0; col < numCols; col++) {
      float colMin = data.getColumnMin(colIdx[col]); 
      float colMax = data.getColumnMax(colIdx[col]); 
      float value = clusterStats.getFloat(clust+3, colIdx[col]);

      if (colInvert[colIdx[col]] == 0) {
        float y = map(value, colMin, colMax, ymax-15, ymin+15);
        vertex((col*linespace)+xmin+10, y);
      } 
      else if (colInvert[colIdx[col]] == 1) {
        float y = map(value, colMax, colMin, ymax-15, ymin+15); 
        vertex((col*linespace)+xmin+10, y);
      }
    }
    endShape();
    
  }
} else if(kval == 10) {
      int inFilter = 1; 
    for(int col = 0; col < numCols; col++) {
      float dataVal = clusterStats.getFloat(clust+8,colIdx[col]); 
      if(dataVal > filterMax[colIdx[col]] || dataVal < filterMin[colIdx[col]]){
       inFilter = 0;  
      }
    }
    
    if(inFilter == 1) {
    stroke(clustColorR[clust], clustColorG[clust], clustColorB[clust]); 
    strokeWeight(3);
    noFill(); 
    beginShape(); 
    for (int col = 0; col < numCols; col++) {
      float colMin = data.getColumnMin(colIdx[col]); 
      float colMax = data.getColumnMax(colIdx[col]); 
      float value = clusterStats.getFloat(clust+8, colIdx[col]);

      if (colInvert[colIdx[col]] == 0) {
        float y = map(value, colMin, colMax, ymax-15, ymin+15);
        vertex((col*linespace)+xmin+10, y);
      } 
      else if (colInvert[colIdx[col]] == 1) {
        float y = map(value, colMax, colMin, ymax-15, ymin+15); 
        vertex((col*linespace)+xmin+10, y);
      }
    }
    endShape();
  } else if(inFilter == 0) {
    stroke(0, 0, 0, 20); 
    strokeWeight(3);
    noFill(); 
    beginShape(); 
    for (int col = 0; col < numCols; col++) {
      float colMin = data.getColumnMin(colIdx[col]); 
      float colMax = data.getColumnMax(colIdx[col]); 
      float value = clusterStats.getFloat(clust+8, colIdx[col]);

      if (colInvert[colIdx[col]] == 0) {
        float y = map(value, colMin, colMax, ymax-15, ymin+15);
        vertex((col*linespace)+xmin+10, y);
      } 
      else if (colInvert[colIdx[col]] == 1) {
        float y = map(value, colMax, colMin, ymax-15, ymin+15); 
        vertex((col*linespace)+xmin+10, y);
      }
    }
    endShape();
    
  }
}
  }
 } 
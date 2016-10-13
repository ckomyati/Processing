FloatTable data;

String dataPath = "cameras.csv";
int numRows;
int numCols;
int[] colMin;
int[] colMax;
String[] colNames;

float plotX1, plotY1;
float plotX2, plotY2;
float diffBetweenXCoords;
PFont titleFont;
PFont labelFont;
PFont axisLimitsFont;

color[] axisColor       = { #333333, #000000 };
color[] fontAxisColor   = { #333333, #FF2222 };
color[] fontLimitsColor = { #555555, #FF2222 };
color triangleColor     = #888888;
color[] linesColor      = { #ED1317, #1397ED };

int[] axisOrder;
boolean[] axisFlipped;

// Setup
void setup()
{
  size(1000, 500);

  // Read data
  data = new FloatTable(dataPath);
  numRows = data.getRowCount();
  numCols = data.getColumnCount();
  colNames = data.getColumnNames();

  colMin  = new int[ numCols ];
  colMax  = new int[ numCols ];
  axisOrder = new int[ numCols ];
  axisFlipped = new boolean[ numCols ];

  for(int col = 0; col < numCols; col++)
  {
    float maxNumber = data.getColumnMax(col);
    float minNumber = data.getColumnMin(col);

    colMin[col] = int(floor(minNumber));
    colMax[col] = int(ceil(maxNumber));

    axisOrder[col] = col;
    axisFlipped[col] = false;
  }

  // Fonts
  titleFont = createFont("Verdana", 16);
  labelFont = createFont("Verdana Bold", 11);
  axisLimitsFont = createFont("Georgia", 11);

  // Plot area limits
  plotX1 = 30;
  plotX2 = width - plotX1;
  plotY1 = 60;
  plotY2 = height - plotY1;

  diffBetweenXCoords = (plotX2 - plotX1) / (numCols - 1);

  if(frame != null)
  {
    surface.setTitle(dataPath);
  }

  smooth();
}
     // Draw
void draw()
{
    // Background
    background(240);

    // Draw the plot area
    fill(240);
    noStroke();
    rect(plotX1, plotY1, plotX2 - plotX1, plotY2 - plotY1);

    //drawTitle();
    drawAxis();
    drawLines();
}

void drawAxis()
{
  float xCoordsForAxis = plotX1;
  float yAxisLbl = plotY2 + 40;
  float yMinLbl  = plotY2 + 15;
  float yMaxLbl  = plotY1 - 7;
  float yTriMin  = plotY1 - 25;
  float yTriMax  = plotY1 - 35;

  strokeCap(PROJECT);
  strokeWeight(1);
  stroke(0);

  for( int col = 0; col < numCols; col++, xCoordsForAxis += diffBetweenXCoords )
  {
    int colToDraw = axisOrder[col];

    // Draw Axis
    stroke(axisColor[0]);
    line(xCoordsForAxis, plotY1, xCoordsForAxis, plotY2);

    // Label min/max
    textAlign(CENTER);
    textFont(axisLimitsFont);
    fill(fontLimitsColor[0]);
    if( axisFlipped[colToDraw])
    {
      text( colMin[colToDraw], xCoordsForAxis, yMaxLbl);
      text( colMax[colToDraw], xCoordsForAxis, yMinLbl);
    }
    else
    {
      text( colMin[colToDraw], xCoordsForAxis, yMinLbl);
      text( colMax[colToDraw], xCoordsForAxis, yMaxLbl);
    }

    // Axis label
    textFont( labelFont );
    fill(fontAxisColor[0]);
    text( colNames[colToDraw], xCoordsForAxis, yAxisLbl );

    // Triangle
    fill(triangleColor);
    noStroke();
    if( axisFlipped[colToDraw] )
    {
      triangle(xCoordsForAxis - 3, yTriMax, xCoordsForAxis, yTriMin, xCoordsForAxis + 3, yTriMax);
    }
    else
    {
      triangle(xCoordsForAxis - 3, yTriMin, xCoordsForAxis, yTriMax, xCoordsForAxis + 3, yTriMin);
    }
  }
}

void drawLines()
{
  noFill();
  strokeWeight(1);

  for(int row = 0; row < numRows; row++)
  {
    beginShape();
    for(int column = 0; column < numCols; column++)
    {
      int colToDraw = axisOrder[column];
      if(data.isValid(row, column))
      {
        float cMax = ( axisFlipped[colToDraw] ? colMin[colToDraw] : colMax[colToDraw] );
        float cMin = ( axisFlipped[colToDraw] ? colMax[colToDraw] : colMin[colToDraw] );
        float value = data.getFloat(row, colToDraw);

        float x = plotX1 + diffBetweenXCoords * colToDraw;
        float y = map(value, cMin, cMax, plotY2, plotY1);

        //stroke(#5679C1);
        if(colToDraw == 0)
        {
          stroke( lerpColor(linesColor[0], linesColor[1],  map(value, cMin, cMax, 0., 1.) ), 150 );
        }
        vertex(x, y);
      }
    }
    endShape();
  }
}


class FloatTable {
  int rowCount;
  int columnCount;
  float[][] data;
  String[] rowNames;
  String[] columnNames;


  FloatTable(String filename) {
    String[] rows = loadStrings(filename);

    String[] columns = split(rows[0], TAB);
    columnNames = subset(columns, 1); // upper-left corner ignored
    scrubQuotes(columnNames);
    columnCount = columnNames.length;

    rowNames = new String[rows.length-1];
    data = new float[rows.length-1][];

    // start reading at row 1, because the first row was only the column headers
    for (int i = 1; i < rows.length; i++) {
      if (trim(rows[i]).length() == 0) {
        continue; // skip empty rows
      }
      if (rows[i].startsWith("#")) {
        continue;  // skip comment lines
      }

      // split the row on the tabs
      String[] pieces = split(rows[i], TAB);
      scrubQuotes(pieces);

      // copy row title
      rowNames[rowCount] = pieces[0];
      // copy data into the table starting at pieces[1]
      data[rowCount] = parseFloat(subset(pieces, 1));

      // increment the number of valid rows found so far
      rowCount++;      
    }
    // resize the 'data' array as necessary
    data = (float[][]) subset(data, 0, rowCount);
  }


  void scrubQuotes(String[] array) {
    for (int i = 0; i < array.length; i++) {
      if (array[i].length() > 2) {
        // remove quotes at start and end, if present
        if (array[i].startsWith("\"") && array[i].endsWith("\"")) {
          array[i] = array[i].substring(1, array[i].length() - 1);
        }
      }
      // make double quotes into single quotes
      array[i] = array[i].replaceAll("\"\"", "\"");
    }
  }


  int getRowCount() {
    return rowCount;
  }


  String getRowName(int rowIndex) {
    return rowNames[rowIndex];
  }


  String[] getRowNames() {
    return rowNames;
  }


  // Find a row by its name, returns -1 if no row found. 
  // This will return the index of the first row with this name.
  // A more efficient version of this function would put row names
  // into a Hashtable (or HashMap) that would map to an integer for the row.
  int getRowIndex(String name) {
    for (int i = 0; i < rowCount; i++) {
      if (rowNames[i].equals(name)) {
        return i;
      }
    }
    //println("No row named '" + name + "' was found");
    return -1;
  }


  // technically, this only returns the number of columns 
  // in the very first row (which will be most accurate)
  int getColumnCount() {
    return columnCount;
  }


  String getColumnName(int colIndex) {
    return columnNames[colIndex];
  }


  String[] getColumnNames() {
    return columnNames;
  }


  float getFloat(int rowIndex, int col) {
    // Remove the 'training wheels' section for greater efficiency
    // It's included here to provide more useful error messages

    // begin training wheels
    if ((rowIndex < 0) || (rowIndex >= data.length)) {
      throw new RuntimeException("There is no row " + rowIndex);
    }
    if ((col < 0) || (col >= data[rowIndex].length)) {
      throw new RuntimeException("Row " + rowIndex + " does not have a column " + col);
    }
    // end training wheels

    return data[rowIndex][col];
  }


  boolean isValid(int row, int col) {
    if (row < 0) return false;
    if (row >= rowCount) return false;
    //if (col >= columnCount) return false;
    if (col >= data[row].length) return false;
    if (col < 0) return false;
    return !Float.isNaN(data[row][col]);
  }


  float[] getColumnMinMax(int col) {
    float Min =  Float.MAX_VALUE;
    float Max = -Float.MAX_VALUE;
    for (int i = 0; i < rowCount; i++) {

      if (!Float.isNaN(data[i][col])) {

        if (data[i][col] < Min) {
          Min = data[i][col];
        }

        if (data[i][col] > Max) {
          Max = data[i][col];
        }
      }
    }
    float[] toRet = { Min, Max };
    return toRet;
  }


  float getColumnMin(int col) {
    float m = Float.MAX_VALUE;
    for (int i = 0; i < rowCount; i++) {
      if (!Float.isNaN(data[i][col])) {
        if (data[i][col] < m) {
          m = data[i][col];
        }
      }
    }
    return m;
  }


  float getColumnMax(int col) {
    float m = -Float.MAX_VALUE;
    for (int i = 0; i < rowCount; i++) {
      if (isValid(i, col)) {
        if (data[i][col] > m) {
          m = data[i][col];
        }
      }
    }
    return m;
  }


  float getRowMin(int row) {
    float m = Float.MAX_VALUE;
    for (int i = 0; i < columnCount; i++) {
      if (isValid(row, i)) {
        if (data[row][i] < m) {
          m = data[row][i];
        }
      }
    }
    return m;
  } 


  float getRowMax(int row) {
    float m = -Float.MAX_VALUE;
    for (int i = 1; i < columnCount; i++) {
      if (!Float.isNaN(data[row][i])) {
        if (data[row][i] > m) {
          m = data[row][i];
        }
      }
    }
    return m;
  }


  float getTableMin() {
    float m = Float.MAX_VALUE;
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        if (isValid(i, j)) {
          if (data[i][j] < m) {
            m = data[i][j];
          }
        }
      }
    }
    return m;
  }


  float getTableMax() {
    float m = -Float.MAX_VALUE;
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        if (isValid(i, j)) {
          if (data[i][j] > m) {
            m = data[i][j];
          }
        }
      }
    }
    return m;
  }
}
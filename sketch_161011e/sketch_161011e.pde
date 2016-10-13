class FloatTable {
  int rowCount;
  int colCount;
  float [][] data;
  String[] rowName;
  String[] colName;

  FloatTable(String cameras) {
    String [] rows = loadStrings("cameras.csv");
    String [] cols = split(rows[0], ',');

    // scrubQuotes(colName);
    colCount = colName.length;
    rowName = new String[rows.length-1];
    data = new float[rows.length-1][];

    for (int i = 1; i < rows.length; i++) {
      if (trim(rows[i]).length() == 0) {
        continue;
      }

      String[] pieces = split(rows[i], ",");
      //scrubQuotes(pieces);

      rowName[rowCount] = pieces[0];
      data[rowCount] = parseFloat(subset(pieces, 1));
      rowCount++;
    }
    data = (float[][]) subset(data, 0, rowCount);
  }

  //void scrubQuotes(String[] array) {
  //  for (int i = 0; i < array.length; i++) {
  //    if (array[i].length() > 2) {
  //      // remove quotes at start and end, if present
  //      if (array[i].startsWith("\"") && array[i].endsWith("\"")) {
  //        array[i] = array[i].substring(1, array[i].length() - 1);
  //      }
  //    }
  //    // make double quotes into single quotes
  //    array[i] = array[i].replaceAll("\"\"", "\"");
  //  }

  //methods for data
  int getRowCount() {
    return rowCount;
  }

  String getRowName(int rowIndex) {
    return rowName[rowIndex];
  }

  String[] getRowNames() {
    return rowName;
  }

  int getRowIndex(String name) {
    for (int i = 0; i < rowCount; i++) {
      if (rowName[i].equals(name)) {
        return i;
      }
    }
    return -1;
  }

  int getColumnCount() {
    return colCount;
  }
  String getColumnName(int colIndex) {
    return colName[colIndex];
  }
  String[] getColumnNames() {
    return colName;
  }

  float getFloat(int rowIndex, int col) {
    //if ((rowIndex < 0) || (rowIndex >= data.length)) {
    //  throw new RuntimeException("There is no row " + rowIndex);
    //}
    //if ((col < 0) || (col >= data[rowIndex].length)) {
    //  throw new RuntimeException("Row " + rowIndex + " does not have a column " + col);
    //}

    return data[rowIndex][col];
  }

  boolean isValid(int row, int col) {
    if (row < 0) return false;
    if (row >= rowCount) return false;
    if (col >= data[row].length) return false;
    if (col < 0) return false;
    return !Float.isNaN(data[row][col]);
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
    for (int i = 0; i < colCount; i++) {
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
    for (int i = 1; i < colCount; i++) {
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
      for (int j = 0; j < colCount; j++) {
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
      for (int j = 0; j < colCount; j++) {
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
Table table;
//String cameras = "cameras.csv";

//set up arrays for data
int rows;
int cols;
int [] min;
int[] max;
String[] categs;

float x1, y1;
float x2, y2;
float diff;
PFont title;
PFont labels;
PFont axes;

int[] axisOrder;
boolean[] axisFlipped;

//CLAIRE FIX THIS
color[] axesC       = { #333333, #000000 };
color[] fontAxisColor   = { #333333, #FF2222 };
color[] fontLimitsColor = { #555555, #FF2222 };
color triangleCol     = #888888;
color[] linesCol     = { #ED1317, #1397ED };

void setup() {
  size(1000, 500);
  smooth();
  surface.setResizable(true);
  //load data from csv file
  String[] data = loadStrings("cameras.csv");

  // sort data
  table = loadTable("cameras.csv", "header");
  table.addColumn("name");
  table.addColumn("type");

  rows = table.getRowCount();
  cols = table.getColumnCount();
  // categs = table.getColumnNames();

  min  = new int[ cols ];
  max  = new int[ cols ];
  axisOrder = new int[ cols ];
  axisFlipped = new boolean[ cols ];

  for (int i = 0; i < cols; i++)
  {
   //float maxNumber = cameras.getColumnMax(i);
    //float minNumber = cameras.getColumnMin(i);

   // min[i] = int(floor(minNumber));
  //  max[i] = int(ceil(maxNumber));

    axisOrder[i] = i;
    axisFlipped[i] = false;
  }

  // Fonts
  title = createFont("Verdana", 16);
  labels = createFont("Verdana Bold", 11);
  axes = createFont("Georgia", 11);

  // Plot area limits
  x1 = 30;
  x2 = width - x1;
  y1 = 60;
  y2 = height - y1;

  diff = (x2 - x1) / (cols - 1);

  //if (frame != null)
  //{
  //  frame.setTitle(cameras);
  //}

  smooth();
}
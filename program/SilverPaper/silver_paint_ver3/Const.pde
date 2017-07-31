//number , average of sensors
final static int SENSOR_NUM = 4;
final static int AVERAGE_NUM = 10;
final static int AVE_AVERAGE_NUM = 2;

final static int X = 0;
final static int Y = 1;

final color COLOR_BLACK = color(0,0,0);
final color COLOR_RED = color(255,0,0);
final color COLOR_ORANGE = color(255,165,0);
final color COLOR_GREEN = color(0,150,0);
final color COLOR_BLUE = color(0,60,255);

// Serial address
// String SERIAL_ADDRESS = "COM7";
//String SERIAL_ADDRESS = "/dev/cu.usbserial-AH02OBZM";
String SERIAL_ADDRESS = "/dev/cu.usbmodem1411";

// Display size
final static int DISPLAY_WIDTH = 1600;
final static int DISPLAY_HEIGHT = 900;

//Graph Const
int WAVE_GRAPH_POS[] = {80,0};
int WAVE_GRAPH_SIZE[] = {700,250};
float GRAPH_MAX = 150;
float GRAPH_AVE = 800;
float GRAPH_MIN = 300;
int ELLIPSE_MAX = 300;
int PLACE_CIRCLE_POS[] = {DISPLAY_WIDTH-100, 70};
int PLACE_CIRCLE_DIAMETER = 120;
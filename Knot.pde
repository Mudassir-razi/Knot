import javax.swing.JColorChooser;
import java.awt.Color;
import processing.svg.*;

Color sc;

//drawing variables
int count = 10;
int vertex = 5;
int tile = 1;
float offset = 10;
float radius = 50;
float border = 3;

//modes
boolean addOn = true;
boolean stroke = true;
boolean precisionMode = false;
boolean altKey = false;
boolean ctrlKey = false;
boolean toggleMenu = true;
boolean toggleColorMenu = false;
boolean toggleTilePreview = false;
boolean tileSizeChanged = false;
float precisionMultipler = 0.1;
float localRotation = 0;
float globalRotation = 0;
float lastMouseX;
color selectedColor;
color bgColor;
bios io;

//layer stuff
ArrayList<PGraphics> layers;
PGraphics menu;
PGraphics currentLayer;
GonHolder graph;

//time keeping
float deltaTime = 0;
float lastTime = 0;
float timeImsaveCounter = 0;

//................................................................................................................
//setting things up
void setup()
{
  size(1000, 1000);
  
  //initialize layers
  layers = new ArrayList<PGraphics>();
  currentLayer = createGraphics(width, height);
  menu = createGraphics(220, height);
  
  io = new bios();
  layers.add(currentLayer);
  selectedColor = randomColor(true);
  bgColor = randomColor(false);
  lastMouseX = 0;
  graph = new GonHolder(count, vertex, offset, new PVector(width/2, height/2), radius, currentLayer, selectedColor, stroke);

  initMenu();
  background(0);
}

//................................................................................................................
//drawing
void draw()
{
  //println(frameRate);
  background(bgColor);
  
  //timekeeping
  deltaTime = millis() - lastTime;
  lastTime = millis();
  
  //start layering
  currentLayer.beginDraw();
  currentLayer.background(0, 0);
  if (addOn)
  {
    graph.update(count, vertex, offset, selectedColor, new PVector(width/2, height/2), radius, stroke);
    graph.updateRotation(globalRotation, localRotation, border);
    graph.display();
  }
  currentLayer.endDraw();

  //draws every layer
  for (int i = 0; i < layers.size(); i++)
  {
    image(layers.get(i), 0, 0, layers.get(i).width/2, layers.get(i).height/2);
    //image(layers.get(i), layers.get(i).width/2, 0, layers.get(i).width/2, layers.get(i).height/2);
    //image(layers.get(i), 0, layers.get(i).height/2, layers.get(i).width/2, layers.get(i).height/2);
    //image(layers.get(i), layers.get(i).width/2, layers.get(i).height/2, layers.get(i).width/2, layers.get(i).height/2);
  }

  if (toggleMenu)image(menu, 0, 0);
  timeImsaveCounter += deltaTime;
}

//................................................................................................................
//basic I/O handler
//keyboard functions
//and mouse inputs
void keyPressed()
{
  io.mapKeysPr();
}

void mousePressed()
{
  io.mapMousePr();
}

void mouseReleased()
{
  io.mapMouseRe();
}

void mouseMoved()
{
  io.mapMouseMove();
}

void mouseWheel(MouseEvent event)
{
  io.mapMouseWheel(event);
}

//................................................................................................................
//helper functions
//when clicked, pulls in the current graph
//creates a new one to draw
void AddLayer()
{
  currentLayer = createGraphics(width, height);
  layers.add(currentLayer);
  //selectedColor = randomColor();
  graph = new GonHolder(count, vertex, offset, new PVector(width/2, height/2), radius, currentLayer, selectedColor, false);
}

color randomColor(boolean b)
{
  if(b)return color(random(0, 250), 250, 80);
  return color(random(0, 250), 250, 30);
}

//................................................................................................................
//utility functions

void initMenu()
{
  float x = 10, y = 10;
  float offsetM = 30;
  menu.beginDraw();
  menu.background(100, 100);
  menu.fill(255);
  menu.textSize(30);
  menu.text("Knot", x, y+offsetM);
  y += offsetM;
  menu.text(".................", x, y+offsetM);
  y += 2 * offsetM;
  menu.textSize(20);
  //keyboard bindings
  menu.text("Key bindings", x, y + offsetM);
  y += offsetM;
  menu.textSize(12);
  menu.text("W/S -- vertex count", x, y + offsetM);
  y += offsetM;
  menu.text("A/D -- radius", x, y + offsetM);
  y += offsetM;
  menu.text("Q/E -- polygon count", x, y + offsetM);
  y += offsetM;
  menu.text(" C/B -- colorpicker polygon/background \n", x, y + offsetM);
  y += offsetM;
  menu.text("1/2 -- lower border width", x, y + offsetM);
  y += offsetM;
  menu.text("F -- toggle fill", x, y + offsetM);
  y += offsetM;
  menu.text("Shift -- toggle precision mode", x, y + offsetM);
  y += offsetM;
  menu.text("R -- toggle new item", x, y + offsetM);
  y += offsetM;
  menu.text(" X -- undo last action \n", x, y + offsetM);
  y += offsetM;
  menu.text("Z -- Save image", x, y + offsetM);
  y += offsetM;
  menu.text(" \"`\" -- toggle menu \n", x, y + offsetM);
  y += 2 * offsetM;

  //mouse clicks
  menu.textSize(20);
  menu.text("Mouse control", x, y + offsetM);
  y += offsetM;
  menu.textSize(12);
  menu.text("LMB -- place design", x, y + offsetM);
  y += offsetM;
  menu.text("mouseX -- offset", x, y + offsetM);
  y += offsetM;
  menu.text("scroll -- global rotation", x, y + offsetM);
  y += offsetM;
  menu.text("ctrl+scroll -- local rotation", x, y + offsetM);
  y += offsetM;

  menu.endDraw();
}

void saveImage()
{
  //saveFrame("Knot_####_.png");
  println("Saving now");
  PGraphics svg = createGraphics(width, height, SVG, "Knot_####.svg");
  svg.beginDraw();
  svg.background(bgColor);
  for(int i = 0;i < layers.size();i++)
  {
    svg.image(layers.get(i), 0, 0);
  }
  svg.dispose();
  svg.endDraw();
}

float clamp(float val, float lower, float upper)
{
  if (val < lower)val = lower;
  if (val > upper)val = upper;
  return val;
}
int clamp(int val, int lower, int upper)
{
  if (val < lower)val = lower;
  if (val > upper)val = upper;
  return val;
}

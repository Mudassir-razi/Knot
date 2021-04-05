import javax.swing.JColorChooser;
import java.awt.Color;
import processing.svg.*;
import controlP5.*;
import java.util.*;

ControlP5 cp5;

Color sc;

//drawing variables
int count = 10;
int vertex = 5;
int tiles = 2;
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
boolean tilePreviewMode = false;    //two modes. normal or merge
float precisionMultipler = 0.1;
float localRotation = 0;
float globalRotation = 0;
float lastMouseX;
int selectedFormat = 0;
color selectedColor;
color bgColor;
bios io;

//layer stuff
ArrayList<PGraphics> layers;    //for viewer
ArrayList<GonHolder> graphs;
PGraphics menu;
PGraphics currentLayer;
PGraphics default_;
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
  graphs = new ArrayList<GonHolder>();
  currentLayer = createGraphics(width, height);
  menu = createGraphics(220, height);
  cp5 = new ControlP5(this);

  //advanced menu items
  //adding format selection
  List l = Arrays.asList("png", "svg");
  List tileMode = Arrays.asList("Normal", "Merge");

  //adding tiling option
  cp5.addToggle("toggleTile")
    .setPosition(10, 650)
    .setSize(50, 20)
    ;

  //tiling amount
  cp5.addSlider("tiles")
    .setPosition(100, 370)
    .setWidth(400)
    .setRange(0, 10) // values can range from big to small as well
    .setValue(2)
    .setNumberOfTickMarks(7)
    .setSliderMode(Slider.FLEXIBLE)
    ;

  //addint tiling mode option
  cp5.addScrollableList("tileMode")
    .setPosition(10, 700)
    .setSize(200, 100)
    .setBarHeight(20)
    .setItemHeight(20)
    .addItems(tileMode)
    ;


  //image saving format  
  cp5.addScrollableList("SelectFormat")
    .setPosition(10, 800)
    .setSize(200, 100)
    .setBarHeight(20)
    .setItemHeight(20)
    .addItems(l)
    ;



  io = new bios();
  layers.add(currentLayer);
  selectedColor = randomColor(true);
  bgColor = randomColor(false);
  lastMouseX = 0;
  graph = new GonHolder(count, vertex, offset, new PVector(width/2, height/2), radius, currentLayer, selectedColor, stroke);
  default_ = this.g;
  initMenu();
  background(0);
}

//................................................................................................................
//drawing
void draw()
{

  //println(frameRate);
  println(tiles);
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

  if (!toggleTilePreview) {
    //draws every layer
    for (int i = 0; i < layers.size(); i++)
    {
      image(layers.get(i), 0, 0, layers.get(i).width, layers.get(i).height);
      //image(layers.get(i), layers.get(i).width/2, 0, layers.get(i).width/2, layers.get(i).height/2);
      //image(layers.get(i), 0, layers.get(i).height/2, layers.get(i).width/2, layers.get(i).height/2);
      //image(layers.get(i), layers.get(i).width/2, layers.get(i).height/2, layers.get(i).width/2, layers.get(i).height/2);
    }
  } else
  {
    pushMatrix();
    scale(0.5, 0.5);
    for (int i = 0; i < 2; i++)
    {
      for (int j = 0; j < 2; j++)
      {
        //rendering added layers
        for (int k = 0; k < graphs.size(); k++)
        {
          pushMatrix();
          translate(i * width, j * height);
          graphs.get(k).displayOnLayer(default_, tilePreviewMode);
          popMatrix();
        }
        //rendering current layer
        if (addOn) {
          pushMatrix();
          translate(i * width, j * height);
          graph.displayOnLayer(default_, tilePreviewMode);
          popMatrix();
        }
      }
    }
    popMatrix();
  }
  if (toggleMenu)
  {
    image(menu, 0, 0);
    cp5.get(ScrollableList.class, "SelectFormat").show();
    cp5.get(ScrollableList.class, "tileMode").show();
    cp5.get(Toggle.class, "toggleTile").show();
  } else { 
    cp5.get(ScrollableList.class, "SelectFormat").hide();
    cp5.get(ScrollableList.class, "tileMode").hide();
    cp5.get(Toggle.class, "toggleTile").hide();
  }
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
  if (!toggleMenu)io.mapMousePr();
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

//dropdown control
void SelectFormat(int n)
{
  selectedFormat = n;
  println(n, cp5.get(ScrollableList.class, "SelectFormat").getItem(n));
}

void tileMode(int n)
{
  tilePreviewMode = n == 1? true : false;
}

//toggle tile view
void toggleTile(boolean theFlag)
{
  toggleTilePreview = theFlag;
  println(theFlag);
}

//................................................................................................................
//helper functions
//when clicked, pulls in the current graph
//creates a new one to draw
void AddLayer()
{
  currentLayer = createGraphics(width, height);
  layers.add(currentLayer);
  graphs.add(graph);
  //selectedColor = randomColor();
  graph = new GonHolder(count, vertex, offset, new PVector(width/2, height/2), radius, currentLayer, selectedColor, false);
}

color randomColor(boolean b)
{
  if (b)return color(random(0, 250), 250, 80);
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
  println("Saving now");
  if (selectedFormat == 0)saveFrame("Knot_####_.png");
  else {
    PGraphics svg = createGraphics(width, height, SVG, "Knot_####.svg");
    svg.beginDraw();
    svg.background(bgColor);
    println(graphs.size());
    for (int i = 0; i < graphs.size(); i++)
    {
      svg.pushMatrix();
      graphs.get(i).displayOnLayer(svg, tilePreviewMode);
      svg.popMatrix();
      //svg.image(layers.get(i), 0, 0);
    }
    //svg.dispose();
    svg.endDraw();
  }
  println("Saved");
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

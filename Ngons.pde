
//i know
//it's a terrible name
//still.. it holds the ngons.
class GonHolder
{
  //holder properties
  ArrayList<Ngon> gons;
  int count;
  float gloRot;
  PVector center;
  PGraphics layer;
  boolean stroke;
  color shade; 

  //properties for ngons
  int n;
  float rad;
  float offset;
  float locRot;
  float borderWidth;

  GonHolder(int Count, int vertex, float Offset, PVector c, float r, PGraphics Layer, color Shade, boolean Stroke)
  {
    n = vertex;
    center = c;
    gons = new ArrayList<Ngon>();
    count = Count;
    rad = r;
    offset = Offset;
    layer = Layer;
    stroke = Stroke;
    shade = Shade;
    borderWidth = 1;
    
    for (int i = 0; i < count; i++)
    {
      Ngon currentGon = new Ngon(n, rad);
      gons.add(currentGon);
    }
    
  }
  
  void display()
  {
    layer.translate(center.x, center.y);
    layer.rotate((gloRot*PI)/180);
    float angle = (360.00/count)*(PI/180);
    for(int i = 0;i < count;i++)
    {
      layer.pushMatrix();
      layer.rotate(angle * i);
      layer.translate(offset, 0);
      gons.get(i).display(layer, locRot, shade, stroke, borderWidth);
      layer.popMatrix();
    }
  }
  
  void updateRotation(float global, float local, float w)
  {
    gloRot = global;
    locRot = local;
    borderWidth = w;
  }
  
  void update(int Count, int vertex, float Offset, color col, PVector c, float r, boolean Stroke)
  {
    
    //updating stuff
    n = vertex;
    center = c;
    rad = r;
    offset = Offset;
    stroke = Stroke;
    shade = col;
    //increase or decrease based on count
    if(Count <= 0)return;
    while(count != Count)
    {
      if(count < Count)
      {
        Ngon newGon = new Ngon(n, rad);
        gons.add(newGon);
      }
      else if(count > Count)
      {
        gons.remove(0);
      }
      count = gons.size();
    }
    
    for (int i = 0; i < count; i++)
    {
      Ngon currentGon = gons.get(i);
      currentGon.update(n, rad);
    }
  }
  
}

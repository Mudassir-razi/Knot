class Ngon
{
  
  int vert;
  float rad;
  
  Ngon(int n, float r)
  {
    vert = n;
    rad = r;
  }
  
  void update(int ver, float r)
  {
    rad = r;
    vert = ver;
  }
  
  void display(PGraphics layer, float rotation, color c, boolean stroke, float strokeWidth)
  {
    layer.pushMatrix();
    layer.rotate(rotation);
    if(stroke)
    {
      layer.noFill();
      layer.stroke(c);
      layer.strokeWeight(strokeWidth);
    }

    else{
    layer.noStroke();
    layer.fill(c);
    }
    
    if(vert > 8)
    {
      layer.circle(0, 0, rad * 2);
    }
    
    else polygon(0, 0, rad, vert, layer); 
    layer.popMatrix();
  }
  
  private void polygon(float x, float y, float radius, int npoints, PGraphics layer) {
  float angle = TWO_PI / npoints;
  layer.beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius;
    float sy = y + sin(a) * radius;
    layer.vertex(sx, sy);
  }
  layer.endShape(CLOSE);
}
  
}

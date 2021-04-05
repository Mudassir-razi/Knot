//handles basic input-output

class bios
{
  void mapKeysPr()
  {
    if (key == CODED)
    {
      if (keyCode == SHIFT)
      {
        precisionMode = !precisionMode;
      }

      if (keyCode == CONTROL)
      {
        ctrlKey = true;
      } 

      if (keyCode == ALT)
      {
        altKey = true;
      }
    }

    //count control
    if (key == 'e')
    {
      count++;
    } else if (key == 'q')
    {
      count--;
    }

    //toggle menu
    if (key == '`')
    {
      println("Tab");
      toggleMenu = !toggleMenu;
    }

    //radius control
    if (key == 'a')
    {
      radius -= 10;
    } else if (key == 'd')
    {
      radius += 10;
    }

    //imagesave
    if (key == 'z')
    {
      saveImage();
      //thread("saveImage");
    }

    //vertex control
    if (key == 'w')
    {
      vertex++;
    } else if (key == 's')
    {
      vertex--;
    }

    //stroke width
    if (key == 'f')
    {
      stroke = !stroke;
    }

    //toggle adding stuff
    if (key == 'r')
    {
      addOn = !addOn;
    }

    //change width
    if (key == '1')
    {
      border -= 1;
    }
    if (key == '2')
    {
      border += 1;
    }

    //open color picker window
    if (key == 'c' || key == 'b')
    {
      toggleColorMenu = !toggleColorMenu;
      if (toggleColorMenu)
      {
        sc = JColorChooser.showDialog(null, "Java Color Chooser", Color.white);
        //println(sc);
        if (sc != null)
        {
          if (key == 'c')selectedColor = color(sc.getRed(), sc.getGreen(), sc.getBlue());
          if (key == 'b')bgColor = color(sc.getRed(), sc.getGreen(), sc.getBlue());
        }
        toggleColorMenu = !toggleColorMenu;
        //println(selectedColor);
      }
    }

    //undo
    if (key == 'x' && layers.size() > 1)
    {
      println("Reomves");
      layers.remove(layers.size() - 2);
      graphs.remove(graphs.size() - 1);
    }

    radius = clamp(radius, 0.0, 1000.0);
    vertex = clamp(vertex, 3, 10);
    count = clamp(count, 0, 100);
    border = clamp(border, 0, 100);
  }

  void mapMousePr()
  {
    if (addOn && mouseButton == LEFT) {
      AddLayer();
      println("Layer added");
    }
  }

  void mapMouseRe()
  {
    if (key == CODED)
    {
      if (keyCode == CONTROL)
      {
        ctrlKey = false;
      }
      if (keyCode == ALT)
      {
        altKey = false;
      }
    }
  }

  void mapMouseMove()
  {
    if (precisionMode) offset += precisionMultipler* (mouseX - lastMouseX);
    else offset += 1.5 * (mouseX - lastMouseX);

    lastMouseX = mouseX;
    //if(precisionMode)offset = map(mouseX, 0, width, 0, width/6);
    //else offset = map(mouseX, 0, width, 0,  width/2);
  }

  void mapMouseWheel(MouseEvent event)
  {
    float e = event.getCount();

    //rotation control
    if (e > 0)
    {
      if (ctrlKey)
      {
        localRotation += 5;
      } else globalRotation +=5;
    } else if (e < 0)
    {
      if (ctrlKey)
      {
        localRotation -= 5;
      } else globalRotation -= 5;
    }
  }
}

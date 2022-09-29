class Button
{
  Point pos;
  Point dimensions; //width and heigth of button
  
  String text;
  
  float hoverMovement;
  boolean isHovering;
  
  ClickHandler handler; //handler for onClickEvent
  
  Button(Point pos, Point dimensions, String text, ClickHandler handler)
  {
    this.pos = pos;
    this.dimensions = dimensions;
    this.text = text;
    this.handler = handler;
    isHovering = false;
    hoverMovement = 4;
  }
  
  void display()
  {
    //displays the button on the screen
    fill(0,50,0);
    stroke(0,100,0,240);
    strokeWeight(8);
    rectMode(CENTER);
    rect(pos.x,pos.y,dimensions.x, dimensions.y);
    
    //displays the button text within the bounds of the button drawn above.
    float textSize = min(dimensions.x / 4, dimensions.y /2);
    textSize(textSize);
    fill(0,100,0);
    textAlign(CENTER,CENTER);
    text(text, pos.x, pos.y-textSize/4, dimensions.x, dimensions.y);
  }
  
  void update(Point p)
  {
    onHover(p);
    onClick(p);
  }
  
  void onHover(Point p)
  {
    if (isInsideRect(pos.x-dimensions.x/2+hoverMovement, pos.y-dimensions.y/2-hoverMovement, dimensions.x, dimensions.y, p.x, p.y) && !isHovering)
    { 
      //move the button if the given Point (p) enters the button, to give a hovering effect
      pos.x += hoverMovement/2;
      pos.y -= hoverMovement;
      isHovering = true;
    }
    else if (!isInsideRect(pos.x-dimensions.x/2, pos.y-dimensions.y/2, dimensions.x, dimensions.y, p.x, p.y) && isHovering)
    {
      //move the button back to the starting position if the given Point (p) exits the button
      pos.x -= hoverMovement/2;
      pos.y += hoverMovement;
      isHovering = false;
    }
  }
  
  void onClick(Point p)
  {
    if (isInsideRect(pos.x-dimensions.x/2, pos.y-dimensions.y/2, dimensions.x, dimensions.y, p.x, p.y) && mousePressed)
    {
      //invoke the passed in onClickEvent if p is inside the bounds of the button and the mouse has been pressed
      handler.onClickEvent();
    }
  }
  
  //Checks whether a given point(px, py) is within a rect with the given values(rcx, rcy, w, h), using the rectMode(CORNER).
  boolean isInsideRect(float rcx, float rcy, float w, float h, float px, float py)
  {
    return isInRange(rcx, rcx+w, px) && isInRange(rcy, rcy+h, py);
  }

  //Checks whether or not a value is within a range
  boolean isInRange(float start, float end, float value)
  {
    return start < value && value < end;
  }
}

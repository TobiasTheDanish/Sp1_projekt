class GameMenu
{
  Point pos;
  Point dimensions;
  String[] menuText;
  float textSize;
  boolean menuIsVisible;
  Button[] buttons;
  Point buttonSize;
  String[] buttonText;
  ClickHandler[] handlers;
  
  GameMenu(Point pos, Point dimensions, String[] menuText, float textSize, boolean menuIsVisible, Point buttonSize, String[] buttonText, ClickHandler[] handlers)
  {
    this.pos = pos;
    this.dimensions = dimensions;
    this.menuText = menuText;
    this.textSize = textSize;
    this.menuIsVisible = menuIsVisible;
    this.buttons = new Button[buttonText.length];
    this.buttonSize = buttonSize;
    this.buttonText = buttonText;
    this.handlers = handlers;
    
    initButtons();
  }
  
  void initButtons()
  {
    for (int i = 0; i < buttons.length; i++)
    {
      //initializes a new button at a position based on the amount of buttons the menu has
      float leftX = pos.x - dimensions.x/2;
      buttons[i] = new Button(new Point(leftX + dimensions.x/(buttons.length+1) * (i+1), pos.y + (dimensions.y/2 - buttonSize.y * 1.5)), buttonSize, buttonText[i], handlers[i]); 
    }
  }
  
  void display()
  {
    if (menuIsVisible)
    {
      //Draw the bounding box of the menu to the screen
      fill(0,25,0);
      stroke(0,100,0,240);
      strokeWeight(16);
      rectMode(CENTER);
      rect(pos.x,pos.y,dimensions.x, dimensions.y);
      
      //display the strings passed to the menu, within the bounds of the menu.
      for (int i = 0; i < menuText.length; i++)
      {
        float textPosY = (pos.y - dimensions.y/2);
        float textAreaHeight = dimensions.y - buttonSize.y * 2;
        
        if (i == 0)
        {
          //Making the first text element larger to give a feeling of it being the title
          textSize(textSize *1.5);
        }
        else
        {
          textSize(textSize);
        }
        
        textLeading(textSize/2);
        fill(0,100,0);
        textAlign(CENTER,CENTER);
        text(menuText[i], pos.x, textPosY + (textAreaHeight/(menuText.length+2)) * (i+1), dimensions.x, textAreaHeight);
      }
      
      //display all the buttons passed to the menu.
      for (int i = 0; i < buttons.length; i++)
      {
        buttons[i].display(); 
      }
      
      rectMode(CORNER);// resets the rectmode, because thats whats used to draw players
    }
  }
  
  void update(Point p)
  {
    //Updates all the buttons on the menu. For checking hovering and click of button with mouse.
    for (int i = 0; i < buttons.length; i++)
    {
      buttons[i].update(p); 
    }
  }
}

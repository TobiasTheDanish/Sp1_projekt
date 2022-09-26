//Global variables
Ball[] balls = new Ball[5];
int currentNumBalls = 1;
Player p1;
Player p2;
Timer ballTimer;
GameStateManager stateManager = new GameStateManager();
GameMenu startMenu;
GameMenu gameOverMenu;

//Constants (of finals?)
final Point PLAYERSIZE = new Point(50, 200);
final float PLAYERSPEED = 10;
final float BALLSPEED = 8;
final color STDCOLOR = color(0, 100, 0);

//Processing functions
void setup()
{
  size (1500, 1000);
  init();
}

void draw()
{
  display();
  update();
}

//Custom functions
void init()
{
  fill(STDCOLOR); //Sets the standard fill color for all the objects.
  initFirstBall();
  initPlayers();
  initTimer();
  initMenus();
  stateManager.setState(0); //Set state to GameSetup state
}

void initFirstBall()
{
  //Initializes the first ball in the balls array, with a position, radius, velocity, and speed
  balls[0] = new Ball(new Point(width/2, height/2), 25, new Point(random(-1, 1.01), random(0.75, 1.01)), BALLSPEED, STDCOLOR);
}

void initPlayers()
{
  //Initializes two new player objects, with a position, a size and a speed.
  p1 = new Player(new Point(100, height/2 - PLAYERSIZE.y/2), PLAYERSIZE, PLAYERSPEED, STDCOLOR);
  p2 = new Player(new Point(width - 100, height/2 - PLAYERSIZE.y/2), PLAYERSIZE, PLAYERSPEED, STDCOLOR);
}

void initTimer()
{
  ballTimer = new Timer(20); //Initializes a new Timer object, with a timer of 20 seconds
}

void initMenus()
{
   String[] startMenuText = {"Controls", "'W' and 'S' move player 1", "'UP' and 'DOWN' arrows move player 2"};
   Point buttonSize = new Point(200,100);
   String[] buttonText = new String[] {"Ready", "Exit"};
   ClickHandler[] startMenuHandlers = new ClickHandler[] {
                                           new ClickHandler(){
                                             public void onClickEvent(){
                                               startMenu.menuIsVisible = false; 
                                             }
                                           },
                                           new ClickHandler(){
                                             public void onClickEvent(){
                                               exit();
                                             }
                                           } 
                                      };
   startMenu = new GameMenu(new Point(width/2, height/2), new Point(width/1.5, height/1.5), startMenuText, 60, true, buttonSize, buttonText, startMenuHandlers); 
   
   String[] gameOverText = {"GAME OVER!", "", "Do you wish to play again?"};
   String[] gameOverButtonText = new String[] {"Play again", "Exit"};
   ClickHandler[] gameOverHandlers = new ClickHandler[] {
                                           new ClickHandler(){
                                             public void onClickEvent(){
                                               hardReset();
                                               gameOverMenu.menuIsVisible = false; 
                                             }
                                           },
                                           new ClickHandler(){
                                             public void onClickEvent(){
                                               exit();
                                             }
                                           } 
                                      };
   gameOverMenu = new GameMenu(new Point(width/2, height/2), new Point(width/1.5, height/1.5), gameOverText, 60, false, buttonSize, gameOverButtonText, gameOverHandlers); 
}

void display()
{
  background(0);
  fill(STDCOLOR); //Sets the standard fill color for all the objects.
  displayBalls();
  displayPlayers();
  displayText();
  displayMenus();
}

void displayBalls()
{
  for (int i = 0; i < currentNumBalls; i++)
  {
    balls[i].display();
  }
}

void displayPlayers()
{
  p1.display();
  p2.display();
}

void displayText()
{
  if (stateManager.getState() == 0)
  {
    textSize(80);
    textAlign(CENTER);
    text("Press 'P' to start", width/2, 400);
    textSize(100);
    textAlign(CENTER);
    String scoreText = p1.score + " : " + p2.score;
    text(scoreText, width/2, 200);
  }
  else if (stateManager.getState() == 1)
  {
    textSize(100);
    textAlign(CENTER);
    String scoreText = p1.score + " : " + p2.score;
    text(scoreText, width/2, 200);
  }
}

void displayMenus()
{
  startMenu.display();
  gameOverMenu.display();
}

void update()
{
  //ballTimer.printTimer();
  updateMenus();
  if (stateManager.getState() == 1)
  {
    updateBalls();
    updatePlayers();
    updateText();
  }
}

void updateBalls()
{
  if (ballTimer.isFinished() && currentNumBalls < balls.length)
  {
    balls[currentNumBalls] = new Ball(new Point(width/2, height/2), 25, new Point(random(-1, 1.01), random(0.75, 1.01)), BALLSPEED, STDCOLOR);
    currentNumBalls++;
    ballTimer.begin();
  }
  
  for (int i = 0; i < currentNumBalls; i++)
  {
    if (balls[i].velocity.x < 0)
    {
      p1.ballHit(balls[i]);
    }
    else if (balls[i].velocity.x >= 0)
    {
      p2.ballHit(balls[i]);
    }
  
    balls[i].move();
    
    if (balls[i].hitLeftOrRightWall)
    {
      currentNumBalls = 1;
      ballTimer.begin();
    }
  }
}

void updatePlayers()
{
  p1.move();
  p2.move();
}

void updateText()
{
  if (stateManager.getState() == 1)
  {
    for (int i = 0; i < currentNumBalls; i++)
    {
      if (balls[i].hitLeftBorder())
      {
        p2.score++;
        if (p2.score >= 5)
        {
          gameOverMenu.menuText[1] = "Player 2 won!";
          gameOverMenu.menuIsVisible = true;
          stateManager.setState(2); 
        }
        else
        {
          stateManager.setState(0);
          softReset();
        }
      }
      else if (balls[i].hitRightBorder())
      {
        p1.score++;
        if (p1.score >= 5)
        {
          gameOverMenu.menuText[1] = "Player 1 won!";
          gameOverMenu.menuIsVisible = true;
          stateManager.setState(2); 
        }
        else
        {
          stateManager.setState(0);
          softReset();
        }
      }
    }
  }
}

void updateMenus()
{
  if (stateManager.getState() == 0 && startMenu.menuIsVisible)
  {
    startMenu.update(new Point(mouseX, mouseY));
  }
  
  if (stateManager.getState() == 2 && gameOverMenu.menuIsVisible)
  {
    gameOverMenu.update(new Point(mouseX, mouseY));
  }
}

//Used to reset after a round has ended with one of the players gaining a point.
void softReset()
{
  //Resets number of active balls to 1, and initializes the first one.
  currentNumBalls = 1;
  initFirstBall();
  
  //Resets the players position, to the starting position.
  p1.resetPos();   
  p2.resetPos();
}

//Used to reset the game when it has ended
void hardReset()
{
  //Reset all of the objects, by assigning them to new objects
  currentNumBalls = 1;
  initFirstBall();
  initPlayers();
  initTimer();
  stateManager.setState(0); //Reset state to GameSetup state
}

// Processing key events
void keyPressed()
{
  if (stateManager.getState() == 0)
  {
    if (key == 'p' || key == 'P')
    {
      stateManager.setState(1);
      ballTimer.begin(); //Starts the 20 second timer 
    }
  }
  
  if (stateManager.getState() == 1)
  {
    if (key == 'w')
    {
      p1.velocity.y = -1;
    } else if (key == 's')
    {
      p1.velocity.y = 1;
    }
  
    if (key == CODED)
    {
      if (keyCode == UP)
      {
        p2.velocity.y = -1;
      } else if (keyCode == DOWN)
      {
        p2.velocity.y = 1;
      }
    }
  }
}

void keyReleased()
{
  if (key == 'w' || key == 's')
  {
    p1.velocity.y = 0;
  }

  if (key == CODED)
  {
    if (keyCode == UP || keyCode == DOWN)
    {
      p2.velocity.y = 0;
    }
  }
}

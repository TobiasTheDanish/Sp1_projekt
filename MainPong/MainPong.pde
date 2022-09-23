//Global variables
Ball[] balls = new Ball[5];
int currentNumBalls = 1;
Player p1;
Player p2;
Timer ballTimer;
int tSize = 80;
boolean textSizeIncreasing = true;
GameStateManager stateManager = new GameStateManager();

//Constants (of finals?)
final Point PLAYERSIZE = new Point(50, 200);
final float PLAYERSPEED = 10;
final float BALLSPEED = 8;

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
  fill(0, 100, 0); //Sets the fill color for all the objects, since this i never changed.
  initFirstBall();
  initPlayers();
  initTimer();
  stateManager.setState(0);
}

void initFirstBall()
{
  balls[0] = new Ball(new Point(width/2, height/2), 25, new Point(1, -1), BALLSPEED);
}

void initPlayers()
{
  p1 = new Player(new Point(100, height/2 - PLAYERSIZE.y/2), PLAYERSIZE, PLAYERSPEED);
  p2 = new Player(new Point(width - 100, height/2 - PLAYERSIZE.y/2), PLAYERSIZE, PLAYERSPEED);
}

void initTimer()
{
  ballTimer = new Timer(20);
  ballTimer.begin();
}

void display()
{
  background(0);
  displayBalls();
  displayPlayers();
  displayText();
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
    textSize(tSize);
    text("Press enter to start", width/2-325, 200);
  }
  else if (stateManager.getState() == 1)
  {
    textSize(tSize);
    String scoreText = p1.score + " : " + p2.score;
    text(scoreText, width/2-75, 200);
  }
}

void update()
{
  if (stateManager.getState() == 1)
  {
    //ballTimer.printTimer();
    updateBalls();
    updatePlayers();
    updateText();
  }
}

void updateBalls()
{
  if (ballTimer.isFinished() && currentNumBalls < balls.length)
  {
    balls[currentNumBalls] = new Ball(new Point(width/2, height/2), 25, new Point(1, -1), BALLSPEED);
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
  if (stateManager.getState() == 0)
  {
     if (tSize == 90)
     {
       textSizeIncreasing = false;
     }
     else
     {
       textSizeIncreasing = true; 
     }
     
     if (textSizeIncreasing)
     {
       tSize++; 
     }
     else
     {
       tSize--;
     }
     
     println(tSize);
  }
  else if (stateManager.getState() == 1)
  {
    tSize = 100;
    for (int i = 0; i < currentNumBalls; i++)
    {
      if (balls[i].hitLeftBorder())
      {
        p2.score++;
        if (p2.score >= 5)
        {
          stateManager.setState(2); 
        }
        else
        {
          stateManager.setState(0);
          reset();
        }
      }
      else if (balls[i].hitRightBorder())
      {
        p1.score++;
        if (p1.score >= 5)
        {
          stateManager.setState(2); 
        }
        else
        {
          stateManager.setState(0);
          reset();
        }
      }
    }
  }
}

void reset()
{
   currentNumBalls = 1;
   initFirstBall();
   p1.reset(new Point(100, height/2 - PLAYERSIZE.y/2));
   p2.reset(new Point(width - 100, height/2 - PLAYERSIZE.y/2));
}

// Processing key events
void keyPressed()
{
  if (stateManager.getState() == 0)
  {
    if (key == 'p')
    {
      stateManager.setState(1);
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

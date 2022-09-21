//Global variables
Ball[] balls = new Ball[5];
int currentNumBalls = 1;
Player p1;
Player p2;
Timer ballTimer;

//Constant
Point PLAYERSIZE = new Point(50, 200);
float PLAYERSPEED = 10;
float BALLSPEED = 10;

//Processing functions
void setup()
{
  size (1500, 1000);

  fill(0, 100, 0);
  balls[0] = new Ball(new Point(width/2, height/2), 25, new Point(1, -1), BALLSPEED);
  p1 = new Player(new Point(100, height/2 - PLAYERSIZE.y/2), PLAYERSIZE, PLAYERSPEED);
  p2 = new Player(new Point(width - 100, height/2 - PLAYERSIZE.y/2), PLAYERSIZE, PLAYERSPEED);
  ballTimer = new Timer(20);
  ballTimer.begin();
}

void draw()
{
  display();
  update();
}

//Custom functions
void display()
{
  background(0);
  for (int i = 0; i < currentNumBalls; i++)
  {
    balls[i].display();
  }
  p1.display();
  p2.display();
}

void update()
{
  ballTimer.printTimer();
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
  p1.move();
  p2.move();
}

// Processing key events
void keyPressed()
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

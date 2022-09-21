//Global variables
Ball[] balls = new Ball[5];
int currentNumBalls = 1;
Player p1;
Player p2;
Timer ballTimer;

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
  initScoreText();
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

void initScoreText()
{
  textSize(100);
  displayScore();
}

void display()
{
  background(0);
  displayBalls();
  displayPlayers();
  displayScore();
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

void displayScore()
{
  String scoreText = p1.score + " : " + p2.score;
  text(scoreText, width/2-75, 200);
}

void update()
{
  ballTimer.printTimer();
  updateBalls();
  updatePlayers();
  updateScore();
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

void updateScore()
{
  for (int i = 0; i < currentNumBalls; i++)
  {
    if (balls[i].hitLeftBorder())
    {
      p2.score++; 
    }
    else if (balls[i].hitRightBorder())
    {
      p1.score++;
    }
  }
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

//Global variables
Ball[] balls = new Ball[5]; //An array of balls with a size of 5 (making 5 the maximum number of balls
int currentNumBalls = 1; //used to control the number of balls that is updated and displayed in the balls array above.

//The two player objects
Player p1;
Player p2;

Timer ballTimer; //A timer to keep track of when a new ball should spawn.

GameStateManager stateManager = new GameStateManager(); //An object used to keep track of the current state of the game

Scoreboard scoreboard; // An object for display the current score on the screen

//Two menu screens for when the game starts and when the game ends
GameMenu startMenu;
GameMenu gameOverMenu;

//Constants (or finals?)
final Point PLAYERSIZE = new Point(50, 200);
final float PLAYERSPEED = 10;
final float BALLSPEED = 12;
final color STDCOLOR = color(0, 100, 0);

//Processing functions
void setup()
{
  size (2000, 1250);
  //fullScreen();
  //Initialize all the objects in the game
  init();
}

void draw()
{
  //First draw all of the objects to the screen, and then update them for the next frame
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
  scoreboard = new Scoreboard(new Point(width/2, height*0.2), new Point(width/6, height/6), height*0.1, STDCOLOR);
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
  //Initialize the two menus objects
  //Create variables to use in the GameMenu constructor, for a more readable constructor.
  //The text that will show in the menu
  String[] startMenuText = {"Controls", "'W' and 'S' move player 1", "'UP' and 'DOWN' arrows move player 2"}; 
  
  //width and height of buttons on menu
  Point buttonSize = new Point(height*0.2, height*0.1);
  
  //Text to display on the buttons
  String[] buttonText = new String[] {"Ready", "Exit"};
  
  //Callback functions for button click event. Using lambda expression for more concise code. Link to learning resource: https://www.youtube.com/watch?v=tj5sLSFjVj4&t=668s
  ClickHandler[] startMenuHandlers = new ClickHandler[] 
  { 
    () -> 
    { 
      startMenu.menuIsVisible = false; 
    }, 
    () -> 
    { 
      exit(); 
    } 
  };
  
  //Attributes that the values represent: Menu position,       Menu width and height                    textSize,   isMenuVisible
  startMenu = new GameMenu(new Point(width/2, height/2), new Point(width/1.5, height/1.5), startMenuText, 60,         true, buttonSize, buttonText, startMenuHandlers);
  
  //Create variables to use in the GameMenu constructor, for a more readable constructor.
  //The text that will show in the menu
  String[] gameOverText = {"GAME OVER!", "", "Do you wish to play again?"};
  
  //Text to display on the buttons
  String[] gameOverButtonText = new String[] {"Play again", "Exit"};
  
  //Callback functions for button click event. Using lambda expressions for more concise code. Link to learning resource: https://www.youtube.com/watch?v=tj5sLSFjVj4&t=668s
  ClickHandler[] gameOverHandlers = new ClickHandler[] 
  { 
    () -> 
    {
      hardReset();
      gameOverMenu.menuIsVisible = false; 
    }, 
    () -> 
    { 
      exit(); 
    } 
  };

  //Attributes that the values represent: Menu position,       Menu width and height                      textSize,   isMenuVisible
  gameOverMenu = new GameMenu(new Point(width/2, height/2), new Point(width/1.5, height/1.5), gameOverText, 60,         false, buttonSize, gameOverButtonText, gameOverHandlers);
}

void display()
{
  //Display all objects on the screen
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
    //Draws all the active balls on screen
    balls[i].display();
  }
}

void displayPlayers()
{
  //Draws the players on screen
  p1.display();
  p2.display();
}

void displayText()
{
  //Display the scoreboard, in following format: "0:0".
  scoreboard.display(); //Always display this text

  if (stateManager.getState() == 0)// if the game is in the GameSetup state, which is used at start or when a point has been score
  {
    textSize(height*0.08); //Makes the textsize scale with screen height
    textAlign(CENTER); //changes the position of the text to be in the middle of the text, instead of the top left corner
    text("Press 'P' to start", width/2, height*0.4); //Displays text on screen
  } 
  else if (stateManager.getState() == 1)
  {
    ballTimer.display("New ball in:"); //Displays when a new ball is about to spawn
  }
}

void displayMenus()
{
  //Displays each menu, if the objects menuIsVisible attribute is set to true
  startMenu.display();
  gameOverMenu.display();
}

void update()
{
  //updates all the objects attributes to keep the game dynamic
  updateMenus();
  
  if (stateManager.getState() == 1) //Only update the balls, players and screen text when the game state is GameIsRunning 
  {
    updateBalls();
    updatePlayers();
    updateText();
  }
}

void updateBalls()
{
  //If its time to spawn a new ball, and the number of active balls is less than the maximum amount of balls
  //Then initialize a new ball object, and increase the count of active balls (currentNumBalls)
  if (ballTimer.isFinished() && currentNumBalls < balls.length)
  {
    balls[currentNumBalls] = new Ball(new Point(width/2, height/2), 25, new Point(random(-1, 1.01), random(0.75, 1.01)), BALLSPEED, STDCOLOR);
    currentNumBalls++;
    ballTimer.begin();
  }

  
  for (int i = 0; i < currentNumBalls; i++)
  {
    //for every active ball check if it has hit a player.
    if (balls[i].velocity.x < 0)
    {
      p1.ballHit(balls[i]);
    } else if (balls[i].velocity.x >= 0)
    {
      p2.ballHit(balls[i]);
    }

    //then move the ball
    balls[i].move();
  }
}

void updatePlayers()
{
  //update each players position.
  p1.move();
  p2.move();
}

void updateText() //updates the scoreboard and checks whether a player has won.
{
  if (stateManager.getState() == 1) // if game state is GameIsRunning
  {
    for (int i = 0; i < currentNumBalls; i++) //loop through all the active balls
    {
      if (balls[i].hitLeftBorder())
      {
        p2.score++; //increase player 2's score if a ball hits the left border
        if (p2.score >= 5)
        {
          //Player 2 wins if their score is 5 or greater.
          gameOverMenu.menuText[1] = "Player 2 won!"; //display on game over screen that player 2 won
          gameOverMenu.menuIsVisible = true; //display game over screen
          stateManager.setState(2); //set game state to GameEnded
        } else
        { 
          //Player 2 haven't won, so start a new round
          stateManager.setState(0);
          softReset();
        }
      } else if (balls[i].hitRightBorder())
      {
        p1.score++; //increase player 1's score if a ball hits the left border
        if (p1.score >= 5)
        {
          //Player 1 wins if their score is 5 or greater.
          gameOverMenu.menuText[1] = "Player 1 won!"; //display on game over screen that player 1 won
          gameOverMenu.menuIsVisible = true; //display game over screen
          stateManager.setState(2);//set game state to GameEnded
        } else
        {
          //Player 1 haven't won, so start a new round
          stateManager.setState(0);
          softReset();
        }
      }
    }
  }
  
  //Updates the scoreboard
  scoreboard.update(p1.score, p2.score);
}

void updateMenus()
{
  //If start menu is visible and game state is GameSetup
  //Check if the mouse is over or clicking one of the buttons on the menu.
  if (stateManager.getState() == 0 && startMenu.menuIsVisible)
  {
    startMenu.update(new Point(mouseX, mouseY));
  }
  
  //If game over menu is visible and game state is GameEnded
  //Check if the mouse is over or clicking one of the buttons on the menu.
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
  //Restarts the ball spawning timer
  ballTimer.begin();

  //Resets the players position, to the starting position.
  p1.resetPos();
  p2.resetPos();
}

//Used to reset the game when it has ended, and the "Play again" button has been clicked
void hardReset()
{
  //Reset all of the objects, by initializing them again
  currentNumBalls = 1;
  initFirstBall();
  initPlayers();
  initTimer();
  scoreboard.update(p1.score, p2.score); //updates scoreboard values
  stateManager.setState(0); //Reset state to GameSetup state
}

// Processing key events
void keyPressed()
{
  if (stateManager.getState() == 0)
  {
    if (key == 'p' || key == 'P')
    {
      stateManager.setState(1); //Sets game state to GameIsRunning, making objects update
      ballTimer.begin(); //Starts the 20 second timer
    }
  }

  //Check for input for player movement if the game is running
  if (stateManager.getState() == 1)
  {
    if (key == 'w')
    {
      //if w is pressed, move player 1 up
      p1.velocity.y = -1;
    } 
    else if (key == 's')
    {
      //if s is pressed, move player 1 down
      p1.velocity.y = 1;
    }

    if (key == CODED)
    {
      if (keyCode == UP)
      {
        //if up arrow is pressed, move player 2 up
        p2.velocity.y = -1;
      } 
      else if (keyCode == DOWN)
      {
        //if down arrow is pressed, move player 2 down
        p2.velocity.y = 1;
      }
    }
  }
}

void keyReleased()
{
  if (key == 'w' || key == 's')
  {
    //Dont move player 1 if w or s is not pressed
    p1.velocity.y = 0;
  }

  if (key == CODED)
  {
    if (keyCode == UP || keyCode == DOWN)
    {
      //Dont move player 2 if up or down arrow is not pressed
      p2.velocity.y = 0;
    }
  }
}

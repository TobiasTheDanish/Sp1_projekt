//class used to update and display the scoreboard on screen
class Scoreboard
{
  Point pos;
  Point dimensions;
  float textSize;
  int score1, score2;
  color c;
  
  Scoreboard(Point pos, Point dimensions, float textSize, color c)
  {
    this.pos = pos;
    this.dimensions = dimensions;
    this.textSize = textSize;
    this.c = c;
    this.score1 = 0;
    this.score2 = 0;
  }
  
  void display()
  {
    //Draws border around score text
    rectMode(CENTER);
    noFill();
    stroke(c);
    rect(pos.x, pos.y, dimensions.x, dimensions.y);
    
    //Display scoreboard text
    textSize(textSize);
    textAlign(CENTER, CENTER); //changes the position of the text to be in the middle of the text, instead of the top left corner
    String scoreText = score1 + " : " + score2; //Formats the score text. "0:0"
    text(scoreText, pos.x, pos.y - dimensions.y/8, dimensions.x, dimensions.y); //Displays text on screen
  }
  
  void update(int score1, int score2)
  {
    //Updates the score attributes so that the text will update
    this.score1 = score1;
    this.score2 = score2;
  }
}

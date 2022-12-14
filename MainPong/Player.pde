class Player //<>//
{
  //Player attributes
  Point pos;
  final Point startPos;
  Point velocity;
  Point dimensions;
  float speed;
  color c;
  int score;

  Player(Point p, Point d, float s, color _c)
  {
    //Set player attributes
    startPos = p;
    pos = new Point(startPos.x, startPos.y);
    velocity = new Point(0.0f, 0.0f);
    dimensions = d;
    speed = s;
    c = _c;
    score = 0;
  }

  void display()
  {
    //Draw the player rect
    rectMode(CORNER);
    fill(c);
    noStroke();
    rect(pos.x, pos.y, dimensions.x, dimensions.y);
  }

  void move()
  {
    //Dont allow the player to move up if the top has been hit, or to move down and when the bottom has been hit
    if (velocity.y < 0 && hitTopBorder()  || velocity.y > 0 && hitBottomBorder())
    {
      velocity.y = 0;
    }

    //move the player along the x and y axis
    pos.x += velocity.x * speed;
    pos.y += velocity.y * speed;
  }
  
  void resetPos()
  {
    pos = new Point(startPos.x, startPos.y); //Creates a new objects to make sure that startPos remains the same.
  }

  void ballHit(Ball b)
  {
    //By using a moving center i try minimize the amount of missed collisions.
    //Calculates the moving center of the player's x pos.
    float rectCenterX = b.pos.x;
    rectCenterX = constrainFloat(rectCenterX, pos.x, pos.x + dimensions.x);
    
    //Calculates the moving center of the player's x pos.
    float rectCenterY = b.pos.y;
    rectCenterY = constrainFloat(rectCenterY, pos.y, pos.y + dimensions.y);

    // Calculates the vector between the ball pos, and the moving center of the player
    Point vecA = calcVector(rectCenterX, rectCenterY, b.pos.x, b.pos.y);
    //Calculates the unit vector of the vector.
    Point unit = calcUnitVector(vecA);
    //collisionPoint is the point on the balls circumference where it is likely to collide with the player
    Point collisionPoint = new Point(b.pos.x + unit.x * b.radius, b.pos.y + unit.y * b.radius);
    
    if (isInsideRect(pos.x, pos.y, dimensions.x, dimensions.y, collisionPoint.x, collisionPoint.y))
    {
      if (isInRange(rectCenterX - 0.1f, rectCenterX + 0.1f, b.pos.x)) //checks if the ball hits the player on the left or right side
      {
        //Creates variation in the way the ball bounces of the player, depending on how far the ball is from the middle of the player
        Point unitDirectionToCenter = calcUnitVector(calcVector(pos.x + dimensions.x/2, pos.y + dimensions.y/2, b.pos.x, b.pos.y));
        b.velocity.y *= constrainFloat((abs(unitDirectionToCenter.y) * -1), -1, -0.75);
      }
      else if (isInRange(rectCenterY - 0.1f, rectCenterY + 0.1f, b.pos.y)) //checks if the ball hits the player on the top or bottom
      {
        //Creates variation in the way the ball bounces of the player, depending on how far the ball is from the middle of the player
        Point unitDirectionToCenter = calcUnitVector(calcVector(pos.x + dimensions.x/2, pos.y + dimensions.y/2, b.pos.x, b.pos.y));
        b.velocity.x *= constrainFloat((abs(unitDirectionToCenter.x) * -1), -1, -0.75);
      }
      else if (isInRange(rectCenterX - 0.1f, rectCenterX + 0.1f, b.pos.x) && isInRange(rectCenterY - 0.1f, rectCenterY + 0.1f, b.pos.y)) //checks if the ball hits the player on one of the corners
      {
        //Creates variation in the way the ball bounces of the player, depending on how far the ball is from the middle of the player
        Point unitDirectionToCenter = calcUnitVector(calcVector(pos.x + dimensions.x/2, pos.y + dimensions.y/2, b.pos.x, b.pos.y));
        b.velocity.x *= constrainFloat((abs(unitDirectionToCenter.x) * -1), -1, -0.75);
        b.velocity.y *= constrainFloat((abs(unitDirectionToCenter.y) * -1), -1, -0.75);
      }
      
      //Moves the ball out of the player after collision
      b.pos.x -= collisionPoint.x - rectCenterX;
      b.pos.y -= collisionPoint.y - rectCenterY;
    }
      
    
    /* The following lines is for debugging purposes only
       rectMode(CENTER);
       rect(rectCenterX, rectCenterY, 20, 20);
       rectMode(CORNER);
       ellipse(b.pos.x + unit.x * b.radius, b.pos.y + unit.y * b.radius, 20, 20);
    */
  }

  //Returns the constrained value between min and max of the toConstrain parameter
  float constrainFloat(float toConstrain, float min, float max)
  {
    if (toConstrain > max)
    {
      toConstrain = max;
    } 
    else if (toConstrain < min)
    {
      toConstrain = min;
    }
    
    return toConstrain;
  }
  
  //return a vector based on 2 points
  Point calcVector(float xa, float ya, float xb, float yb)
  {
      return new Point(xa-xb, ya-yb);
  }
  
  //returns a vector with a magnitude of 1
  Point calcUnitVector(Point vec)
  {
    float Mag = sqrt((vec.x*vec.x) + (vec.y*vec.y));
    return new Point(vec.x/Mag, vec.y/Mag);
  }

  //Used to constrain the players movement
  //Returns true if the player hits the top border of the screen
  boolean hitTopBorder()
  {
    float rectCenterX = pos.x + dimensions.x / 2;

    return isInsideRect(pos.x, pos.y, dimensions.x, dimensions.y, rectCenterX, 0);
  }

  //Used to constrain the players movement
  //Returns true if the player hits the bottom border of the screen
  boolean hitBottomBorder()
  {
    float rectCenterX = pos.x + dimensions.x / 2;

    return isInsideRect(pos.x, pos.y, dimensions.x, dimensions.y, rectCenterX, height);
  }

  //Used to check if player hits top border or bottom border, and if the ball hits the player.
  //Checks whether a given point(px, py) is within a rect with the given values(rcx, rcy, w, h)
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

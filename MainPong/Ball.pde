class Ball
{
  Point pos;
  float radius;
  Point velocity;
  float speed;
  color c;
  boolean hitLeftOrRightWall;

  Ball(Point _pos, float _radius, Point _velocity, float _speed, color _c)
  {
    pos = _pos;
    radius = _radius;
    velocity = _velocity;
    speed = _speed;
    c = _c;
    hitLeftOrRightWall = false;
  }

  //Function to display ball on screen. Using the standard ellipseMode of CENTER
  void display()
  {
    fill(c);
    noStroke();
    ellipse(pos.x, pos.y, radius * 2, radius * 2);
  }

  void move()
  { 
    borderChecks();
    
    //Calculate the velocity as a unit vector(A magnitude of 1), to make sure it always moves at the same speed.
    Point unitVelocity = calcUnitVector(velocity);

    //Change the ball's x and y pos to make it move around the screen.
    pos.x += unitVelocity.x * speed;
    pos.y += unitVelocity.y * speed;
  }
  
  void borderChecks()
  {
    hitLeftOrRightWall = false; //Resets this variable every frame, so it wont be true two frames in a row.
    
    if (hitLeftBorder() || hitRightBorder())
    {
      //Reset the ball's position if it has hit one of the side walls.
      pos.x= width/2;
      pos.y = height/2;
      
      //Swap the velocity to have the ball move the opposite way.
      velocity.x *= -1;
      
      //If the ball have hit a wall, we reset the number of active balls in MainPong,
      //for this we use the following boolean.
      hitLeftOrRightWall = true;
    }

    if (hitTopBorder() || hitBottomBorder())
    {
      //Flip y velocity to keep the ball within the screen.
      velocity.y *= -1;
      
      //Move the ball away from the border it hit, so i doesnt get stuck.
      if (hitTopBorder())
      {
        pos.y += abs(pos.y-radius);
      }
      else
      {
        pos.y -= abs(pos.y + radius - height); 
      }
      
      //Check if the ball is moving slower on the x axis than wanted and then increment (or decrement) it.
      if (velocity.x < 0 && velocity.x > -0.60)
      {
        velocity.x -= 0.1; 
      }
      else if (velocity.x > 0 && velocity.x < 0.60)
      {
        velocity.x += 0.1;
      }
    }
  }
  
  Point calcUnitVector(Point vec)
  {
    float Mag = sqrt((vec.x*vec.x) + (vec.y*vec.y));
    return new Point(vec.x/Mag, vec.y/Mag);
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

  //Returns true if the ball hits the top border of the screen
  boolean hitTopBorder()
  {
    return isInsideCircle(pos.x, pos.y, radius, pos.x, 0);
  }
  
  //Returns true if the ball hits the bottom border of the screen
  boolean hitBottomBorder()
  {
    return isInsideCircle(pos.x, pos.y, radius, pos.x, height);
  }
  
  //Returns true if the ball hits the left border of the screen
  boolean hitLeftBorder()
  {
    return isInsideCircle(pos.x, pos.y, radius, 0, pos.y);
  }
  
  //Returns true if the ball hits the right border of the screen
  boolean hitRightBorder()
  {
    return isInsideCircle(pos.x, pos.y, radius, width, pos.y);
  }

  //Used to check if ball hits a border of screen or the player.
  //Checks whether a given point(px, py) is within a circle with the given values (cx,cy,r)
  boolean isInsideCircle(float cx, float cy, float r, float px, float py)
  {
    return distance(cx, cy, px, py) <= r;
  }
  
  //Returns the distance between to points, using pythagoras theorem.
  float distance(float p1x, float p1y, float p2x, float p2y)
  {
    float a = abs(p1x-p2x);
    float b = abs(p1y-p2y);
    return sqrt(a*a + b*b);
  }
}

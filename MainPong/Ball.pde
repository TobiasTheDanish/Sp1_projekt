class Ball
{
  Point pos;
  float radius;
  Point velocity;
  float speed;
  boolean hitLeftOrRightWall;

  Ball(Point _pos, float _radius, Point _velocity, float _speed)
  {
    pos = _pos;
    radius = _radius;
    velocity = _velocity;
    speed = _speed;
    hitLeftOrRightWall = false;
  }

  //Function to display ball on screen
  void display()
  {
    ellipse(pos.x, pos.y, radius * 2, radius * 2);
  }

  void move()
  { 
    hitLeftOrRightWall = false;
    
    if (velocity.y < 1.0f && velocity.y > 0.0f)
    {
      velocity.y += .1f;
    }
    else if (velocity.y > -1.0f && velocity.y <= 0.0f)
    {
      velocity.y -= .1f;
    }
    
    if (hitLeftBorder() || hitRightBorder())
    {
      pos.x= width/2;
      pos.y = height/2;
      velocity.x *= -1;
      hitLeftOrRightWall = true;
    }

    if (hitTopBorder() || hitBottomBorder())
    {
      velocity.y *= -1;
    }

    pos.x += velocity.x * speed;
    pos.y += velocity.y * speed;
  }
  
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

  boolean hitTopBorder()
  {
    return isInsideCircle(pos.x, pos.y, radius, pos.x, 0);
  }
  boolean hitBottomBorder()
  {
    return isInsideCircle(pos.x, pos.y, radius, pos.x, height);
  }
  boolean hitLeftBorder()
  {
    return isInsideCircle(pos.x, pos.y, radius, 0, pos.y);
  }
  boolean hitRightBorder()
  {
    return isInsideCircle(pos.x, pos.y, radius, width, pos.y);
  }


  float distance(float p1x, float p1y, float p2x, float p2y)
  {
    float a = abs(p1x-p2x);
    float b = abs(p1y-p2y);
    return sqrt(a*a + b*b);
  }

  boolean isInsideCircle(float cx, float cy, float r, float px, float py)
  {
    return distance(cx, cy, px, py) <= r;
  }
}

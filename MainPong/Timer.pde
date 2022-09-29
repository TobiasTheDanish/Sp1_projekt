class Timer
{
  float startTime;
  float timeInMillis;
  
  Timer(float timeInSeconds)
  {
     timeInMillis = timeInSeconds * 1000;
  }
  
  //Resets the timer, and uses the current timeInMillis.
  void begin()
  {
    startTime = millis();
  }
  
  //Resets the timer, and set timeInMillis to a new value.
  void beginAndSet(float timeInSeconds)
  {
    startTime = millis();
    timeInMillis = timeInSeconds * 1000;
  }
  
  void display(String text)
  {
    float timeLeft = startTime - (millis()-timeInMillis);
    
    //only display the timer if there is less than 3 seconds left
    if (timeLeft < 3000.0f)
    {
       //Display message text, that gets passed in as parameter
       textSize(60);
       fill(0,100,0);
       textAlign(CENTER,CENTER);
       text(text, width/2, height/2 - height/8);
       
       //Display timer text
       textSize(100);
       String timeLeftStr = Integer.toString((int)(timeLeft/1000)+1);
       text(timeLeftStr, width/2, height/2 - height/16);
    }
  }
  
  //Used for debugging, prints the time left on the timer to the console.
  void printTimer()
  {
    float timeLeft = startTime - (millis()-timeInMillis);
    println("Time left: " + timeLeft/1000);
  }
  
  //Returns true if the timer has run out
  boolean isFinished()
  {
    return startTime < millis() - timeInMillis; 
  }
}

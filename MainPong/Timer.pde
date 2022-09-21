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

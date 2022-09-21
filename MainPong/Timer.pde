class Timer
{
  float startTime;
  float timeInMillis;
  
  Timer(float timeInSeconds)
  {
     timeInMillis = timeInSeconds * 1000;
  }
  
  void begin()
  {
    startTime = millis();
  }
  
  void beginAndSet(float timeInSeconds)
  {
    startTime = millis();
    timeInMillis = timeInSeconds * 1000;
  }
  
  void printTimer()
  {
    float timeLeft = startTime - (millis()-timeInMillis);
    println("Time left: " + timeLeft/1000);
  }
  
  boolean isFinished()
  {
    return startTime < millis() - timeInMillis; 
  }
}

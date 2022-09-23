class GameStateManager
{
  /*
  * 0 = GameSetup
  * 1 = GameIsRunning
  * 2 = GameEnded
  */
  private int _state = -1; 
  
  public int getState()
  {
    return _state;
  }
  
  public void setState(int state)
  {
    _state = state;
  }
}

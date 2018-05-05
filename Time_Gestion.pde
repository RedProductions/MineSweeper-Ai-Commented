//curent refresh's time
float currentTime = 0;
//last refresh's time
float pastTime = 0;

//time when the game started
float startingTime = 0;
//current playing time
float gameTime = 0;

//flag to indicate if the game is in progress (to know if the gameTime must keep up with the current time)
boolean playing = false;

//amount of time the win message has been shown
float finishTime = 0;
//amount of time the win message must be shown
float showFinishTime = 3 * 1000;

//update the time
void timeCalc(){
  
  //last refresh's time is not the current refresh's time
  pastTime = currentTime;
  //get the new current refresh's time
  currentTime = millis();
  
  //only increase the playing time if the game is in progress
  if(playing){
    gameTime = currentTime - startingTime;
  }
  
}
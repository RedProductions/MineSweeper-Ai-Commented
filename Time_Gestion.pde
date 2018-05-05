float currentTime = 0;
float pastTime = 0;

float startingTime = 0;
float gameTime = 0;

boolean playing = false;

float finishTime = 0;
float showFinishTime = 3 * 1000;

void timeCalc(){
  
  pastTime = currentTime;
  currentTime = millis();
  
  if(playing){
    gameTime = currentTime - startingTime;
  }
  
}
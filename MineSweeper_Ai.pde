void setup(){
  
  fullScreen();
  
  //pixel size of cases
  caseSizeX = width/GAME_SIZE_X;
  caseSizeY = (height - EDGE_HEIGHT)/GAME_SIZE_Y;
  
  //select smallest size to fit text
  if(caseSizeX < caseSizeY){
    font = createFont("STENCIL.TTF", caseSizeX);
  }else {
    font = createFont("STENCIL.TTF", caseSizeY); 
  }
  
  //create the game and both AIs
  player = new Ai();
  game = new Game();
  guesser = new Chance();
  
  
  textAlign(CENTER, CENTER);
  
}


void draw(){
  
  background(170);
  textFont(font);
    
    //update time
    timeCalc();
    
    //update the game
    game.update();
    
    //show the game
    game.show();
    
    if(!game.is_alive()){
      playing = false;
      game_over(game.has_won());
      if(game.has_won()){
        //if the AI won, after the set time, the game resets
        if(currentTime - finishTime >= showFinishTime){
          game = new Game();
          player = new Ai();
        }
        //if hte AI lost or the user resets the game
      }else if(game.can_Restart() || (!game.has_won() && AI_TRY)){
        lostAmount++;
        game = new Game();
        player = new Ai();
      }
    }else {
      //show stats only if the game is active
      showStats();
    }
    
    //player AI makes a move
    player.update();
    
    //gussing AI makes a move only if the game has already started (cannot calculate chances if nothing exists)
    if(!game.is_firstClick()){
      guesser.calcChance();
      
      //show its results on each case
      //chance.show();
    }
    
    //show the amounts of games played
    textAlign(LEFT, CENTER);
    text("Game #" + gameAmount, 0, height - caseSizeX/2);
    textAlign(CENTER, CENTER);
  
  
  
}
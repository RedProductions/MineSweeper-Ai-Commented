void setup(){
  
  //size(1800, 1060);
  
  fullScreen();
  
  caseSizeX = width/GAME_SIZE_X;
  caseSizeY = (height - EDGE_HEIGHT)/GAME_SIZE_Y;
  
  if(caseSizeX < caseSizeY){
    font = createFont("STENCIL.TTF", caseSizeX);
  }else {
    font = createFont("STENCIL.TTF", caseSizeY); 
  }
  
  player = new Ai();
  g = new Game();
  chance = new Chance();
  
  textAlign(CENTER, CENTER);
  
}


void draw(){
  
  background(170);
  textFont(font);
    
    timeCalc();
    
    g.update();
    
    g.show();
    
    if(!g.is_alive()){
      playing = false;
      game_over(g.has_won());
      if(g.has_won()){
        if(currentTime - finishTime >= showFinishTime){
          g = new Game();
          player = new Ai();
        }
      }else if(g.can_Restart() || (!g.has_won() && AI_TRY)){
        lostAmount++;
        g = new Game();
        player = new Ai();
      }
    }else {
      showStats();
    }
    
    player.update();
    
    if(!g.is_firstClick()){
      chance.calcChance();
      
      //chance.show();
    }
    
    textAlign(LEFT, CENTER);
    text("Game #" + gameAmount, 0, height - caseSizeX/2);
    textAlign(CENTER, CENTER);
  
  
  
}
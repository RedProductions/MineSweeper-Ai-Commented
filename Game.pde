class Game{
  
  Case[][] c;

  boolean firstClick;
  
  boolean alive;
  boolean canRestart;
  
  boolean flipped;
  
  boolean canFlip;
  
  boolean win;
  
  int bombPlaced;
  
  int noFlagFadeTime;
  int noFlagTime;
  int fadeSpeed;
  
  Game(){
    
    gameAmount++;
    
    firstClick = true;
    
    c = new Case[GAME_SIZE_X][GAME_SIZE_Y];
    
    alive = true;
    canRestart = false;
    
    flipped = false;
    
    canFlip = false;
    
    win = false;
    
    bombPlaced = 0;
    
    noFlagFadeTime = 300;
    noFlagTime = 0;
    fadeSpeed = 10;
    
  }
  
  Case get_case(int x, int y){return c[x][y];}
  
  boolean is_alive(){return alive;}
  boolean can_Restart(){return canRestart;}
  
  boolean has_won(){return win;}
  
  boolean is_firstClick(){return firstClick;}
  
  int get_bombPlaced(){return bombPlaced;}
  
  int get_noFlagTotalTime(){return noFlagFadeTime;}
  int get_noFlagTime(){return noFlagTime;}
  
  void set_alive(boolean nalive){alive = nalive;}
  void set_firstClick(boolean nfirstClick){firstClick = nfirstClick;}
  
  void set_bombPlaced(int nbomb){bombPlaced += nbomb;}
  
  void update(){
    
    if(mousePressed && mouseY < height - EDGE_HEIGHT){
      
      if(canFlip){
        
        if(!alive){
          canRestart = true;
        }else {
          
          int x = getXIndex(mouseX);
          int y = getYIndex(mouseY);
          
          if((firstClick && mouseButton == LEFT)){
            startGame(x, y);
          }
          
          if(mouseButton == LEFT){
            alive = c[x][y].flip();
            getValue(x, y);
            if(c[x][y].get_Value() == 0 && c[x][y].is_checked()){
              
              clearNeighbours();
              
            }
          }else if(mouseButton == RIGHT && !firstClick){
            //change the flag of the selected tile
            if(bombPlaced < BOMB_AMOUNT || c[x][y].is_flagged()){
              bombPlaced += c[x][y].changeFlag();
            }else {
              noFlagTime = noFlagFadeTime;
            }
          }
          
          
          canFlip = false;
          
        }
          
      }
    }else {
      canFlip = true;
    }
    
    if(!alive && !flipped){
      
      flipped = true;
      
      flipAll();
      
    }
    
    if(!firstClick){
      if(allVerified()){
        if(allFlagCorrect()){
          if(alive && !win){
            finishTime = currentTime;
            winAmount++;
          }
          alive = false;
          win = true;
        }
      }
    }
    
    if(noFlagTime > 0){
      noFlagTime -= fadeSpeed;
    }else if(noFlagTime < 0){
      noFlagTime = 0;
    }
    
  }
  
  
  void show(){
    
    if(!firstClick){
      for(int i = 0; i < GAME_SIZE_X; i++){
        for(int j = 0; j < GAME_SIZE_Y; j++){
          
          c[i][j].show(i*caseSizeX, j*caseSizeY, caseSizeX, caseSizeY, alive);
          
        }
      }
    }else {
      
      for(int i = 0; i < GAME_SIZE_X; i++){
        for(int j = 0; j < GAME_SIZE_Y; j++){
          
          fill(130);
          rect(i * caseSizeX, j * caseSizeY, caseSizeX, caseSizeY);
          
        }
      }
      
    }
    
  }
  
  
  void getValue(int x, int y){
    
    c[x][y].set_Value(0);
    
    for(int i = -1; i <= 1; i++){
      for(int j = -1; j <= 1; j++){
        
        if(x + i >= 0 && x + i < GAME_SIZE_X){
          if(y + j >= 0 && y + j < GAME_SIZE_Y){
            
            if(c[x+i][y+j].is_bomb()){
              c[x][y].set_Value(c[x][y].get_Value() + 1);
            }
            
          }
        }
        
      }
    }
    
  }
  
  
  void createGrid(int x, int y){
    
    for(int i = 0; i < GAME_SIZE_X; i++){
      for(int j = 0; j < GAME_SIZE_Y; j++){
        
        c[i][j] = new Case();
        
      }
    }
    
    int placed = 0;
    
    while(placed < BOMB_AMOUNT){
      
      int nx = int(random(GAME_SIZE_X));
      int ny = int(random(GAME_SIZE_Y));
      
      if(!(nx >= x - SAFE_RADIUS && nx <= x + SAFE_RADIUS && ny >= y - SAFE_RADIUS && ny <= y + SAFE_RADIUS)){
        if(!c[nx][ny].is_bomb()){
          c[nx][ny].set_bomb(true);
          placed++;
        }
      }
      
    }
    
  }
  
  
  void clearNeighbours(){
    
    int amount;
    
    do{
      
      amount = 0;
      
      for(int x = 0; x < GAME_SIZE_X; x++){
        for(int y = 0 ; y < GAME_SIZE_Y; y++){
          
          if(c[x][y].is_empty()){
            
            for(int i = -1; i <= 1; i++){
              for(int j = -1; j <= 1; j++){
                
                if(x + i >= 0 && x + i < GAME_SIZE_X){
                  if(y + j >= 0 && y + j < GAME_SIZE_Y){
                    
                    if(!c[x+i][y+j].is_checked() && !c[x+i][y+j].is_flagged()){
                      amount++;
                    }
                    c[x+i][y+j].flip();
                    getValue(x+i, y+j);
                    
                  }
                }
                
              }
            }
            
          }
          
        }
      }
      
    }while(amount > 0);
    
  }
  
  boolean allVerified(){
    
    int verifyAmount = 0;
    
    for(int x = 0; x < GAME_SIZE_X; x++){
      for(int y = 0 ; y < GAME_SIZE_Y; y++){
        
        if(c[x][y].is_flagged() || c[x][y].is_checked()){
          verifyAmount++;
        }
        
      }
    }
    
    if(verifyAmount == GAME_SIZE_X * GAME_SIZE_Y){
      return true;
    }else {
      return false;
    }
    
  }
  
  boolean allFlagCorrect(){
    
    int amountCorrect = 0;
    int amountIncorrect = 0;
    
    for(int x = 0; x < GAME_SIZE_X; x++){
      for(int y = 0 ; y < GAME_SIZE_Y; y++){
        
        if(c[x][y].is_flagged()){
          if(c[x][y].is_bomb()){
            amountCorrect++;
          }else {
            amountIncorrect++;
          }
        }
        
      }
    }
    
    if(amountCorrect == BOMB_AMOUNT && amountIncorrect <= 0){
      return true;
    }else {
      return false;
    }
    
  }
  
  
  void flipAll(){
    
    for(int x = 0; x < GAME_SIZE_X; x++){
      for(int y = 0 ; y < GAME_SIZE_Y; y++){
        
        getValue(x, y);
        c[x][y].flip();
        
      }
    }
    
  }
  
  
  int getXIndex(int x){
    
    int index;
    
    index = floor(x/caseSizeX)%GAME_SIZE_X;
    
    return index;
    
  }
  
  int getYIndex(int y){
    
    int index;
    
    index = floor(y/caseSizeY)%GAME_SIZE_Y;
    
    return index;
    
  }
  
  
  void startGame(int x, int y){
    
    createGrid(x, y);
    firstClick = false;
    startingTime = currentTime;
    playing = true;
    
  }
  
  
}
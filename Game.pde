class Game{
  
  //array of all the cases
  Case[][] c;

  //flag if it is the first move of the game
  boolean firstClick;
  
  //flag if the game is active
  boolean alive;
  
  //flag if the end message has been displayed
  boolean canRestart;
  
  //flag if the game has flipped all the cases when the game is over
  boolean allFlipped;
  
  //flag if the mouse has been released to allow another case flip
  boolean canFlip;
  
  //flag if the game has been won or not
  boolean win;
  
  //amount of bombs placed
  int bombPlaced;
  
  //time variables to flash the text green when the user tries to place a flag when there are no more left to place
  int noFlagFadeTime;
  int noFlagTime;
  int fadeSpeed;
  
  Game(){
    
    //increase the global game played amount
    gameAmount++;
    
    //the first click has not been made
    firstClick = true;
    
    //grid with the predefined size
    c = new Case[GAME_SIZE_X][GAME_SIZE_Y];
    
    //starts alive
    alive = true;
    
    //hasn't shown the ending message yet
    canRestart = false;
    
    //hasn't flipped a case
    allFlipped = false;
    
    //cannot flip a case
    canFlip = false;
    
    //hasn't won
    win = false;
    
    //hasn't placed a bomb
    bombPlaced = 0;
    
    //define timings for the fading
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
    
    //if the mouse is clicked and if it's in the game's area
    if(mousePressed && mouseY < height - EDGE_HEIGHT){
      
      //if a case can be flipped
      if(canFlip){
        
        //if the game is over, display the end message
        if(!alive){
          canRestart = true;
        }else {
          
          //get the index of where the mouse is pointing
          int x = getXIndex(mouseX);
          int y = getYIndex(mouseY);
          
          //create the game if it is the first click and if the user doesn't try to place a flag
          if((firstClick && mouseButton == LEFT)){
            startGame(x, y);
          }
          
          //if the user left-clicks (flip a case)
          if(mouseButton == LEFT){
            //set game's status if a flip is a bomb
            alive = c[x][y].flip();
            getValue(x, y);
            //clear all neighbours only if the case's neighbours are not bombs
            if(c[x][y].get_Value() == 0 && c[x][y].is_checked()){
              
              clearNeighbours();
              
            }
          }else if(mouseButton == RIGHT && !firstClick){
            //change the flag of the selected tile only if there are flags left to place or if it has already been flagged
            if(bombPlaced < BOMB_AMOUNT || c[x][y].is_flagged()){
              bombPlaced += c[x][y].changeFlag();
            }else {
              noFlagTime = noFlagFadeTime;
            }
          }
          
          //the user cannot now flip
          canFlip = false;
          
        }
          
      }
    }else {
      //the user can flip now
      canFlip = true;
    }
    
    //flip all cases if the game is over and hasn't already flipped all cases
    if(!alive && !allFlipped){
      
      allFlipped = true;
      
      flipAll();
      
    }
    
    //if it is not the
    if(!firstClick){
      //if all the cases are either checked or flagged
      if(allVerified()){
        //if the flags are all correct
        if(allFlagCorrect()){
          //set the finish time only once
          if(alive && !win){
            finishTime = currentTime;
            winAmount++;
          }
          alive = false;
          win = true;
        }
      }
    }
    
    //flag fade time gestion
    if(noFlagTime > 0){
      noFlagTime -= fadeSpeed;
    }else if(noFlagTime < 0){
      noFlagTime = 0;
    }
    
  }
  
  
  void show(){
    
    //only display actual cases if the cases are created
    if(!firstClick){
      for(int i = 0; i < GAME_SIZE_X; i++){
        for(int j = 0; j < GAME_SIZE_Y; j++){
          
          c[i][j].show(i*caseSizeX, j*caseSizeY, caseSizeX, caseSizeY, alive);
          
        }
      }
    }else {
      
      //display dummy cases if the came is not created
      for(int i = 0; i < GAME_SIZE_X; i++){
        for(int j = 0; j < GAME_SIZE_Y; j++){
          
          fill(130);
          rect(i * caseSizeX, j * caseSizeY, caseSizeX, caseSizeY);
          
        }
      }
      
    }
    
  }
  
  //get amount of neighbour bomb of selected case
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
  
  //create all cases
  void createGrid(int x, int y){
    
    for(int i = 0; i < GAME_SIZE_X; i++){
      for(int j = 0; j < GAME_SIZE_Y; j++){
        
        c[i][j] = new Case();
        
      }
    }
    
    //amount of placed bombs
    int placed = 0;
    
    //try until the amount placed bombs is equal to the predefined amount
    while(placed < BOMB_AMOUNT){
      
      //take random index
      int nx = int(random(GAME_SIZE_X));
      int ny = int(random(GAME_SIZE_Y));
      
      //only place if it is outside of the safe radius
      if(!(nx >= x - SAFE_RADIUS && nx <= x + SAFE_RADIUS && ny >= y - SAFE_RADIUS && ny <= y + SAFE_RADIUS)){
        if(!c[nx][ny].is_bomb()){
          c[nx][ny].set_bomb(true);
          placed++;
        }
      }
      
    }
    
  }
  
  //clear all empty cases
  void clearNeighbours(){
    
    //amount of unchecked cases found
    int amount;
    
    do{
      
      //reset the amount of unchecked found
      amount = 0;
      
      for(int x = 0; x < GAME_SIZE_X; x++){
        for(int y = 0 ; y < GAME_SIZE_Y; y++){
          
          //check all neighbours if the case is empty (see case)
          if(c[x][y].is_empty()){
            
            //go through all neighbours
            for(int i = -1; i <= 1; i++){
              for(int j = -1; j <= 1; j++){
                
                //only verify if the case is existant
                if(x + i >= 0 && x + i < GAME_SIZE_X){
                  if(y + j >= 0 && y + j < GAME_SIZE_Y){
                    
                    //increase the amount if the case is ! checked and not flagged
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
  
  //check if all the cases are either flipped or flagged
  boolean allVerified(){
    
    //amount of correct cases
    int verifyAmount = 0;
    
    for(int x = 0; x < GAME_SIZE_X; x++){
      for(int y = 0 ; y < GAME_SIZE_Y; y++){
        
        //increase the amount if it is flagged or checked
        if(c[x][y].is_flagged() || c[x][y].is_checked()){
          verifyAmount++;
        }
        
      }
    }
    
    //return true if the amount of verified cases is equal to the grid size
    if(verifyAmount == GAME_SIZE_X * GAME_SIZE_Y){
      return true;
    }else {
      return false;
    }
    
  }
  
  //check if all the flags are at the correct position
  boolean allFlagCorrect(){
    
    //amount of flags at the correct position
    int amountCorrect = 0;
    //amounts of flags at the wrong position
    int amountIncorrect = 0;
    
    //go through all cases
    for(int x = 0; x < GAME_SIZE_X; x++){
      for(int y = 0 ; y < GAME_SIZE_Y; y++){
        
        if(c[x][y].is_flagged()){
          if(c[x][y].is_bomb()){
            //increase the amount of correct flags if it is on a bomb
            amountCorrect++;
          }else {
            //increase the amount of incorrect flags if it is not on a bomb
            amountIncorrect++;
          }
        }
        
      }
    }
    
    //return true if the amount of correct flags is the same as the amount of bombs and if there are no incorrect flags
    if(amountCorrect == BOMB_AMOUNT && amountIncorrect <= 0){
      return true;
    }else {
      return false;
    }
    
  }
  
  //flip every case
  void flipAll(){
    
    //go through all the cases
    for(int x = 0; x < GAME_SIZE_X; x++){
      for(int y = 0 ; y < GAME_SIZE_Y; y++){
        
        //get amount of neighbour bombs and flip
        getValue(x, y);
        c[x][y].flip();
        
      }
    }
    
  }
  
  //return the x index of a case
  int getXIndex(int x){
    
    int index;
    
    index = floor(x/caseSizeX)%GAME_SIZE_X;
    
    return index;
    
  }
  
  //return the y index of a case
  int getYIndex(int y){
    
    int index;
    
    index = floor(y/caseSizeY)%GAME_SIZE_Y;
    
    return index;
    
  }
  //initialisation of the game
  
  void startGame(int x, int y){
    
    createGrid(x, y);
    firstClick = false;
    startingTime = currentTime;
    playing = true;
    
  }
  
  
}

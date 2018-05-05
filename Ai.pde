class Ai{
  
  //temporary alive to each moves
  boolean alive;
  //permanent death that locks to false as soon as alive is false
  boolean permAlive;
  //amount of moves done in a turn
  int moves;
  //flag if tha AI has done at least one move
  boolean started;
  //highest chance available
  float highestChance;
  //index of all the highest chances
  int[] indexX;
  int[] indexY;
  //amount of cases found with the highest chance
  int current;
  
  Ai(){
    
    //starts alive
    alive = true;
    permAlive = true;
    //starts with no moves done
    moves = 0;
    started = false;
    
    //start the highest chance empty
    highestChance = 0;
    //array of index at the size of the grid to prevent out of bound
    indexX = new int[GAME_SIZE_X * GAME_SIZE_Y];
    indexY = new int[GAME_SIZE_X * GAME_SIZE_Y];
    //currently no cases have the highest chance
    current = 0;
    
  }
  
  int get_moves(){return moves;}
  boolean has_started(){return started;}
  
  void update(){
    
    //starts its first move
    started = true;
    moves = 0;
    
    //if the AI dies, the game dies aswell
    game.set_alive(permAlive);
    
    //if it's the first move on the game
    if(game.firstClick){
      
      //start at random case
      int x = int(random(0, GAME_SIZE_X));
      int y = int(random(0, GAME_SIZE_Y));
      
      //start the game with the random case as starting point
      game.startGame(x, y);
      //flip the selected case
      click(x, y);
      //tell the game that the first move has been done
      game.set_firstClick(false);
    }else {
      
      //flags all the cases left if there's as many flags left as cases left
      if((BOMB_AMOUNT - game.get_bombPlaced()) == caseLeft()){
        flagAll();
        moves++;
      }
      //flips everything if there are no more flags to place
      if(game.bombPlaced == BOMB_AMOUNT && game.allFlagCorrect()){
        flipAll();
        moves++;
      }
      
      for(int i = 0; i < GAME_SIZE_X; i++){
        for(int j = 0; j < GAME_SIZE_Y; j++){
          
          Case c = game.get_case(i, j);
          
          
          //interact if it's a flipped case and that is has a neighbour bomb
          if(c.get_Value() > 0 && c.is_checked()){
            
            //amount of uncheck neighbour cases
            int hiddenAmount = 0;
            //amount of flagged neighbour cases
            int flagAmount = 0;
            
            //check a 3x3 around the selected case (all neighbours)
            for(int k = -1; k <= 1; k++){
              for(int l = -1; l <= 1; l++){
                
                //only checks if the case is existant
                if(i + k >= 0 && i + k < GAME_SIZE_X){
                  if(j + l >= 0 && j + l < GAME_SIZE_Y){
                    
                    Case neighbour = game.get_case(i + k, j + l);
                    
                    if(!neighbour.is_checked()){
                      if(neighbour.is_flagged()){
                        //increase the amount of neighbour flag if it is flagged
                        flagAmount++;
                      }else {
                        //increase the amount of neighbour hidden if it is unchecked
                        hiddenAmount++;
                      }
                    }
                    
                  }
                }
                
              }
            }
            
            //if the amount of flags left to place is equal to the amount of unchecked neighbours flip all neighbours left to check
            if(flagAmount == c.get_Value() && c.get_Value() > 0 && hiddenAmount > 0){
              
              flipSection(i, j);
              
            //if the case has all its flags and there are some unchecked neighbours left flip all neighbours left to check
            }else if(hiddenAmount + flagAmount == c.get_Value() && hiddenAmount > 0 && c.get_Value() > 0){
              
              flagSection(i, j);
              
            //use the guessing AI's advices if it is allowed to and if it wasn't able to confirm anything
            }else if(AI_TRY && moves == 0){
              
              //check a 3x3 around the selected case (all neighbours)
              for(int k = -1; k <= 1; k++){
                for(int l = -1; l <= 1; l++){
                  
                  //only checks if the case is existant
                  if(i + k >= 0 && i + k < GAME_SIZE_X){
                    if(j + l >= 0 && j + l < GAME_SIZE_Y){
                      
                      if(guesser.get_chance(i + k, j + l) > highestChance){
                        
                        //set the new highest chance if it is beaten
                        highestChance = guesser.get_chance(i + k, j + l);
                        
                        //reset all indexes
                        for(int index = 0; index < current; index++){
                          indexX[current] = 0;
                          indexY[current] = 0;
                        }
                        
                        //set the amount of highest chance cases to one and save its index
                        current = 0;
                        indexX[current] = i+k;
                        indexY[current] = j+l;
                        current++;
                        
                      }else if(guesser.get_chance(i + k, j + l) == highestChance && highestChance != 0){
                        
                        //save the case's index if it has the same chance as the current highest chance and increase the amount of possible cases
                        indexX[current] = i+k;
                        indexY[current] = j+l;
                        current++;
                        
                      }
                      
                    }
                  }
                  
                }
              }
              
              
              
              
              
            }
            
          }
          
          
          
        }
      }
      
      //only go if it had no moves possible and if the highest chance found is higher than 0
      if(highestChance > 0 && moves == 0){
        
        //select a random index in all the equal cases (because all of them have the same chance of being a bomb)
        int i = int(random(current));
        
        Case neighbour = game.get_case(indexX[i], indexY[i]);
        
        //flag the selected highest chance if it is not already done (should, in theory, never be flagged) 
        if(!neighbour.is_flagged()){
          moves++;
          game.set_bombPlaced(neighbour.changeFlag());
        }
        
        //reset the highest chance data
        highestChance = 0;
        current = 0;
        for(int index = 0; index < current; index++){
          indexX[current] = 0;
          indexY[current] = 0;
        }
        
      }
      
    }
    
  }
  
  //simulate click (only used on the first move)
  void click(int x, int y){
    
    Case c = game.get_case(x, y);
    
    //set alive to what the flip gives back
    alive = c.flip();
    //set the alive lock if he is dead
    if(!alive){
      permAlive = false;
    }
    
    //add one move to the turn
    moves++;
    
    //clear all empty neighbours
    game.getValue(x, y);
    if(c.get_Value() == 0 && c.is_checked()){
      
      moves++;
      game.clearNeighbours();
      
    }
    
  }
  
  //flip all neighbour cases of the selected case
  void flipSection(int i, int j){
    
    for(int k = -1; k <= 1; k++){
      for(int l = -1; l <= 1; l++){
        
        //only checks if the case is existant
        if(i + k >= 0 && i + k < GAME_SIZE_X){
          if(j + l >= 0 && j + l < GAME_SIZE_Y){
            
            Case neighbour = game.get_case(i + k, j + l);
            
            //set alive to what the flip gives back
            alive = neighbour.flip();
            
            //add one move to the turn
            moves++;
            
            //set the alive lock if he is dead
            if(!alive){
              permAlive = false;
            }
            
            //get neighbour bombs of the case
            game.getValue(i + k, j + l);
            
          }
        }
        
      }
    }
    
    //clear all empty neighbours
    game.clearNeighbours();
    
  }
  
  //flag all the neighbours of the selected case
  void flagSection(int i, int j){
    
    //check a 3x3 around the selected case (all neighbours)
    for(int k = -1; k <= 1; k++){
      for(int l = -1; l <= 1; l++){
        
        //only checks if the case is existant
        if(i + k >= 0 && i + k < GAME_SIZE_X){
          if(j + l >= 0 && j + l < GAME_SIZE_Y){
            
            Case neighbour = game.get_case(i + k, j + l);
            
            //change the flag only if it was not already flagged
            if(!neighbour.is_flagged()){
              //add one move to the turn
              moves++;
              
              //flag the case(passing through game so that it can update it's flag count)
              game.set_bombPlaced(neighbour.changeFlag());
            }
            
          }
        }
        
      }
    }
  }
  
  //return the amount of unchecked neighbours of the selected case
  int caseLeft(){
    
    //start with no unchecked neighbours
    int left = 0;
    
    //check a 3x3 around the selected case (all neighbours)
    for(int i = 0; i < GAME_SIZE_X; i++){
      for(int j = 0; j < GAME_SIZE_Y; j++){
        
        Case c = game.get_case(i, j);
        
        //increase the amount of unchecked cases if it is unchecked
        if(!c.is_checked()){
          left++;
        }
        
      }
    }
    
    return left;
    
  }
  
  //flag every unchecked cases
  void flagAll(){
    
    //go through all the cases
    for(int i = 0; i < GAME_SIZE_X; i++){
      for(int j = 0; j < GAME_SIZE_Y; j++){
        
        Case c = game.get_case(i, j);
        
        //change the case only if it is unchecked and unflagged
        if(!c.is_flagged() && !c.is_checked()){
          game.set_bombPlaced(c.changeFlag());
        }
        
      }
    }
  
    
  }
  
  
  //flip every unchecked and unflagged cases
  void flipAll(){
    
    //go through all the cases
    for(int i = 0; i < GAME_SIZE_X; i++){
      for(int j = 0; j < GAME_SIZE_Y; j++){
        
        Case c = game.get_case(i, j);
        
        //flip only if a case is unchecked (don't need to check if it is flagged because a flagged case cannot be checked)
        if(!c.is_checked()){
          c.flip();
          game.clearNeighbours();
        }
        
      }
    }
  
    
  }
  
}
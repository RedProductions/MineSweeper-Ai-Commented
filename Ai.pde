class Ai{
  
  boolean alive;
  boolean permAlive;
  int moves;
  boolean started;
  float highestChance ;
  int[] indexX;
  int[] indexY;
  int current;
  
  Ai(){
    
    alive = true;
    permAlive = true;
    moves = 0;
    started = false;
    
    highestChance = 0;
    indexX = new int[GAME_SIZE_X * GAME_SIZE_Y];
    indexY = new int[GAME_SIZE_X * GAME_SIZE_Y];
    current = 0;
    
  }
  
  int get_moves(){return moves;}
  boolean has_started(){return started;}
  
  void update(){
    
    started = true;
    moves = 0;
    
    g.set_alive(permAlive);
    
    
    if(g.firstClick){
      
      int x = int(random(0, GAME_SIZE_X));
      int y = int(random(0, GAME_SIZE_Y));
      
      g.startGame(x, y);
      click(x, y);
      g.set_firstClick(false);
    }else {
      
      if((BOMB_AMOUNT - g.get_bombPlaced()) == caseLeft()){
        flagAll();
        moves++;
      }
      if(g.bombPlaced == BOMB_AMOUNT && g.allFlagCorrect()){
        flipAll();
        moves++;
      }
      
      for(int i = 0; i < GAME_SIZE_X; i++){
        for(int j = 0; j < GAME_SIZE_Y; j++){
          
          Case c = g.get_case(i, j);
          
          if(c.get_Value() > 0 && c.is_checked()){
            
            int hiddenAmount = 0;
            int flagAmount = 0;
            
            for(int k = -1; k <= 1; k++){
              for(int l = -1; l <= 1; l++){
                
                if(i + k >= 0 && i + k < GAME_SIZE_X){
                  if(j + l >= 0 && j + l < GAME_SIZE_Y){
                    
                    Case neighbour = g.get_case(i + k, j + l);
                    
                    if(!neighbour.is_checked()){
                      if(neighbour.is_flagged()){
                        flagAmount++;
                      }else {
                        hiddenAmount++;
                      }
                    }
                    
                  }
                }
                
              }
            }
            
            if(flagAmount == c.get_Value() && c.get_Value() > 0 && hiddenAmount > 0){
              
              flipSection(i, j);
              
            }else if(hiddenAmount + flagAmount == c.get_Value() && hiddenAmount > 0 && c.get_Value() > 0){
              
              flagSection(i, j);
              
            }else if(AI_TRY && moves == 0){
              
              //current = 0;
              //highestChance = 0;
              
              for(int k = -1; k <= 1; k++){
                for(int l = -1; l <= 1; l++){
                  
                  if(i + k >= 0 && i + k < GAME_SIZE_X){
                    if(j + l >= 0 && j + l < GAME_SIZE_Y){
                      
                      if(chance.get_chance(i + k, j + l) > highestChance){
                        
                        highestChance = chance.get_chance(i + k, j + l);
                        
                        for(int index = 0; index < current; index++){
                          indexX[current] = 0;
                          indexY[current] = 0;
                        }
                        
                        current = 0;
                        indexX[current] = i+k;
                        indexY[current] = j+l;
                        current++;
                        
                      }else if(chance.get_chance(i + k, j + l) == highestChance && highestChance != 0){
                        
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
      
      if(highestChance > 0 && moves == 0){
        
        int i = int(random(current));
        
        Case neighbour = g.get_case(indexX[i], indexY[i]);
          
        if(!neighbour.is_flagged()){
          moves++;
          g.set_bombPlaced(neighbour.changeFlag());
        }
        
        highestChance = 0;
        current = 0;
        for(int index = 0; index < current; index++){
          indexX[current] = 0;
          indexY[current] = 0;
        }
        
      }
      
    }
    
  }
  
  
  void click(int x, int y){
    
    Case c = g.get_case(x, y);
    
    alive = c.flip();
    if(!alive){
      permAlive = false;
    }
    g.getValue(x, y);
    if(c.get_Value() == 0 && c.is_checked()){
      
      moves++;
      g.clearNeighbours();
      
    }
    
  }
  
  
  void flipSection(int i, int j){
    
    for(int k = -1; k <= 1; k++){
      for(int l = -1; l <= 1; l++){
        
        if(i + k >= 0 && i + k < GAME_SIZE_X){
          if(j + l >= 0 && j + l < GAME_SIZE_Y){
            
            Case neighbour = g.get_case(i + k, j + l);
            
            alive = neighbour.flip();
            moves++;
            if(!alive){
              permAlive = false;
            }
            
            g.getValue(i + k, j + l);
            
          }
        }
        
      }
    }
    
    g.clearNeighbours();
    
  }
  
  void flagSection(int i, int j){
    
    for(int k = -1; k <= 1; k++){
      for(int l = -1; l <= 1; l++){
        
        if(i + k >= 0 && i + k < GAME_SIZE_X){
          if(j + l >= 0 && j + l < GAME_SIZE_Y){
            
            Case neighbour = g.get_case(i + k, j + l);
            
            if(!neighbour.is_flagged()){
              moves++;
              g.set_bombPlaced(neighbour.changeFlag());
            }
            
          }
        }
        
      }
    }
  }
  
  
  int caseLeft(){
    
    int left = 0;
    
    for(int i = 0; i < GAME_SIZE_X; i++){
      for(int j = 0; j < GAME_SIZE_Y; j++){
        
        Case c = g.get_case(i, j);
        
        if(!c.is_checked()){
          left++;
        }
        
      }
    }
    
    return left;
    
  }
  
  
  void flagAll(){
    
    for(int i = 0; i < GAME_SIZE_X; i++){
      for(int j = 0; j < GAME_SIZE_Y; j++){
        
        Case c = g.get_case(i, j);
        
        if(!c.is_flagged() && !c.is_checked()){
          g.set_bombPlaced(c.changeFlag());
        }
        
      }
    }
  
    
  }
  
  void flipAll(){
    
    for(int i = 0; i < GAME_SIZE_X; i++){
      for(int j = 0; j < GAME_SIZE_Y; j++){
        
        Case c = g.get_case(i, j);
        
        if(!c.is_checked()){
          c.flip();
          g.clearNeighbours();
        }
        
      }
    }
  
    
  }
  
}
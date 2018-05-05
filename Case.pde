class Case{
  
  //its amount of neighbour bomb
  int val;
  //flag if it is a bomb or not
  boolean bomb;
  //flag if it is a flag or not
  boolean flagged;
  //flag if it has been flipped or not
  boolean checked;
  
  Case(){
    
    //default case
    
    //start with no known bomb as neighbour
    val = 0;
    //start being empty and hidden
    bomb = false;
    flagged = false;
    checked = false;
    
  }
  
  Case(boolean isBomb){
    
    //case created with predefined bomb
    
    //start with no known bomb as neighbour
    val = 0;
    //sets bomb as asked by the game
    bomb = isBomb;
    //starts hidden
    flagged = false;
    checked = false;
    
  }
  
  
  int get_Value(){return val;}
  boolean is_bomb(){return bomb;}
  boolean is_flagged(){return flagged;}
  boolean is_checked(){return checked;}
  
  boolean is_empty(){
    //return true if it has no bomb neighbour, if it is not a bomb and if it has been flipped
    if(val == 0 && !bomb && checked){
      return true;
    }else {
      return false;
    }
  }
  
  void set_Value(int nval){val = nval;}
  void set_bomb(boolean nbomb){bomb = nbomb;}
  void set_flagged(boolean nflagged){flagged = nflagged;}
  void set_checked(boolean nchecked){checked = nchecked;}
  
  
  //flip a case (returns if it kills)
  boolean flip(){
    
    if(!checked && !flagged){
      checked = true;
      if(bomb){
        return false;
      }else {
        return true;
      }
    }else {
      return true;
    }
    
  }
  
  
  //change the flag
  int changeFlag(){
    //only change the flag if it is unchecked (a checked case cannot bo flagged)
    if(!checked){
      flagged = !flagged;
    }
    //return if a flag is added, removed or if nothing changed 
    if(flagged && !checked){
      return 1;
    }else if(!checked){
      return -1;
    }else {
      return 0;
    }
  }
  
  //draw the case
  void show(float x, float y, float sizeX, float sizeY, boolean alive){
    
    //what to draw if the case is unchecked
    if(!checked){
      
      //dark grey rectangle
      fill(130);
      rect(x, y, sizeX, sizeY);
      
      
      //draw a flag if it is flagged and if the game is dead. passes if hte flag was correct or not (for the flag colour)
      if(flagged && !alive){
        drawFlag(x, y, sizeX, sizeY, bomb);
      //drawthe default flag if the case is flagged
      }else if(flagged){
        drawFlag(x, y, sizeX, sizeY, false);
      }
      
    //what to draw if the case is checked
    }else {
      
      //light grey rectangle
      fill(200);
      rect(x, y, sizeX, sizeY);
      
      if(!bomb){
        if(flagged){
          //draw a red flag if it is flagged and not a bomb
          drawFlag(x, y, sizeX, sizeY, false);
        }else {
          //draw the amount of neighbour bombs if there are any
          if(val > 0){
            drawDigit(val, x, y);
          }
        }
      }else {
        //if there's a bomb, draw one
        drawBomb(x, y, sizeX, sizeY);
      }
    }
    
  }
  
}
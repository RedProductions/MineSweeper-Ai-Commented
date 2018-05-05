class Case{
  
  int val;
  boolean bomb;
  boolean flagged;
  boolean checked;
  
  Case(){
    
    val = 0;
    bomb = false;
    flagged = false;
    checked = false;
    
  }
  
  Case(boolean isBomb){
    
    val = 0;
    bomb = isBomb;
    flagged = false;
    checked = false;
    
  }
  
  
  int get_Value(){return val;}
  boolean is_bomb(){return bomb;}
  boolean is_flagged(){return flagged;}
  boolean is_checked(){return checked;}
  
  boolean is_empty(){
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
  
  int changeFlag(){
    if(!checked){
      flagged = !flagged;
    }
    if(flagged && !checked){
      return 1;
    }else if(!checked){
      return -1;
    }else {
      return 0;
    }
  }
  
  
  void show(float x, float y, float sizeX, float sizeY, boolean alive){
    
    if(!checked){
      
      fill(130);
      rect(x, y, sizeX, sizeY);
      if(flagged && !alive){
        drawFlag(x, y, sizeX, sizeY, bomb);
      }else if(flagged){
        drawFlag(x, y, sizeX, sizeY, false);
      }
      
    }else {
      
      fill(200);
      rect(x, y, sizeX, sizeY);
      
      if(!bomb){
        if(flagged){
          drawFlag(x, y, sizeX, sizeY, false);
        }else {
          if(val > 0){
            drawDigit(val, x, y);
          }
        }
      }else {
        drawBomb(x, y, sizeX, sizeY);
      }
    }
    
  }
  
}
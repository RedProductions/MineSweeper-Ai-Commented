void showStats(){
  
  textSize(EDGE_HEIGHT - EDGE_HEIGHT/4);
  
  if(g.get_bombPlaced() < BOMB_AMOUNT){
    fill(40, 110, 0);
  }else {
    float red = g.get_noFlagTime() * 240 / g.get_noFlagTotalTime() + 40;
    fill(red, 150 - red, 0);
  }
  
  text("Flags Left: " + (BOMB_AMOUNT - g.get_bombPlaced()) + "/" + BOMB_AMOUNT, width/2, height - EDGE_HEIGHT/2);
  
  if(caseSizeX < caseSizeY){
    textSize(caseSizeX);
  }else {
    textSize(caseSizeY);
  }
  
}

void game_over(boolean win){
  
  String message;
  
  if(win){
    
    fill(40, 110, 0);
    message = "YOU WON IN " + nf((gameTime/1000), 0, 2) + " SECONDS! (RESTARTING IN " + nf(((showFinishTime - (currentTime - finishTime))/1000), 0, 1) + " SECONDS)";
    
  }else {
    
    fill(240, 0, 0);
    message = "YOU LOST AFTER " + nf((gameTime/1000), 0, 2) + " SECONDS!";
    
  }
  
  text(message, width/2, height - EDGE_HEIGHT/4 * 3);
  float winRatio = float(winAmount) * 100 / float(winAmount + lostAmount);
  text("WIN RATIO: " + nf(winRatio, 0, 2) + "%", width/2, height - EDGE_HEIGHT/4);
  
}


void drawFlag(float x, float y, float sizeX, float sizeY, boolean ok) {

  fill(0);
  rect(x + sizeX/8, y + sizeY/3 * 2, sizeX - sizeX/4, sizeY/5);
  rect(x + sizeX/4, y + sizeY/2, sizeX/2, sizeY/4);
  rect(x + sizeX/2 - sizeX/16, y + sizeY/8, sizeX/16, sizeY/2);
  
  noStroke();
  if(!ok){
    fill(240, 0, 0);
  }else {
    fill(0, 240, 0);
  }
  rect(x + sizeX/8, y + sizeY/8, sizeX/4 + sizeX/8, sizeY/4);
  
  stroke(0);
  
}

void drawBomb(float x, float y, float sizeX, float sizeY){
  
  fill(0);
  
  ellipse(x + sizeX/2, y + sizeY/2 + sizeY/8, sizeX - sizeX/3, sizeY - sizeY/3);
  rect(x + sizeX/2 - sizeX/3/2, y + sizeY/6, sizeX/3, sizeY/4);
  
}


void drawDigit(int val, float x, float y) {

  switch(val) {

    case(1):
    fill(0, 30, 200);
    break;
    case(2):
    fill(30, 130, 0);
    break;
    case(3):
    fill(240, 0, 0);
    break;
    case(4):
    fill(0, 0, 110);
    break;
    case(5):
    fill(150, 0, 0);
    break;
    case(6):
    fill(0, 200, 130);
    break;
    case(7):
    fill(0, 0, 0);
    break;
    case(8):
    fill(110, 110, 110);
    break;
  default:
    fill(0);
    break;
  }

  text(val, x + caseSizeX/2, y + caseSizeY/2 - caseSizeY/16);
}
void keyPressed(){
  
  //start the player AI if it is not set to automatic start
  if(key == 'a'){
    pressing = true;
  }
  
  //reset the game
  if(key == 'r'){
    pressing = false;
    game = new Game();
    player = new Ai();
  }
  
  
}


void keyReleased(){
  
  //stop the player AI if it is not set to automatic start 
  pressing = false;
  
}
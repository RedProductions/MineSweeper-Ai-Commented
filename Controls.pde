void keyPressed(){
  
  if(key == 'a'){
    pressing = true;
  }
  if(key == 'r'){
    pressing = false;
    g = new Game();
    player = new Ai();
  }
  
  
}


void keyReleased(){
  
  pressing = false;
  
}
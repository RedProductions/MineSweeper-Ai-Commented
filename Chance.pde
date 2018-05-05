class Chance {
  
  //chance of each case
  float chance[][];
  //flag if the case got calculated once
  boolean gotValued[][];
  //chance accumulator to calculate the average probability
  int acc[][];

  Chance() {
    
    //all arrays are the size of the grid
    chance = new float[GAME_SIZE_X][GAME_SIZE_Y];
    gotValued = new boolean[GAME_SIZE_X][GAME_SIZE_Y];
    acc = new int[GAME_SIZE_X][GAME_SIZE_Y];
    resetChance();
  }
  
  float get_chance(int i, int j){
    
    return chance[i][j];
    
  }

  void calcChance() {
    
    //reset all the values to start with new ones
    resetChance();
    
    //go through all the cases
    for (int i = 0; i < GAME_SIZE_X; i++) {
      for (int j = 0; j < GAME_SIZE_Y; j++) {

        Case c = game.get_case(i, j);
        
        //value of the case(amount of neighbour bomb)
        int val = c.get_Value();
        //all neighbours and if they are unchecked
        boolean part[][] = new boolean[3][3];
        //amount of unchecked neighbours
        int hiddenAmount = 0;
        //amount of flagged neighbours
        int flagAmount = 0;
        //amount of neighbours that have a definitive chance (0% or 100% chance that there's a bomb)
        int definitiveAmount = 0;

        if (c.is_checked() && c.get_Value() > 0) {
          
          //go through all neghbours
          for (int k = -1; k <= 1; k++) {
            for (int l = -1; l <= 1; l++) {
              
              //analyse only if it is an existant case
              if (i + k >= 0 && i + k < GAME_SIZE_X) {
                if (j + l >= 0 && j + l < GAME_SIZE_Y) {

                  Case neighbour = game.get_case(i + k, j + l);
                  
                  //+1 because the neighbours start at -1
                  part[k+1][l+1] = false;
                  
                  //increase the amount of definitives if its chance is 100% or if it is at 0% (and has been calculated, not just empty)
                  if(chance[i+k][j+l] == 1 || (chance[i+k][j+l] == 0 && gotValued[i+k][j+l])){
                    definitiveAmount++;
                  }
                  
                  //increase the amount of flags if the neighbour is a flag
                  if (neighbour.is_flagged()) {
                    flagAmount++;
                  //increase the amount of hgidden cases if the neighbour is unchecked
                  } else if (!neighbour.is_checked()) {
                    hiddenAmount++;
                    part[k+1][l+1] = true;
                  } else {
                  //set the neighbour to empty if it is already checked
                    part[k+1][l+1] = false;
                  }
                }
              }
            }
          }
          
          //remaining flags to place = amount of neighbour bomb - amount of already placed bombs
          float remaining = val - flagAmount;
          
          //chance of a bomb depending of how many cases are remaining
          float percentLeft;
          
          //if there are some flags to place, calculate the percent left
          if (remaining > 0) {
            percentLeft = 1 / remaining;
          } else {
            percentLeft = 0;
          }
          
          //percentage per case left
          float percentPart = percentLeft / (hiddenAmount - definitiveAmount);
          
          //go through all neighbours
          for (int k = -1; k <= 1; k++) {
            for (int l = -1; l <= 1; l++) {
              
              //calculate only if the case is existant
              if (i + k >= 0 && i + k < GAME_SIZE_X) {
                if (j + l >= 0 && j + l < GAME_SIZE_Y) {
                  
                  //go if the case is not empty
                  if (part[k+1][l+1]) {
                    if (!gotValued[i +k][j +l]) {
                      //set the chance to the part if it has not been valued yet
                      chance[i + k][j + l] += percentPart;
                      acc[i + k][j + l]++;
                      gotValued[i +k][j + l] = true;
                    } else if (chance[i + k][j + l] < 1 && chance[i + k][j + l] > 0) {
                      //average all the chances if it already has a chance set
                      chance[i + k][j + l] *= acc[i + k][j + l];
                      chance[i + k][j + l] += percentPart;
                      acc[i + k][j + l]++;
                      chance[i + k][j + l] /= acc[i + k][j + l];
                    }
                    
                    //definitive the chance if it is 100% or 0% (definitively a bomb)
                    if (percentPart == 1) {
                      chance[i + k][j + l] = 1;
                    } else if (percentPart == 0) {
                      chance[i + k][j + l] = 0;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
  
  //show the chance on each case
  void show() {

    fill(0);

    textSize(caseSizeX/3);

    for (int i = 0; i < GAME_SIZE_X; i++) {
      for (int j = 0; j < GAME_SIZE_Y; j++) {

        if (!game.get_case(i, j).is_checked()) {
          text(nf(chance[i][j], 0, 2), i * caseSizeX + caseSizeX/2, j * caseSizeY + caseSizeY/2);
        }
      }
    }
  }

  //reset all the cases
  void resetChance() {

    for (int i = 0; i < GAME_SIZE_X; i++) {
      for (int j = 0; j < GAME_SIZE_Y; j++) {

        chance[i][j] = 0;
        acc[i][j] = 0;
        gotValued[i][j] = false;
      }
    }
  }
}
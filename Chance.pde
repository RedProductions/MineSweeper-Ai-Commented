class Chance {

  float chance[][];
  boolean gotValued[][];
  int acc[][];

  Chance() {

    chance = new float[GAME_SIZE_X][GAME_SIZE_Y];
    gotValued = new boolean[GAME_SIZE_X][GAME_SIZE_Y];
    acc = new int[GAME_SIZE_X][GAME_SIZE_Y];
    resetChance();
  }
  
  float get_chance(int i, int j){
    
    return chance[i][j];
    
  }

  void calcChance() {

    resetChance();

    for (int i = 0; i < GAME_SIZE_X; i++) {
      for (int j = 0; j < GAME_SIZE_Y; j++) {

        Case c = g.get_case(i, j);
        int val = c.get_Value();
        boolean part[][] = new boolean[3][3];
        int hiddenAmount = 0;
        int flagAmount = 0;
        int definitiveAmount = 0;

        if (c.is_checked() && c.get_Value() > 0) {

          for (int k = -1; k <= 1; k++) {
            for (int l = -1; l <= 1; l++) {

              if (i + k >= 0 && i + k < GAME_SIZE_X) {
                if (j + l >= 0 && j + l < GAME_SIZE_Y) {

                  Case neighbour = g.get_case(i + k, j + l);

                  part[k+1][l+1] = false;
                  
                  if(chance[i+k][j+l] == 1){
                    definitiveAmount++;
                  }

                  if (neighbour.is_flagged()) {
                    flagAmount++;
                  } else if (!neighbour.is_checked()) {
                    hiddenAmount++;
                    part[k+1][l+1] = true;
                  } else {
                    part[k+1][l+1] = false;
                  }
                }
              }
            }
          }

          float remaining = val - flagAmount;

          float percentLeft;

          if (remaining > 0) {
            percentLeft = 1 / remaining;
          } else {
            percentLeft = 0;
          }

          float percentPart = percentLeft / (hiddenAmount - definitiveAmount);

          for (int k = -1; k <= 1; k++) {
            for (int l = -1; l <= 1; l++) {

              if (i + k >= 0 && i + k < GAME_SIZE_X) {
                if (j + l >= 0 && j + l < GAME_SIZE_Y) {

                  if (part[k+1][l+1]) {
                    if (!gotValued[i +k][j +l]) {
                      chance[i + k][j + l] += percentPart;
                      acc[i + k][j + l]++;
                      gotValued[i +k][j + l] = true;
                    } else if (chance[i + k][j + l] < 1 && chance[i + k][j + l] > 0) {
                      chance[i + k][j + l] *= acc[i + k][j + l];
                      chance[i + k][j + l] += percentPart;
                      acc[i + k][j + l]++;
                      chance[i + k][j + l] /= acc[i + k][j + l];
                    }

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

  void show() {

    fill(0);

    textSize(caseSizeX/3);

    for (int i = 0; i < GAME_SIZE_X; i++) {
      for (int j = 0; j < GAME_SIZE_Y; j++) {

        if (!g.get_case(i, j).is_checked()) {
          text(nf(chance[i][j], 0, 2), i * caseSizeX + caseSizeX/2, j * caseSizeY + caseSizeY/2);
        }
      }
    }
  }


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
//amount of cases in the grid
final int GAME_SIZE_X = 60;
final int GAME_SIZE_Y = 32;

//radius to not place bomb when the game starts
final int SAFE_RADIUS = 2;

//bomb percentage in the grid
final float BOMB_PERCENT = 0.16;

//all bomb exept the radius
//final int BOMB_AMOUNT = (GAME_SIZE_X * GAME_SIZE_Y) - int(pow((SAFE_RADIUS * 2) + 1, 2));

//calculate the amount of bomb with the size of the grid and the percentage
final int BOMB_AMOUNT = int((GAME_SIZE_X * GAME_SIZE_Y)*BOMB_PERCENT);

//pixel height of the bottom info border
final int EDGE_HEIGHT = 100;

//if the player AI uses the guessing AI's advices
final boolean AI_TRY = true;

//HIGHSCORE -> 70.45 seconds
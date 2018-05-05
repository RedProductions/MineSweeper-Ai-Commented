final int GAME_SIZE_X = 60;
final int GAME_SIZE_Y = 32;

final int SAFE_RADIUS = 2;

final float BOMB_PERCENT = 0.16;

//final int BOMB_AMOUNT = (GAME_SIZE_X * GAME_SIZE_Y) - int(pow((SAFE_RADIUS * 2) + 1, 2));

final int BOMB_AMOUNT = int((GAME_SIZE_X * GAME_SIZE_Y)*BOMB_PERCENT);

final int EDGE_HEIGHT = 100;

final boolean AI_TRY = true;

//HIGHSCORE -> 70.45 seconds
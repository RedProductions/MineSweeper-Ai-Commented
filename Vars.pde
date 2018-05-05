//font
PFont font;

//size of a case in pixels
float caseSizeX;
float caseSizeY;

//flag if a key is being pressed (to activate the player AI when it is in manual mode)
boolean pressing = false;

//amount of won games
int winAmount = 0;
//amount of lost game
int lostAmount = 0;

//amount of games played (equal to the amount of games won + the amount of games lost)
int gameAmount = 0;

//the game
Game game;
//the player AI
Ai player;
//the guessing AI
Chance guesser;
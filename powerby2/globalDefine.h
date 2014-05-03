//
//  globalDefine.h
//  powerby2
//
//  Created by spacewander on 14-3-17.
//  Copyright (c) 2014年 com.scutknight. All rights reserved.
//

/**
 *	@file
 *  this file contains global variable used in the project. Such as Colors, etc.
 */
#ifndef powerby2_globalDefine_h
#define powerby2_globalDefine_h

#define BACKGROUND_COLOR_RED 0.98
#define BACKGROUND_COLOR_GREEN 0.97
#define BACKGROUND_COLOR_BLUE 0.9375
#define BACKGROUND_COLOR_ALPHA 1.0

#define LAYOUT_COLOR_RED 0.4
#define LAYOUT_COLOR_GREEN 0.37
#define LAYOUT_COLOR_BLUE 0.32
#define LAYOUT_COLOR_ALPHA 1.0

/**
 *	The number of total cards
 */
#define CARDS_NUMBER 25
/**
 *	The number of cards per line
 */
#define CARDS_PER_LINE 5
/**
 *	The values of the total cards matrix
 */
#define GRIDS 0,0,0,0,0,\
              0,0,0,0,0,\
              0,0,0,0,0,\
              0,0,0,0,0,\
              0,0,0,0,0

/**
 *	The graphic variable of Grid
 */
#define GRID_X 20
#define GRID_Y 70
#define GRID_WIDTH 280
#define GRID_HEIGHT 280

/**
 *	the game result. Player may win , or lost, or just go on
 */
enum PTGameResult {
    WIN = 0,
    LOST = 1,
    GOON = 2
};

#endif

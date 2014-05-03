//
//  PTGrid.h
//  powerby2
//
//  Created by spacewander on 14-3-13.
//  Copyright (c) 2014年 com.scutknight. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "globalDefine.h"

/**
 *	This class is the model of the Game
 */
@interface PTGrid : NSObject

@property (strong) NSMutableArray* values;

- (id) initWithGrid:(NSMutableArray *)gridArray;
- (void) setRandomValue;
- (void) clear;
- (enum PTGameResult) reportGameResult;


- (void) swipeLeft;
- (void) swipeRight;
- (void) swipeUp;
- (void) swipeDown;


@end

//
//  PTGridViewController.h
//  powerby2
//
//  Created by spacewander on 14-5-28.
//  Copyright (c) 2014年 com.scutknight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "globalDefine.h"

@class PTGridView;
@class PTGrid;
@class PTGameViewController;

/**
 *	the controller of Grid. It will comunicate with the PTGameViewController.
 */
@interface PTGridViewController : UIViewController

- (id) initWithMainGame:(PTGameViewController *)mainGame;
- (void) initGridViewWithFrame:(CGRect)frame;
- (void) bind;
- (void) newGame;
- (void) clear;
- (void) newGameTurn;
- (enum PTGameResult) reportGameResult;
- (void) addScore:(NSUInteger)score;
- (void) cardNeedUpdate:(NSUInteger)index;
- (NSMutableArray *) getValues;
- (NSNumber *) getSpecifiedValue:(NSUInteger)index;

@property (strong, nonatomic) PTGridView *gridView;
@end

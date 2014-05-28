//
//  PTFirstViewController.h
//  powerby2
//
//  Created by spacewander on 14-3-12.
//  Copyright (c) 2014年 com.scutknight. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *	the main view of game
 */
@interface PTGameViewController : UIViewController

- (void) startGame;
- (void) abortGame;
- (void) startNewGameFromOldOne;
- (void) lostGame;
- (void) winGame;
- (void) endGame;
- (void) newGameLoop;

- (void) addScore:(NSUInteger)score;

@end

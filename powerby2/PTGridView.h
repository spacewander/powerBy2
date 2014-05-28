//
//  PTGridViewController.h
//  powerby2
//
//  Created by spacewander on 14-3-13.
//  Copyright (c) 2014年 com.scutknight. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PTGridViewController;

/**
 *	the view of grid(the part which user can swipe and tranform cards on it)
 */
@interface PTGridView : UIView

@property (strong, nonatomic) NSMutableArray *cards;

- (void) updateGridWithGridNumber:(NSUInteger)gridNumber;
- (void) updateGrid;
- (void) clear;
- (void) bindWithController:(PTGridViewController *)controller;

@end

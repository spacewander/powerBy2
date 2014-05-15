//
//  PTGridViewController.h
//  powerby2
//
//  Created by spacewander on 14-3-13.
//  Copyright (c) 2014年 com.scutknight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTGrid.h"

@interface PTGridView : UIView

@property (strong, nonatomic) NSMutableArray *cards;

- (void) updateGridWithGridNumber:(NSUInteger)gridNumber;
- (void) updateGrid;
- (void) clear;
- (void) bindWithDelegate:(PTGrid *)delegate;

@end

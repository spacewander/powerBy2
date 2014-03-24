//
//  PTGrid.m
//  powerby2
//
//  Created by spacewander on 14-3-13.
//  Copyright (c) 2014年 com.scutknight. All rights reserved.
//

#import "PTGrid.h"
#import "globalDefine.h"

@implementation PTGrid

- (id)init
{
    self = [super init];
    if (self) {
        self.values = [NSArray arrayWithObjects:
                     GRIDS,
                     nil];
    }
    return self;
}

- (id)initWithGrid:(NSArray *)gridArray
{
    self = [super init];
    if (self) {
        self.values = [NSArray arrayWithArray:gridArray];
        NSLog(@"%@",self.values[0]);
    }
    return self;
}

- (void) setRandomValue
{
    srandom(time(NULL));
    int selectFirstGrid = rand() % CARDS_NUMBER;
    int selectSecondGrid = rand() % CARDS_NUMBER;
    while (selectFirstGrid == selectSecondGrid) {
        selectSecondGrid = rand() % CARDS_NUMBER;
    }
    
    // there will be two in each two time in three, and will be four one third
    int firstValue = 2;
    int secondValue = 2;
    if (rand() % 3 == 0) {
        firstValue = 4;
    }
    if (rand() % 3 == 0) {
        secondValue = 4;
    }
    
    [self.values setObject:[NSNumber numberWithInt:firstValue] atIndexedSubscript:(NSUInteger)selectFirstGrid];
    [self.values setObject:[NSNumber numberWithInt:secondValue] atIndexedSubscript:(NSUInteger)selectSecondGrid];
}

@end

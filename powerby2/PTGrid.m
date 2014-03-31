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
        self.values = [NSMutableArray arrayWithCapacity:CARDS_NUMBER];
        for (int i = 0; i < CARDS_NUMBER; ++i) {
            [self.values addObject:[NSNumber numberWithInt:0]];
        }
    }
    return self;
}

- (id)initWithGrid:(NSArray *)gridArray
{
    self = [super init];
    if (self) {
        self.values = [NSArray arrayWithArray:gridArray];
        NSLog(@"%@",[self.values[0] description]);
    }
    return self;
}

/**
 *	select two cards with initial value(2 or 4)
 */
- (void) setRandomValue
{
    srandom((unsigned)time(0));
    int selectFirstCard = random() % CARDS_NUMBER;
    int selectSecondCard = random() % CARDS_NUMBER;
    while (selectFirstCard == selectSecondCard) {
        selectSecondCard = random() % CARDS_NUMBER;
    }
    
    // there will be two in each two time in three, and will be four one third
    int firstValue = 2;
    int secondValue = 2;
    if (random() % 3 == 0) {
        firstValue = 4;
    }
    if (random() % 3 == 0) {
        secondValue = 4;
    }
    
    [self.values setObject:[NSNumber numberWithInt:firstValue] atIndexedSubscript:(NSUInteger)selectFirstCard];
    [self.values setObject:[NSNumber numberWithInt:secondValue] atIndexedSubscript:(NSUInteger)selectSecondCard];
}

@end

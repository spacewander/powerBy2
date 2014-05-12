//
//  PTGrid.m
//  powerby2
//
//  Created by spacewander on 14-3-13.
//  Copyright (c) 2014年 com.scutknight. All rights reserved.
//

#import "PTGrid.h"

#define MAXBINARYNUM 4096

@interface PTGrid ()

@property (nonatomic) NSUInteger emptyCardsNum;
@property (nonatomic) NSUInteger maxBinaryNum;
@property (nonatomic) BOOL maxBinaryNumberGot;

- (void) helpForInit;
- (void) updateMaxBinaryNum;
@end

@implementation PTGrid

/**
 *	called when self is inited by the superclass.
 *  a method used to avoid repeating in different init method
 */
- (void) helpForInit
{
    self.emptyCardsNum = CARDS_NUMBER;
    self.maxBinaryNumberGot = NO;
    self.maxBinaryNum = 2;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.values = [NSMutableArray arrayWithCapacity:CARDS_NUMBER];
        for (int i = 0; i < CARDS_NUMBER; ++i) {
            [self.values addObject:[NSNumber numberWithInt:0]];
        }
        [self helpForInit];
    }
    return self;
}

- (id)initWithGrid:(NSArray *)gridArray
{
    self = [super init];
    if (self) {
        self.values = [NSArray arrayWithArray:gridArray];
        NSLog(@"%@",[self.values[0] description]);
        [self helpForInit];
    }
    return self;
}

/**
 *	clear the state to the time this instance was inited
 */
- (void) clear
{
    for (int i = 0; i < CARDS_NUMBER; ++i) {
        [self.values setObject:[NSNumber numberWithInt:0]  atIndexedSubscript:i];
    }
    [self helpForInit];
}

/**
 *	select two cards(which is with 0 value) with initial value(2 or 4)
 */
- (void) setRandomValue
{
    srandom((unsigned)time(0));
    
    int selectFirstCard = random() % CARDS_NUMBER;
    while (self.values[selectFirstCard] != [NSNumber numberWithInt:0] ) {
        selectFirstCard = random() % CARDS_NUMBER;
    }
    
    // there will be two in each two time in three, and will be four one third
    int firstValue = 2;
    if (random() % 3 == 0) {
        firstValue = 4;
        // the default value of maxBinaryNum is 2. So update it to 4.
        if (self.maxBinaryNum < 4) {
            self.maxBinaryNum = 4;
        }
    }
    
    [self.values setObject:[NSNumber numberWithInt:firstValue]
        atIndexedSubscript:(NSUInteger)selectFirstCard];
    --self.emptyCardsNum;
}

/**
 *	update the MaxBinaryNum and MaxBinaryNumberGot. Called after each swipe handler.
 */
- (void) updateMaxBinaryNum
{
    self.maxBinaryNum *= 2;
    if (self.maxBinaryNum == MAXBINARYNUM) {
        self.maxBinaryNumberGot = YES;
    }
}

#pragma mark - handle swipe

- (void) swipeLeft
{
    
}

- (void) swipeRight
{
    
}

- (void) swipeUp
{
    
}

- (void) swipeDown
{
    
}

#pragma mark - report game result

/**
 *	report the game result according to whether the max binary number is composed
 *  or if there is an empty space for the new card
 *
 *	@return	gameResult
 */
- (enum PTGameResult) reportGameResult
{
    if (self.maxBinaryNumberGot) {
        return WIN;
    }
    else if (self.emptyCardsNum == 0) {
        return LOST;
    }
    else {
        return GOON;
    }
}

@end

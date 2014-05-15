//
//  PTGrid.m
//  powerby2
//
//  Created by spacewander on 14-3-13.
//  Copyright (c) 2014年 com.scutknight. All rights reserved.
//

#import "PTGrid.h"
#import "PTGridView.h"
#import "PTGameViewController.h"

#define MAXBINARYNUM 4096

@interface PTGrid ()

@property (nonatomic) NSUInteger emptyCardsNum;
@property (nonatomic) NSUInteger maxBinaryNum;
@property (nonatomic) BOOL maxBinaryNumberGot;
@property (nonatomic) PTGridView *delegate;
@property (nonatomic) PTGameViewController *controller;

- (void) helpForInit;
- (void) updateMaxBinaryNum;
- (void) squeeze:(NSUInteger)cardId;
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
    
    self.delegate = nil;
    self.controller = nil;
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
 *	bind with a PTGridView and call its public method if need
 * 
 *  it is  a two-way binding
 *
 *	@param	delegate	a PTGridView instance
 */
- (void) bindWithDelegate:(PTGridView *)delegate
{
    self.delegate = delegate;
    if (delegate != nil) {
        [delegate bindWithDelegate:self];
    }
}

/**
 *	bind with a PTGridView and call its public method if need
 *
 *  @param  controller  a PTGameViewController instance which creates this PTGrid
 */
- (void) bindWithController:(PTGameViewController *)controller
{
    self.controller = controller;
}

/**
 *	select two cards(which is with 0 value) with initial value(2 or 4)
 */
- (void) setRandomValue
{
    srandom((unsigned)time(0));
    
    int selectFirstCard = random() % CARDS_NUMBER;
    // before called this method to set random value, we should check if there is any empty space
    while (self.values[selectFirstCard] != [NSNumber numberWithInt:0] ) {
        selectFirstCard = random() % CARDS_NUMBER;
    }
    
    // there will be two in each two time in three, and will be four one third
    int firstValue = 2;
    if (random() % 3 == 0) {
        firstValue = 4;
        // the default value of maxBinaryNum is 2. So update it to 4.
        if (self.maxBinaryNum < 4) {
            [self updateMaxBinaryNum];
        }
    }
    
    [self.values setObject:[NSNumber numberWithInt:firstValue]
        atIndexedSubscript:(NSUInteger)selectFirstCard];
    
    --self.emptyCardsNum;
}

/**
 *	squeeze the value of special card and check the value
 */
- (void) squeeze:(NSUInteger)cardId
{
    int value = [self.values[cardId] intValue] * 2;
    [self.values setObject:[NSNumber numberWithInt:value] atIndexedSubscript:cardId];
    
    ++self.emptyCardsNum;
    
    if (value > self.maxBinaryNum) {
        [self updateMaxBinaryNum];
    }
    
    if (self.controller != nil) {
        [self.controller addScore:(NSUInteger)value];
    }
    else {
        NSLog(@"the controllor of PTGrid should not be nil!");
    }
}

/**
 *	update the MaxBinaryNum and MaxBinaryNumberGot. Called after each squeeze.
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
    for (int i = 0; i < CARDS_PER_LINE; ++i) {
        int step = i * CARDS_PER_LINE;
        for (int j = 0, k = 0; j < CARDS_PER_LINE; ++j) {
            // if the card is empty, pass
            // remember to compare with NSNumber
            if (self.values[step + j] != [NSNumber numberWithInt:0]) {
                // if need move
                if (k != j) {
                    self.values[step + k] = self.values[step + j];
                    // clean original value
                    self.values[step + j] = [NSNumber numberWithInt:0];
                }
                // squeeze the card
                // make sure that the k should be compared with the one in above line
                if (k != 0 &&
                    [self.values[step + k] compare:self.values[step + k - 1]] ==  NSOrderedSame) {
                    self.values[step + k] = [NSNumber numberWithInt:0];
                    [self squeeze:(step + k - 1)];
                } // end if squeeze
                
                ++k;
                } // end not equal to 0
        }// end for cols
    }// end for rows
}

- (void) swipeRight
{
    for (int i = 0; i < CARDS_PER_LINE; ++i) {
        int step = i * CARDS_PER_LINE;
        for (int j = CARDS_PER_LINE - 1, k = CARDS_PER_LINE - 1; j >= 0; --j) {
            // if the card is empty, pass
            // remember to compare with NSNumber
            if (self.values[step + j] != [NSNumber numberWithInt:0]) {
                // if need move
                if (k != j) {
                    self.values[step + k] = self.values[step + j];
                    // clean original value
                    self.values[step + j] = [NSNumber numberWithInt:0];
                }
                // squeeze the card
                // make sure that the k should be compared with the one in below line
                if (k != (CARDS_PER_LINE - 1) &&
                    [self.values[step + k] compare:self.values[step + k + 1]] ==  NSOrderedSame) {
                    self.values[step + k] = [NSNumber numberWithInt:0];
                    [self squeeze:(step + k + 1)];
                } // end if squeeze
                
                --k;
            } // end not equal to 0
        }// end for cols
    }// end for rows
}

- (void) swipeUp
{
    for (int i = 0; i < CARDS_PER_LINE; ++i) {
        for (int j = 0, k = 0; j < CARDS_PER_LINE; ++j) {
            // if the card is empty, pass
            // remember to compare with NSNumber
            if (self.values[i + CARDS_PER_LINE * j] != [NSNumber numberWithInt:0]) {
                // if need move
                if (k != j) {
                    self.values[i + k * CARDS_PER_LINE] = self.values[i + j * CARDS_PER_LINE];
                    // clean original value
                    self.values[i + j * CARDS_PER_LINE] = [NSNumber numberWithInt:0];
                }
                // squeeze the card
                // make sure that the k should be compared with the one in above line
                if (k != 0 &&
                    [self.values[i + k * CARDS_PER_LINE]
                        compare:self.values[i + (k - 1) * CARDS_PER_LINE]] == NSOrderedSame) {
                    
                    self.values[i + k * CARDS_PER_LINE] = [NSNumber numberWithInt:0];
                    [self squeeze:(i + (k - 1) * CARDS_PER_LINE)];
                } // end if squeeze
                
                ++k;
            } // end not equal to 0
        }// end for rows
    }// end for cols
}

- (void) swipeDown
{
    for (int i = 0; i < CARDS_PER_LINE; ++i) {
        for (int j = CARDS_PER_LINE - 1, k = CARDS_PER_LINE - 1; j >= 0; --j) {
            // if the card is empty, pass
            // remember to compare with NSNumber
            if (self.values[i + CARDS_PER_LINE * j] != [NSNumber numberWithInt:0]) {
                // if need move
                if (k != j) {
                    self.values[i + k * CARDS_PER_LINE] = self.values[i + j * CARDS_PER_LINE];
                    // clean original value
                    self.values[i + j * CARDS_PER_LINE] = [NSNumber numberWithInt:0];
                }
                // squeeze the card
                // make sure that the k should be compared with the one in above line
                if (k != (CARDS_PER_LINE - 1) &&
                    [self.values[i + k * CARDS_PER_LINE]
                      compare:self.values[i + (k + 1) * CARDS_PER_LINE]] ==  NSOrderedSame) {
                    
                    self.values[i + k * CARDS_PER_LINE] = [NSNumber numberWithInt:0];
                    [self squeeze:(i + (k + 1) * CARDS_PER_LINE)];
                } // end if squeeze
                
                --k;
            } // end not equal to 0
        }// end for rows
    }// end for cols
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

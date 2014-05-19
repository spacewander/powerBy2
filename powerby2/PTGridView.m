//
//  PTGridViewController.m
//  powerby2
//
//  Created by spacewander on 14-3-13.
//  Copyright (c) 2014年 com.scutknight. All rights reserved.
//

#import "PTGridView.h"
#import "PTCard.h"
#import "globalDefine.h"

@interface PTGridView ()

@property (strong) PTCard *firstCard;
@property (strong) PTCard *secondCard;

@property (readonly) int cardsNumber;
@property (readonly) int cardsNumberPerLine;
@property (nonatomic) PTGrid *delegate;

- (void) fillWithCards:(CGRect)gridSize;
- (int) cardsNumber;

@end

@implementation PTGridView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:LAYOUT_COLOR_RED
                                               green:LAYOUT_COLOR_GREEN
                                                blue:LAYOUT_COLOR_BLUE alpha:LAYOUT_COLOR_ALPHA];
        [self fillWithCards:frame];
        self.delegate = nil;
    }
    return self;
}

/**
 *	clear the state to the time this instance was inited
 */
- (void) clear
{
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self fillWithCards:self.frame];
    self.delegate = nil;
}

/**
 *	@return	the total number of card
 */
- (int) cardsNumber
{
    return CARDS_NUMBER;
}

/**
 *	@return	card number for each line
 */
- (int) cardsNumberPerLine
{
    return CARDS_PER_LINE;
}

/**
 *	fill the grid with cards. Called when the grid is initialed.
 *
 *	@param	gridSize	the size of grid
 */
- (void) fillWithCards:(CGRect)gridSize
{
    CGFloat width = gridSize.size.width;
    CGFloat height = gridSize.size.height;
    
    self.cards = [NSMutableArray array];
    int cardsNumberPerLine = [self cardsNumberPerLine];
    int gapWidth = [self cardsNumberPerLine];
    int gapHeight = [self cardsNumberPerLine];
    
    CGFloat gridWidth = (width - (cardsNumberPerLine + 1) * gapWidth) / cardsNumberPerLine;
    CGFloat gridHeight = (height - (cardsNumberPerLine + 1) * gapHeight) / cardsNumberPerLine;
    for (int i = 0; i < cardsNumberPerLine; ++i) {
        for (int j = 0; j < cardsNumberPerLine; ++j) {
            PTCard *card =
                [[PTCard alloc] initWithFrame:CGRectMake(gapWidth +
                                                         (j % cardsNumberPerLine) * (gridWidth + gapWidth),
                                                         gapHeight +
                                                         (i % cardsNumberPerLine) * (gridHeight + gapHeight),
                                                         gridWidth, gridHeight)];
            [self.cards addObject:card];
            [self addSubview:card];
        } // end for j
    } // end for i
}// end func

//- (void)drawRect:(CGRect)rect
//{
//    // Drawing code
//}

/**
 *	bind with a PTGrid and call its public method if need
 *
 *	@param	delegate	a PTGrid instance
 */
- (void) bindWithDelegate:(PTGrid *)delegate
{
    self.delegate = delegate;
}

#pragma mark - update

/**
 *	update the grid with the value of each card in the model of grid.
 *  called when the model of grid generalize random value or some cards are dismissed.
 *
 *  This method is public because I want the controller to call it instead of the delegate
 */
- (void) updateGrid
{
    if (self.delegate == nil) {
        return;
    }
    
    int cardsNumber = [self cardsNumber];
    for (int i = 0; i < cardsNumber; ++i) {
        PTCard *card = self.cards[i];
        // change the cardValue of each card.
        // And then call update to update the cards according to their values
        card.cardValue = self.delegate.values[i];
    }
    for (int i = 0; i < cardsNumber; ++i) {
        [self.cards[i] update];
    }
}

/**
 *	update a simple card.
 *
 *	@param	gridNumber	the index of the card
 */
- (void) updateGridWithGridNumber:(NSUInteger)gridNumber
{
    if (gridNumber > [self cardsNumber] - 1) {
        NSLog(@"the index of the card updated is out of index!");
        return;
    }
    else {
        PTCard *card = self.cards[gridNumber];
        card.cardValue = self.delegate.values[gridNumber];
        [self.cards[gridNumber] update];
    }
}

@end

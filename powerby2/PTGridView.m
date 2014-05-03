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

#define gapWidth 5
#define gapHeight 5

@interface PTGridView ()

@property (strong) PTCard *firstCard;
@property (strong) PTCard *secondCard;

@property (readonly) int cardsNumber;
@property (readonly) int cardsNumberPerLine;

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
 *	update the grid with the value of each card in the model of grif
 *
 *	@param	grid	the model of grid
 */
- (void) updateGridWithGridNumber:(PTGrid *)grid
{
    if (grid == nil) {
        return;
    }
    
    int cardsNumber = [self cardsNumber];
    for (int i = 0; i < cardsNumber; ++i) {
        PTCard *card = self.cards[i];
        card.cardValue = grid.values[i];
    }
    for (int i = 0; i < cardsNumber; ++i) {
        [self.cards[i] updateWithValue];
    }
}

@end

//
//  PTGridViewController.m
//  powerby2
//
//  Created by spacewander on 14-3-13.
//  Copyright (c) 2014年 com.scutknight. All rights reserved.
//

#import "PTGridView.h"
#import "globalDefine.h"

@interface PTGridView ()

@property (strong) PTCard *firstCard;
@property (strong) PTCard *secondCard;

- (void) fillWithCards:(CGRect)gridSize;
- (int) cardsNumber;

@end

@implementation PTGridView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.4 green:0.37 blue:0.32 alpha:1.0];
        [self fillWithCards:frame];
    }
    return self;
}

- (int) cardsNumber
{
    return 25;
}

- (void) fillWithCards:(CGRect)gridSize
{
    self.cards = [NSMutableArray array];
    int cardNum = [self cardsNumber];
    for (int i = 0; i < cardNum; ++i) {
//        PTCard *card = [[PTCard alloc] initWithFrame:CGRectMake(10 + i * 40, 10, 60, 60)];
//        [self.cards addObject:card];
        //            [self.subviews :self.cards];
    }
}

@end

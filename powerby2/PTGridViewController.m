//
//  PTGridViewController.m
//  powerby2
//
//  Created by spacewander on 14-5-28.
//  Copyright (c) 2014年 com.scutknight. All rights reserved.
//

#import "PTGridViewController.h"
#import "PTGameViewController.h"
#import "PTGrid.h"
#import "PTGridView.h"

@interface PTGridViewController ()

@property (nonatomic) PTGameViewController *mainGame;
@property (strong, nonatomic) PTGrid *gridModel;

- (id) init;
- (void) addRecognizers;
- (void) handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer;
@end

@implementation PTGridViewController

/**
 *	you should not use the init method for PTGridViewController directly.
 *  And you can't, too.
 *
 *	@return	nil
 */
- (id) init
{
    NSLog(@"You should not use the raw initialize function of PTGridViewController!");
    return nil;
}

- (id) initWithMainGame:(PTGameViewController *)mainGame
{
    self = [super init];
    if (self) {
        self.mainGame = mainGame;
        self.gridModel = [[PTGrid alloc] init];
        self.gridView = nil;
        // gridView will be initialized after by main game instance.
    }
    return self;
}

- (void) initGridViewWithFrame:(CGRect)frame
{
    self.gridView = [[PTGridView alloc] initWithFrame:frame];
    if (self.gridView == nil) {
        NSLog(@"ERROR : can not init the view of grid!");
        // Sadly, we have to do that
        exit(1);
    }
    [[self.mainGame view] addSubview:self.gridView];
}

- (void) bind
{
    // bind with the parts it will take charge of.
    if (self.gridModel == nil || self.gridView == nil) {
        NSLog(@"should init gridModel and gridView before you bind them with controller");
        return;
    }
    [self.gridModel bindWithController:self];
    [self.gridView bindWithController:self];
    
    [self addRecognizers];

}

#pragma mark - gesture event

/**
 *	add recognizers for swipe actions
 */
- (void) addRecognizers
{
    UISwipeGestureRecognizer *recognizer;
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.gridView addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.gridView addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.gridView addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.gridView addGestureRecognizer:recognizer];
}


/**
 *	handle different swipe directions
 *
 *	@param	recognizer
 */
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    switch (recognizer.direction)
    {
        case UISwipeGestureRecognizerDirectionUp:
            NSLog(@"up");
            [self.gridModel swipeUp];
            break;
        case UISwipeGestureRecognizerDirectionDown:
            NSLog(@"down");
            [self.gridModel swipeDown];
            break;
        case UISwipeGestureRecognizerDirectionLeft:
            NSLog(@"left");
            [self.gridModel swipeLeft];
            break;
        case UISwipeGestureRecognizerDirectionRight:
            NSLog(@"right");
            [self.gridModel swipeRight];
        default:
            break;
    }
    [self.gridView updateGrid];
    [self.mainGame newGameLoop];
}

#pragma mark - game event

/**
 *	called when a new game is started.
 */
- (void) newGame
{
    [self.gridModel setRandomValue];
    [self.gridModel setRandomValue];
    
    [self.gridView updateGrid];
}

/**
 *	called when the grid need to be cleared, for example, when an old game is ended.
 */
- (void) clear
{
    [self.gridModel clear];
    [self.gridView clear];
}

/**
 *	called when a new game turn is started
 */
- (void) newGameTurn
{
    [self.gridModel setRandomValue];
    [self.gridView updateGrid];
}

/**
 *	report game result to the main game. Called when a game turn is ended.
 *
 *	@return	gono/win/lost
 */
- (enum PTGameResult) reportGameResult
{
    return [self.gridModel reportGameResult];
}

#pragma mark - called by model

/**
 *	tell the main game instance to add new score and update the old one
 *
 *	@param	score	the additional score
 */
- (void) addScore:(NSUInteger)score
{
    [self.mainGame addScore:score];
}

#pragma mark - called by view

- (NSMutableArray *) getValues
{
    return self.gridModel.values;
}

- (NSNumber *) getSpecifiedValue:(NSUInteger)index
{
    return self.gridModel.values[index];
}
@end

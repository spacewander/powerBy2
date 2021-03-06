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

/**
 *	the instance should be only created with this method. 
 *  Otherwise, the mainGame will be nil, 
 *  and no message can pass to main game instance, caused the game can not go on.
 *
 *	@param	mainGame	the instance represented the game view controller
 *
 *	@return	self
 */
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

/**
 *	then we will use this method to create gridView.
 *  Don't forget to add the gridView as the subview of main game instance instead of self.
 *
 *	@param	frame	the size and coordination of gridView.
 */
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
    NSUInteger index = [self.gridModel setRandomValue];
    [self.gridView updateGridWithGridNumber:index];
    
    index = [self.gridModel setRandomValue];
    [self.gridView updateGridWithGridNumber:index];
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
    NSUInteger index = [self.gridModel setRandomValue];
    [self.gridView updateGridWithGridNumber:index];
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

/**
 *	ask for updating a PTCard
 *
 *	@param	index	the index of PTCard
 */
- (void) cardNeedUpdate:(NSUInteger)index
{
    [self.gridView updateGridWithGridNumber:index];
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

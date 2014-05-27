//
//  PTFirstViewController.m
//  powerby2
//
//  Created by spacewander on 14-3-12.
//  Copyright (c) 2014年 com.scutknight. All rights reserved.
//
#import "CXAlertView.h"

#import "PTGameViewController.h"
#import "PTGrid.h"
#import "PTGridView.h"
#import "PTUserManager.h"
#import "globalDefine.h"

// the full screen is 320 * 480
#define FIRST_LABEL_X 170
#define FIRST_LABEL_Y 20
#define SECOND_LABEL_X 250
#define SECOND_LABEL_Y 20
#define LABEL_WIDTH 50
#define LABEL_HEIGHT 20
#define NEW_GAME_BUTTON_X 20
#define NEW_GAME_BUTTON_Y 20

#define GAME_WIDTH 320
#define GAME_HEIGHT 480

@interface PTGameViewController ()

@property (strong, nonatomic) UILabel *scoreLabel;
@property (strong, nonatomic) UILabel *highestScoreLabel;
// for the name of the button, it avoid the limitation of ARC
@property (strong, nonatomic) UIButton *theNewGameButton;

@property (nonatomic) NSUInteger highestScore;
@property (nonatomic) NSUInteger score;

@property (strong, nonatomic) PTGrid *gridModel;
@property (strong, nonatomic) PTGridView *gridView;
@property (strong, nonatomic) PTUserManager *userManager;

- (void) setDefaultBackgroundColor:(UIView *)view;
- (void) setDefaultLayoutColor:(UIView *)view;
- (void) setLabelStyle:(UILabel *)label;
- (void) addRecognizers;
- (void) handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer;
- (void) newGameLoop;
- (void) clear;
- (enum PTGameResult) getGameResult;
- (void) recordResult;
- (void) turnToRankView;

@end

@implementation PTGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.theNewGameButton = [[UIButton alloc] initWithFrame:
                          CGRectMake(NEW_GAME_BUTTON_X, NEW_GAME_BUTTON_Y, LABEL_WIDTH, LABEL_HEIGHT)];
    [self.theNewGameButton setTitle:@"Replay" forState:UIControlStateNormal];
    [self setDefaultLayoutColor:self.theNewGameButton];
    [self setLabelStyle:self.theNewGameButton.titleLabel];
    [self.theNewGameButton addTarget:self action:@selector(startNewGameFromOldOne) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.theNewGameButton];
    
    self.score = 0;
    self.scoreLabel = [[UILabel alloc] initWithFrame:
                       CGRectMake(FIRST_LABEL_X,FIRST_LABEL_Y, LABEL_WIDTH, LABEL_HEIGHT)];
	self.scoreLabel.text = @"Score";
    [self setLabelStyle:self.scoreLabel];
    [self.view addSubview:self.scoreLabel];
    
    self.highestScoreLabel = [[UILabel alloc] initWithFrame:
                       CGRectMake(SECOND_LABEL_X,SECOND_LABEL_Y, LABEL_WIDTH, LABEL_HEIGHT)];
    self.highestScore = [self.userManager selectHighestScore];
    [self.highestScoreLabel setText:[NSString stringWithFormat:@"%u", self.highestScore]];
    [self setLabelStyle:self.highestScoreLabel];
    [self.view addSubview:self.highestScoreLabel];
    
    self.gridView = [[PTGridView alloc] initWithFrame:
                     CGRectMake(GRID_X, GRID_Y, GRID_WIDTH, GRID_HEIGHT)];
    if (self.gridView == nil) {
        NSLog(@"ERROR : can not init the view of grid!");
        exit(1);
    }
    [self.view addSubview:self.gridView];
    
    self.gridModel = [[PTGrid alloc] init];
    // two-way binding
    [self.gridModel bindWithDelegate:self.gridView];
    // also bind it with its controller
    [self.gridModel bindWithController:self];
    
    [self addRecognizers];
    [self startGame];
}

/**
 *	add recognizers for swipe actions
 */
- (void) addRecognizers
{
    UISwipeGestureRecognizer *recognizer;
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [[self view] addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:UISwipeGestureRecognizerDirectionUp];
    [[self view] addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:UISwipeGestureRecognizerDirectionDown];
    [[self view] addGestureRecognizer:recognizer];
}

- (void) loadView
{
    [super loadView];
    
    // create a full screen
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GAME_WIDTH, GAME_HEIGHT)];
    [self setDefaultBackgroundColor:self.view];
    
    self.userManager = [PTUserManager sharedInstance];
}

- (void) setDefaultBackgroundColor:(UIView *)view
{
    view.backgroundColor = [UIColor colorWithRed:BACKGROUND_COLOR_RED green:BACKGROUND_COLOR_GREEN
                                            blue:BACKGROUND_COLOR_BLUE alpha:BACKGROUND_COLOR_ALPHA ];
}

- (void) setDefaultLayoutColor:(UIView *)view
{
    view.backgroundColor = [UIColor colorWithRed:LAYOUT_COLOR_RED green:LAYOUT_COLOR_GREEN
                                            blue:LAYOUT_COLOR_BLUE alpha:LAYOUT_COLOR_ALPHA ];
}

- (void) setLabelStyle:(UILabel *)label
{
    label.textAlignment = NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = YES;
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    label.textColor = [UIColor colorWithRed:BACKGROUND_COLOR_RED green:BACKGROUND_COLOR_GREEN
                                                 blue:BACKGROUND_COLOR_BLUE alpha:BACKGROUND_COLOR_ALPHA ];

    // the background color of labels is the same as the grid
    [self setDefaultLayoutColor:label];
}

/**
 *	update the current score
 *
 *	@param	score	the current score should be it
 */
- (void)addScore:(NSUInteger)score
{
    self.score += score;
    [self.scoreLabel setText:[NSString stringWithFormat:@"%u", self.score]];
    
    if (self.highestScore < self.score) {
        self.highestScore = self.score;
        [self.highestScoreLabel setText:[NSString stringWithFormat:@"%u", self.highestScore]];
    }
}

#pragma mark - game loop

/**
 *	leave current game and start the new one
 */
- (void) startNewGameFromOldOne
{
    [self abortGame];
    [self startGame];
}

/**
 *	prepare for the start of game
 */
- (void) startGame
{
    [self.gridModel setRandomValue];
    [self.gridModel setRandomValue];
    
    [self.gridView updateGrid];
}

/**
 *	abort current game elegantly
 */
- (void) abortGame
{
    [self clear];
}

/**
 *	clear the data and view in the main game view
 */
- (void) clear
{
    self.score = 0;
    [self.scoreLabel setText:[NSString stringWithFormat:@"%u", self.score]];
    self.highestScore = [self.userManager selectHighestScore];
    [self.highestScoreLabel setText:[NSString stringWithFormat:@"%u", self.highestScore]];
    
    [self.gridModel clear];
    [self.gridView clear];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *	should not autorotate
 *
 *	@return	NO
 */
- (BOOL)shouldAutorotate
{
    return NO;
}

#pragma mark - gesture event

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
                    [self lostGame];//
//    [self newGameLoop];
}

#pragma mark - new game loop

/**
 *	start a new turn of game. The actions is different according to the result of game
 */
- (void) newGameLoop
{
    enum PTGameResult gameResult = [self getGameResult];
    switch (gameResult) {
        case GOON:
            [self.gridModel setRandomValue];
            [self.gridView updateGrid];
            break;
        case WIN:
            [self winGame];
            break;
        case LOST:
            [self lostGame];
            break;
            
        default:
            break;
    }
}

#pragma mark - game result

/**
 *	get the report of game result.
 *  Called by the beginning of each new game turn
 *
 *	@return	gameResult
 */
- (enum PTGameResult) getGameResult
{
    return [self.gridModel reportGameResult];
}

/**
 *	called when player loses the game. Reuqire for whether replay or not
 */
- (void) lostGame
{
    // Create alertView with the old fashioned way.
    CXAlertView *alertView = [[CXAlertView alloc]
                              initWithTitle:@"Game Over"
                              message:@"The game is over!\nChoose to replay or leave the Game!"
                              cancelButtonTitle:nil];
    // set the style of alertView
    [alertView setShowBlurBackground:YES];
    [alertView setTitleFont:[UIFont fontWithName:@"Helvetica-Bold" size:30]];
    alertView.alpha = 0.7;
    [alertView setFrame:CGRectMake(GRID_X, GRID_Y, GRID_WIDTH, GRID_HEIGHT)];
    
    // Add additional button as you like with block to handle UIControlEventTouchUpInside event.
    [alertView addButtonWithTitle:@"Replay"
                             type:CXAlertViewButtonTypeCancel
                          handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                              [alertView dismiss];
                              [self recordResult];
                              [self startNewGameFromOldOne];
                          }];
    // end the game
    [alertView addButtonWithTitle:@"Leave"
                             type:CXAlertViewButtonTypeDefault
                          handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                              [alertView dismiss];
                              [self recordResult];
                              [self endGame];
                          }];
    
    // Remember to call this, or alertview will never be seen.
    [alertView show];
}

/**
 *	called when player wins the game. Reuqire for whether replay or not
 */
- (void) winGame
{
    // Create alertView with the old fashioned way.
    CXAlertView *alertView = [[CXAlertView alloc]
                              initWithTitle:@"You Win!"
                              message:@"That is nearly impossible!\nCongratulation!"
                              cancelButtonTitle:nil];
    // set the style of alertView
    [alertView setShowBlurBackground:YES];
    [alertView setTitleFont:[UIFont fontWithName:@"Helvetica-Bold" size:30]];
    alertView.alpha = 0.7;
    [alertView setFrame:CGRectMake(GRID_X, GRID_Y, GRID_WIDTH, GRID_HEIGHT)];
    
    // Add additional button as you like with block to handle UIControlEventTouchUpInside event.
    [alertView addButtonWithTitle:@"Replay"
                             type:CXAlertViewButtonTypeCancel
                          handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                              // Dismiss alertview
                              [alertView dismiss];
                              [self recordResult];
                              [self startNewGameFromOldOne];
                          }];
    // turn to the rank view
    [alertView addButtonWithTitle:@"Enjoy"
                             type:CXAlertViewButtonTypeDefault
                          handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                              [alertView dismiss];
                              [self recordResult];
                              [self turnToRankView];
                          }];
    
    // Remember to call this, or alertview will never be seen.
    [alertView show];
}


/**
 *	called when player wants to end the game
 */
- (void) endGame
{
    // clear all the resourse
    [self abortGame];
    
    [UIView beginAnimations:@"exitApplication" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:
     (UIViewAnimationTransition)UIViewAnimationOptionTransitionFlipFromBottom forView:self.view cache:NO];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    self.view.bounds = CGRectMake(0, 0, 0, 0);
    [UIView commitAnimations];
}

- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([animationID compare:@"exitApplication"] == 0) {
        exit(0);
    }
}

/**
 *	save the final score into database
 */
- (void) recordResult
{
    NSLog(@"record result");
    [self.userManager insertScore:self.score];
}

- (void) turnToRankView
{
    
}

@end

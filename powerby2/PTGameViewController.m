//
//  PTFirstViewController.m
//  powerby2
//
//  Created by spacewander on 14-3-12.
//  Copyright (c) 2014年 com.scutknight. All rights reserved.
//

#import "PTGameViewController.h"
#import "PTGrid.h"
#import "PTGridView.h"
#import "globalDefine.h"

// the full screen is 320 * 480
#define FIRST_LABEL_X 180
#define FIRST_LABEL_Y 20
#define SECOND_LABEL_X 260
#define SECOND_LABEL_Y 20
#define LABEL_WIDTH 50
#define LABEL_HEIGHT 20

#define GAME_WIDTH 320
#define GAME_HEIGHT 480

@interface PTGameViewController ()

@property (strong, nonatomic) UILabel *scoreLabel;
@property (strong, nonatomic) UILabel *highestScoreLabel;

@property (strong, nonatomic) PTGrid *gridModel;
@property (strong, nonatomic) PTGridView *gridView;

- (void) setDefaultBackgroundColor:(UIView *)view;
- (void) setDefaultLayoutColor:(UIView *)view;
- (void) setLabelStyle:(UILabel *)label;
@end

@implementation PTGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scoreLabel = [[UILabel alloc] initWithFrame:
                       CGRectMake(FIRST_LABEL_X,FIRST_LABEL_Y, LABEL_WIDTH, LABEL_HEIGHT)];
	self.scoreLabel.text = @"Score";
    [self setLabelStyle:self.scoreLabel];
    [self.view addSubview:self.scoreLabel];
    
    self.highestScoreLabel = [[UILabel alloc] initWithFrame:
                       CGRectMake(SECOND_LABEL_X,SECOND_LABEL_Y, LABEL_WIDTH, LABEL_HEIGHT)];
    self.highestScoreLabel.text = @"0";
    [self setLabelStyle:self.highestScoreLabel];
    [self.view addSubview:self.highestScoreLabel];
    
    self.gridView = [[PTGridView alloc] initWithFrame:
                     CGRectMake(GRID_X, GRID_Y, GRID_WIDTH, GRID_HEIGHT)];
    if (self.gridView == nil) {
        NSLog(@"ERROR : can not init the view of grid!");
        exit(1);
    }
    [self.view addSubview:self.gridView];
    self.gridModel = [self.gridModel initWithGrid:[NSArray arrayWithObjects:
                                                   GRIDS,
                                                   nil]];
    
    [self startGame];
}

- (void) loadView
{
    [super loadView];
    // create a full screen
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GAME_WIDTH, GAME_HEIGHT)];
    [self setDefaultBackgroundColor:self.view];
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

- (void) startGame
{
    [self.gridModel setRandomValue];
    [self.gridView updateGridWithGridNumber:self.gridModel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return NO;
}

@end

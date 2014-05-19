//
//  PTSecondViewController.m
//  powerby2
//
//  Created by spacewander on 14-3-12.
//  Copyright (c) 2014年 com.scutknight. All rights reserved.
//

#import "PTInfoViewController.h"
#import "PTRankCell.h"
#import "globalDefine.h"

#define CELL_WIDTH 320
#define CELL_HEIGHT 240

static NSString *CellIdentifier = @"Cell";

@interface PTInfoViewController ()

@property (nonatomic) UITableView *ranks;
@property (weak, nonatomic) IBOutlet UITextView *description;

@property (nonatomic) NSUInteger ranger;

- (void) setBackgroundColor:(UIView *)view;
@end

@implementation PTInfoViewController

- (void) loadView
{
    [super loadView];
    self.ranger = 8;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setBackgroundColor:self.view];
    
    self.ranks = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CELL_WIDTH, CELL_HEIGHT)
                                              style:UITableViewStylePlain];
    // use self as the UITableViewController
    [self.ranks setDelegate:self];
    [self.ranks setDataSource:self];
    
    [self.ranks registerClass:[PTRankCell class] forCellReuseIdentifier:CellIdentifier];
    [self.view addSubview:self.ranks];
    [self setBackgroundColor:self.ranks];
    [self setBackgroundColor:self.description];
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


- (void)setBackgroundColor:(UIView *)view
{
    view.backgroundColor = [UIColor colorWithRed:BACKGROUND_COLOR_RED green:BACKGROUND_COLOR_GREEN
                                            blue:BACKGROUND_COLOR_BLUE alpha:BACKGROUND_COLOR_ALPHA];
}

#pragma mark - Table view data source

/*
 * Return the number of sections. There is only one section now.
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.ranger;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30.0;
}

/**
 * use customize cell and reuse it if possible
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // reuse if possible
    PTRankCell *cell = (PTRankCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                            forIndexPath:indexPath];

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setIndentationWidth:0.0];

    //set score information
    NSUInteger scoreIndex = [indexPath row]; // 0 ~ self.ranger, 0 is the header
    if ([[[cell class] description] compare:[PTRankCell description]] == NSOrderedSame) {
        [cell setRank:(scoreIndex + 1)];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%u", 0];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self setBackgroundColor:cell];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}

/*
 * To conform to Human Interface Guildelines,
 * since selecting a row would have no effect (such as navigation), make sure that rows cannot be selected.
 */
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end

//
//  PTUserManager.m
//  powerby2
//
//  Created by spacewander on 14-5-19.
//  Copyright (c) 2014年 com.scutknight. All rights reserved.
//

#import "PTUserManager.h"
#import "PTDBController.h"
#import "userManagerDefine.h"

@interface PTUserManager ()

@property (nonatomic) PTDBController *database;

- (void) insertScoreSuccess;
@end

@implementation PTUserManager

/**
 *	mark whether an instance is created
 */
static PTUserManager *sharedSingleton_ = nil;

#pragma mark - singleton instance methods

/**
 *	the only one puclic init method.Avoid to create multi instances
 *
 *	@return	a singleton
 */
+ (PTUserManager *)sharedInstance
{
    if (sharedSingleton_ == nil) {
        sharedSingleton_ = [[super allocWithZone:NULL] init];
        NSLog(@"create single user manager controller");
    }
    return sharedSingleton_;
}

/**
 *	overwrite allocWithZone. Avoid to create copy
 */
+(id)allocWithZone:(NSZone *)zone
{
    return [PTUserManager sharedInstance];
}

/**
 *  overwrite copy. Avoid to create copy
 */
- (id)copy
{
    return self;
}

/**
 *	update all scores when init
 */
- (id)init
{
    if (self = [super init]) {
        self.database = [PTDBController sharedInstance];
        //add observer to database and user model
        [[NSNotificationCenter defaultCenter]
            addObserver:self selector:@selector(insertScoreSuccess) name:UPDATE_DB object:nil];
    }
    
    return self;
}

#pragma mark - handle scores

/**
 *	select several scores which number is equal with rank number from database in descend order.
 *
 *  @param rankNumber  how many scores should be selected.
 *
 *  @return the scores which is selected.
 *  If the size of scores is smaller than rankNumber, use 0 to fill with it.
 */
- (NSMutableArray *) selectScores:(NSUInteger)rankNumber
{
    NSMutableArray *result = [self.database selectScores:rankNumber];
    NSMutableArray *scores = [NSMutableArray arrayWithArray:result];
    // fill the scores array if need
    int gap;
    if ((gap = rankNumber - [scores count]) > 0) {
        while (gap) {
            [scores addObject:[NSNumber numberWithInt:0]];
            gap--;
        }
    }
    return scores;
}

- (NSUInteger) selectHighestScore
{
    NSUInteger highestScore = [self.database selectHighestScore];
    return highestScore;
}

- (void) insertScore:(NSUInteger)score
{
    [self.database insertScore:score];
}

/**
 *	when a score is successfully insert, call the view to ask for latest scores info
 *
 *	@param	_notification	a notification sent by the database
 */
- (void) insertScoreSuccess
{
    //post notification to view controller to refresh view
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_RANK object:nil];
}

@end

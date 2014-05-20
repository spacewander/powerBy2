//
//  PTDBController.m
//  powerby2
//
//  Created by spacewander on 14-5-19.
//  Copyright (c) 2014年 com.scutknight. All rights reserved.
//

#import "PTDBController.h"
#import "userManagerDefine.h"

/**
 *	mark whether an instance is created
 */
static PTDBController *sharedSingleton_ = nil;

@interface PTDBController ()

@property (nonatomic) NSString *dbname;

- (NSString *)dataFilePath;
- (void)connectWithDB:(NSString *)dbname;
- (void)createScoreTable;
@end

@implementation PTDBController

- (id)init
{
    self = [super init];
    if (self) {
        self.dbname = [self dataFilePath];
    }
    return self;
}

/**
 *	@return	the path where user file is in
 */
- (NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:dbFile];
}

#pragma mark - singleton instance methods

/**
 *	the only one puclic init method. Avoid to create multiple instances
 *
 *	@return	a singleton
 */
+ (PTDBController *)sharedInstance
{
    if (sharedSingleton_ == nil) {
        sharedSingleton_ = [[super allocWithZone:NULL] init];
    }
    return sharedSingleton_;
}

/**
 *	overwrite allocWithZone. Avoid to create copy
 */
+(id)allocWithZone:(NSZone *)zone
{
    return [PTDBController sharedInstance];
}

/**
 *  overwrite copy. Avoid to create copy
 */
- (id)copy
{
    return self;
}

#pragma mark - database connect

- (void)connectWithDB:(NSString *)dbname
{
    
}

- (void)createScoreTable
{
    
}

#pragma mark - database control

- (NSUInteger)selectHighestScore
{
    return 0;
}

- (NSMutableArray *)selectScores:(NSUInteger)number
{
    NSMutableArray *scores = [NSMutableArray arrayWithCapacity:number];
    for (NSUInteger i = 0; i < number; ++i) {
        [scores addObject:[NSNumber numberWithInt:0]];
    }
    
    return scores;
}

- (void)insertScore:(NSUInteger)score
{
    //post notification to user manager if insert operator is successful
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_DB object:nil];
}

@end

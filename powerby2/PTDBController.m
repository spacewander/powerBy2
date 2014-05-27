//
//  PTDBController.m
//  powerby2
//
//  Created by spacewander on 14-5-19.
//  Copyright (c) 2014年 com.scutknight. All rights reserved.
//
#import "sqlite3.h"

#import "PTDBController.h"
#import "userManagerDefine.h"

/**
 *	mark whether an instance is created
 */
static PTDBController *sharedSingleton_ = nil;

@interface PTDBController ()

@property (nonatomic) NSString *dbname;
@property (nonatomic) sqlite3 *database;
@property (nonatomic) NSUInteger latestRowid;

- (NSString *)dataFilePath;
- (NSString *)timeStamp;
- (NSUInteger)countCurrentItems;
- (void)connectWithDB;
- (void)closeDB;
- (void)createScoreTable;

@end

@implementation PTDBController

/**
 *	init dbname and database, create table if table is not existed.
 *
 *	@return	self
 */
- (id)init
{
    self = [super init];
    if (self) {
        self.latestRowid = 0;
        self.database = nil;
        self.dbname = [self dataFilePath];
        NSFileManager *filemgr = [NSFileManager defaultManager];
        if ([filemgr fileExistsAtPath: self.dbname ] == YES) {
            [self createScoreTable];
        }
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

/**
 * the NSString looks like 2014-05-20 08:51
 */
- (NSString *)timeStamp
{
    NSDateFormatter* df_local = [[NSDateFormatter alloc] init];
    [df_local setTimeZone:[NSTimeZone localTimeZone]];
    [df_local setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *time = [df_local stringFromDate:[NSDate date]];
    return time;
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

/**
 *	If the database has not opened, connect with the default database and open it
 */
- (void)connectWithDB
{
    if (_database != nil) {
        return;
    }

    NSInteger error;
    if ((error = sqlite3_open([self.dbname UTF8String], &_database)) != SQLITE_OK) {
        NSAssert(0,@"Failed to open database.");
        NSLog(@"%@", [NSString stringWithFormat:@"Failed to open database. error code: %d", error]);
        [self closeDB];
    }
    
    self.latestRowid = [self countCurrentItems];
}

/**
 *	close the database. Don't use the raw sqlite3_close function please!
 */
- (void) closeDB
{
    NSInteger error;
    error = sqlite3_close(_database);
    if (error != SQLITE_OK) {
        NSLog(@"%@", [NSString stringWithFormat:@"Failed to close database. error code: %d", error]);
    }
    self.database = nil;
}

/**
 *	create score table if the table is not existed.
 */
- (void)createScoreTable
{
    [self connectWithDB];
    
    char* errorMsg;
    
    //score table
    NSString *createSQL = @"CREATE TABLE IF NOT EXISTS score(scoreID INTEGER PRIMARY KEY, timestamp VARCHAR, score INTEGER)";
    
    if (sqlite3_exec(_database, [createSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
//        NSAssert1(0, @"Failed to create score table :%s", errorMsg);
        NSLog(@"%@", [NSString stringWithFormat:@"Failed to create score table :%s", errorMsg]);
        [self closeDB];
        return;
    }
    
    [self closeDB];
    NSLog(@"try to create table success");
}

#pragma mark - database control

- (NSUInteger) countCurrentItems
{
    [self connectWithDB];
    
    return 0;
}

/**
 *	select the highest socre
 *
 *	@return	highest score. If select failed, log it and return 0
 */
- (NSUInteger)selectHighestScore
{
    NSMutableArray *highestScoreArray = [self selectScores:1];
    if ([highestScoreArray count] == 1) {
        NSUInteger highestScore = [highestScoreArray[0] unsignedIntValue];
        return highestScore;
    } else {
        NSLog(@"select highest socre failed!");
        return 0;
    }
}

/**
 *	select serveral scores. If the number of score is smaller than the required number,
 *  fill the return array with 0.
 *
 *	@param	number	the required number of socre
 *
 *	@return	an NSMutableArray contains the scores we want
 */
- (NSMutableArray *)selectScores:(NSUInteger)number
{
    NSMutableArray *scores = [NSMutableArray arrayWithCapacity:number];
    // first fill the array with all 0
    for (NSUInteger i = 0; i < number; ++i) {
        [scores addObject:[NSNumber numberWithInt:0]];
    }
    
    [self connectWithDB];
    
    //select N scores
    NSString *queryScoreSQL = [NSString stringWithFormat:
                               @"SELECT * FROM score ORDER BY score.score DESC LIMIT %u", number];
    
    sqlite3_stmt *stmt;
    NSInteger error;
    if ((error = sqlite3_prepare_v2(_database, [queryScoreSQL UTF8String], -1, &stmt, nil))
                                                                                == SQLITE_OK) {
        NSUInteger i = 0;
        // i should be increased
        while (sqlite3_step(stmt) == SQLITE_ROW && i < number) {
            //read a row
//            int scoreid = sqlite3_column_int(stmt, 0);
//            NSString *timestamp = [[NSString alloc] initWithUTF8String:((char*) sqlite3_column_text(stmt, 2))];
            NSNumber *score = [NSNumber numberWithInt:sqlite3_column_int(stmt, 2)];
            
            [scores replaceObjectAtIndex:i withObject:score];
            i++;
        }
        sqlite3_finalize(stmt);
    }
    else {
//        NSAssert(0,@"failed to query");
        sqlite3_finalize(stmt);
//          keep scores NSMutableArray all zero
          NSLog(@"%@", [NSString stringWithFormat:@"failed to query. Error code: %d", error]);
    }
    
    NSLog(@"query scores successfully");
    NSLog(@"%@", [scores description]);
    return scores;
}

/**
 *	insert a score. Log it and notify relative classes if success.
 *
 *	@param	score	the socre used to be inserted
 */
- (void)insertScore:(NSUInteger)score
{
    score = 10;
    // may there is something wrong happened
    if (score <= 0) {
        return;
    }
    
    [self connectWithDB];
    
    char* errorMsg;
    
    //don't need scoreID to create a new score. use the ID automatically generate by DBMS.
    NSString *insertScoreSQL = [NSString stringWithFormat:@"INSERT INTO score(scoreid, timestamp, score) VALUES (%d,'%@',%d)", self.latestRowid + 1, [self timeStamp], score];
    
    if (sqlite3_exec(_database, [insertScoreSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
//        NSAssert(0, @"Failed to insert");
          NSLog(@"Failed to insert : %@", [NSString stringWithFormat:@"%s", errorMsg]);
          [self closeDB];
          return;
    }
    else {
        self.latestRowid = sqlite3_last_insert_rowid(_database);
    }
    
    NSLog(@"insert score successfully");
    
    //post notification to user manager if insert operator is successful
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_DB object:nil];
}

@end

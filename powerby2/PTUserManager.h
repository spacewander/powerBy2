//
//  PTUserManager.h
//  powerby2
//
//  Created by spacewander on 14-5-19.
//  Copyright (c) 2014年 com.scutknight. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *	manage users' data(eg. scores) and connect with the database.
 *
 *  Currently, we just take care of the scores and ranks. 
 *  We don't care about the user's name and other things.
 */
@interface PTUserManager : NSObject

+ (PTUserManager *)sharedInstance;
- (NSMutableArray *)selectScores:(NSUInteger)rankNumber;
- (void)insertScore:(NSUInteger)score;

@end

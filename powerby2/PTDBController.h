//
//  PTDBController.h
//  powerby2
//
//  Created by spacewander on 14-5-19.
//  Copyright (c) 2014年 com.scutknight. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *	All the dull things are done in this tiny class.
 *
 *  Attention! We will only close the database when something error happens 
 *  or the dealloc is called.
 */
@interface PTDBController : NSObject

+ (PTDBController *)sharedInstance;
- (NSUInteger)selectHighestScore;
- (NSMutableArray *)selectScores:(NSUInteger)number;
- (void)insertScore:(NSUInteger)score;

@end

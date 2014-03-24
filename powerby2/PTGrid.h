//
//  PTGrid.h
//  powerby2
//
//  Created by spacewander on 14-3-13.
//  Copyright (c) 2014年 com.scutknight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTGrid : NSObject

@property (strong) NSMutableArray* values;

- (id) initWithGrid:(NSMutableArray *)gridArray;
- (void) setRandomValue;

@end

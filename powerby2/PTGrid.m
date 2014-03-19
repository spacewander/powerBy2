//
//  PTGrid.m
//  powerby2
//
//  Created by spacewander on 14-3-13.
//  Copyright (c) 2014年 com.scutknight. All rights reserved.
//

#import "PTGrid.h"
#import "globalDefine.h"

@implementation PTGrid

- (id)init
{
    self = [super init];
    if (self) {
        self.grid = [NSArray arrayWithObjects:
                     GRIDS,
                     nil];
    }
    return self;
}

- (id)initWithGrid:(NSArray *)gridArray
{
    self = [super init];
    if (self) {
        self.grid = [NSArray arrayWithArray:gridArray];
        NSLog(@"%@",self.grid[0]);
    }
    return self;
}

@end

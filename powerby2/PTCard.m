//
//  PTCard.m
//  powerby2
//
//  Created by spacewander on 14-3-14.
//  Copyright (c) 2014年 com.scutknight. All rights reserved.
//

#import "PTCard.h"

@interface PTCard ()

- (void) setDefaultColors;

@end

@implementation PTCard

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaultColors];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

/**
 *	set default background color and font color
 */
- (void) setDefaultColors
{
    self.backgroundColor = [UIColor colorWithRed:0.98 green:0.97 blue:0.9375 alpha:1.0 ];
}

@end

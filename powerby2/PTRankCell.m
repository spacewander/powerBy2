//
//  PTRankCell.m
//  powerby2
//
//  Created by spacewander on 14-5-16.
//  Copyright (c) 2014年 com.scutknight. All rights reserved.
//

#import "PTRankCell.h"

#define RANK_LENGTH 90

@implementation PTRankCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat height = self.frame.size.height;
        // dirty hack to keep the text in header is on the same baseline with the one in textLabel
        self.header = [[UILabel alloc] initWithFrame:CGRectMake(0, -10, RANK_LENGTH, height)];
        self.header.textAlignment = NSTextAlignmentLeft;
        [self.header setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.header];
        
        self.textLabel.text = [NSString stringWithFormat:@"%d", 0];
        self.textLabel.textAlignment = NSTextAlignmentRight;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

/**
 *	set the index of header
 *
 *	@param	rank	the index of the cell
 */
- (void)setRank:(NSUInteger)rank
{
    if (self.header != nil) {
        self.header.text = [NSString stringWithFormat:@"RANK %u", rank];
    }
}

@end

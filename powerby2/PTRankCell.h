//
//  PTRankCell.h
//  powerby2
//
//  Created by spacewander on 14-5-16.
//  Copyright (c) 2014年 com.scutknight. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *	the cell contains the score according to each rank
 */
@interface PTRankCell : UITableViewCell

@property (nonatomic) UILabel *header;

- (void) setRank:(NSUInteger)rank;
@end

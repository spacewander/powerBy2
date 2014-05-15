//
//  PTCard.h
//  powerby2
//
//  Created by spacewander on 14-3-14.
//  Copyright (c) 2014年 com.scutknight. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *	each PTCard represents a card in the gird
 */
@interface PTCard : UILabel

@property (strong, nonatomic) NSNumber *cardValue;

- (void) update;
- (void) setDefaultStyle;

@end

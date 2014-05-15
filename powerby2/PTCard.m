//
//  PTCard.m
//  powerby2
//
//  Created by spacewander on 14-3-14.
//  Copyright (c) 2014年 com.scutknight. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PTCard.h"

/**
 *	color combination distinguish different background color type
 *  
 *  Currently the rage is from 0(default) to 12
 */
enum ColorCombination {
    DefaultColorCombination = 0,
    FirstColorCombination = 1,
    SecondColorCombination = 2,
    ThirdColorCombination = 3,
    FourthColorCombination = 4,
    FifthColorCombination = 5,
    SixthColorCombination = 6,
    SeventhColorCombination = 7,
    EighthColorCombination = 8,
    NinthColorCombination = 9,
    TenthColorCombination = 10,
    EleventhColorCombination = 11,
    TwelfthColorCombination = 12,
};

// define some colors
#define DEFAULT_RED 0.9
#define DEFAULT_GREEN 0.89
#define DEFAULT_BLUE 0.85
#define DEFAULT_ALPHA 0.35

#define FONT_RED 0.465
#define FONT_GREEN 0.43
#define FONT_BLUE 0.39

@interface PTCard ()

- (void) setColors:(enum ColorCombination)colors;

@end

@implementation PTCard

/**
 *	initialize the instance
 *
 *	@param	frame	the frame is decided by the size of grid and the number of cards.
 *                  It is set by the caller.
 */
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaultStyle];
        self.cardValue = [NSNumber numberWithInt:0];
        [self update];
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
 *	set default style for the card, like background color, font color, etc.
 */
- (void) setDefaultStyle
{
    self.backgroundColor = [UIColor colorWithRed:DEFAULT_RED green:DEFAULT_GREEN
                                            blue:DEFAULT_BLUE alpha:DEFAULT_ALPHA ];
    self.textColor = [UIColor colorWithRed:FONT_RED green:FONT_GREEN blue:FONT_BLUE alpha:1.0];
    
    self.textAlignment = NSTextAlignmentCenter;
    self.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    
    self.layer.cornerRadius = 3.0f;

    self.adjustsFontSizeToFitWidth = YES;
    CGFloat width = self.frame.size.width;
    // this font size is fit in 5 * 5 grid
    self.font = [UIFont fontWithName:@"Helvetica-Bold" size:(width)];
}

/**
 *	set different background according to the color combination
 *
 *	@param	colors	color combination defined by the value of the card
 */
- (void) setColors:(enum ColorCombination)colors
{
    switch (colors) {
        case DefaultColorCombination:
            self.backgroundColor = [UIColor colorWithRed:DEFAULT_RED green:DEFAULT_GREEN
                                                    blue:DEFAULT_BLUE alpha:DEFAULT_ALPHA ];
            break;
        case FirstColorCombination:
            self.backgroundColor = [UIColor colorWithRed:0.93 green:0.89
                                                    blue:0.85 alpha:1.0];
            break;
        case SecondColorCombination:
            self.backgroundColor = [UIColor colorWithRed:0.93 green:0.87
                                                    blue:0.78125 alpha:1.0];
            break;
        case ThirdColorCombination:
            self.backgroundColor = [UIColor colorWithRed:0.945 green:0.69
                                                    blue:0.47 alpha:1.0];
            break;
        case FourthColorCombination:
            self.backgroundColor = [UIColor colorWithRed:0.96 green:0.58
                                                    blue:0.385 alpha:1.0];
            break;
        case FifthColorCombination:
            self.backgroundColor = [UIColor colorWithRed:0.96 green:0.48
                                                    blue:0.37 alpha:1.0];
            break;
        case SixthColorCombination:
            self.backgroundColor = [UIColor colorWithRed:0.96 green:0.37
                                                    blue:0.23 alpha:1.0];
            break;
        case SeventhColorCombination:
            self.backgroundColor = [UIColor colorWithRed:0.925 green:0.80
                                                    blue:0.445 alpha:1.0];
            break;
        case EighthColorCombination:
            self.backgroundColor = [UIColor colorWithRed:0.925 green:0.80
                                                    blue:0.38 alpha:1.0];
            break;
        case NinthColorCombination:
            self.backgroundColor = [UIColor colorWithRed:0.925 green:0.78125
                                                    blue:0.3 alpha:1.0];
            break;
        case TenthColorCombination:
            self.backgroundColor = [UIColor colorWithRed:1 green:0.875
                                                    blue:0.49 alpha:1.0];
            break;
        case EleventhColorCombination:
            self.backgroundColor = [UIColor colorWithRed:1 green:0.89
                                                    blue:0.54 alpha:1.0];
            break;
        case TwelfthColorCombination:
            self.backgroundColor = [UIColor colorWithRed:1 green:0.9
                                                    blue:0.6 alpha:1.0];
            break;
        default:
            break;
    }
}

/**
 *	update the text and style according to the value
 */
- (void) update
{
    int textValue = [self.cardValue intValue];
    
    self.text =  (textValue == 0) ? @"" : [NSString stringWithFormat:@"%d", textValue];
    enum ColorCombination colors = DefaultColorCombination;
    switch (textValue) {
        case 0:
            break;  // default value of colors is DefaultColorCombination
        case 2:
            colors = FirstColorCombination;
            break;
        case 4:
            colors = SecondColorCombination;
            break;
        case 8:
            colors = ThirdColorCombination;
            break;
        case 16:
            colors = FourthColorCombination;
            break;
        case 32:
            colors = FifthColorCombination;
            break;
        case 64:
            colors = SixthColorCombination;
            break;
        case 128:
            colors = SeventhColorCombination;
            break;
        case 256:
            colors = EighthColorCombination;
            break;
        case 512:
            colors = NinthColorCombination;
            break;
        case 1024:
            colors = TenthColorCombination;
            break;
        case 2048:
            colors = EleventhColorCombination;
            break;
            
        
        default: // value > 2048
            colors = TwelfthColorCombination;
            break;
    }
    [self setColors:colors];
}
@end

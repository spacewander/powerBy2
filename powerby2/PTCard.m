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

@property (nonatomic) NSUInteger previousValue;
@property (nonatomic) enum ColorCombination color;

- (void) setupColor;
- (UIColor *)convertColorCombinationToUIColor:(enum ColorCombination)color;
- (void) startAnimation;
- (void) fadeOutThenIn;
- (void) fadeIn;
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
        [self setText:@""];
        self.previousValue = 0;
        self.cardValue = [NSNumber numberWithInt:0];
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
 */
- (void) setupColor
{
    self.backgroundColor = [self convertColorCombinationToUIColor:self.color];
}

/**
 *	convert ColorCombination type to the reponsitive UIColor
 *
 *	@param	color	ColorCombination type, the color combination which should be shown up
 *
 *	@return	reponsitive UIColor
 */
- (UIColor *) convertColorCombinationToUIColor:(enum ColorCombination)color
{
    switch (self.color) {
        case DefaultColorCombination:
            return [UIColor colorWithRed:DEFAULT_RED green:DEFAULT_GREEN
                                                    blue:DEFAULT_BLUE alpha:DEFAULT_ALPHA ];
        case FirstColorCombination:
            return [UIColor colorWithRed:0.93 green:0.89
                                                    blue:0.85 alpha:1.0];
        case SecondColorCombination:
            return [UIColor colorWithRed:0.93 green:0.87
                                                    blue:0.78125 alpha:1.0];
        case ThirdColorCombination:
            return [UIColor colorWithRed:0.945 green:0.69
                                                    blue:0.47 alpha:1.0];
        case FourthColorCombination:
            return [UIColor colorWithRed:0.96 green:0.58
                                                    blue:0.385 alpha:1.0];
        case FifthColorCombination:
            return [UIColor colorWithRed:0.96 green:0.48
                                                    blue:0.37 alpha:1.0];
        case SixthColorCombination:
            return [UIColor colorWithRed:0.96 green:0.37
                                                    blue:0.23 alpha:1.0];
        case SeventhColorCombination:
            return [UIColor colorWithRed:0.925 green:0.80
                                                    blue:0.445 alpha:1.0];
        case EighthColorCombination:
            return [UIColor colorWithRed:0.925 green:0.80
                                                    blue:0.38 alpha:1.0];
        case NinthColorCombination:
            return [UIColor colorWithRed:0.925 green:0.78125
                                                    blue:0.3 alpha:1.0];
        case TenthColorCombination:
            return [UIColor colorWithRed:1 green:0.875
                                                    blue:0.49 alpha:1.0];
        case EleventhColorCombination:
            return [UIColor colorWithRed:1 green:0.89
                                                    blue:0.54 alpha:1.0];
        case TwelfthColorCombination:
            return [UIColor colorWithRed:1 green:0.9
                                                    blue:0.6 alpha:1.0];
        default:
            break;
    }
    // something wrong happens
    return [UIColor colorWithRed:DEFAULT_RED green:DEFAULT_GREEN
                            blue:DEFAULT_BLUE alpha:DEFAULT_ALPHA];
}

/**
 *	update the text and style according to the value
 */
- (void) updateWithAnimated:(BOOL)animated
{
    int textValue = [self.cardValue intValue];
    
    self.text =  (textValue == 0) ? @"" : [NSString stringWithFormat:@"%d", textValue];
    switch (textValue) {
        case 0:
            self.color = DefaultColorCombination;
            break;  // default value of colors is DefaultColorCombination
        case 2:
            self.color = FirstColorCombination;
            break;
        case 4:
            self.color = SecondColorCombination;
            break;
        case 8:
            self.color = ThirdColorCombination;
            break;
        case 16:
            self.color = FourthColorCombination;
            break;
        case 32:
            self.color = FifthColorCombination;
            break;
        case 64:
            self.color = SixthColorCombination;
            break;
        case 128:
            self.color = SeventhColorCombination;
            break;
        case 256:
            self.color = EighthColorCombination;
            break;
        case 512:
            self.color = NinthColorCombination;
            break;
        case 1024:
            self.color = TenthColorCombination;
            break;
        case 2048:
            self.color = EleventhColorCombination;
            break;
            
        
        default: // value > 2048
            self.color = TwelfthColorCombination;
            break;
    }
    
    if (animated == YES) {
        [self startAnimation];
    } else {
        [self setupColor];
    }
    self.previousValue = [self.cardValue intValue];
}

/**
 *	start specified animation according to the previous value of card 
 *  and the current value of it.
 */
- (void) startAnimation
{
    // fade in if there is no visible card before
    if (self.previousValue == 0 &&
            ([self.cardValue intValue] == 2 || [self.cardValue intValue] == 4)) {
        [self fadeIn];
    }
    // fade out then fade in. Called when the card is squeezed
    else if (self.previousValue != 0 && self.previousValue * 2 == [self.cardValue intValue]) {
        [self fadeOutThenIn];
    }
    // simply setup the background color
    else {
        [self setupColor];
    }
}

#pragma mark - animations

/**
 *	fade in new background color from background color
 */
- (void) fadeIn
{
    NSLog(@"fadeIn");
    __block BOOL done = NO;
    [self setupColor];
    [self setAlpha:0.6];
    self.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:0.1 animations:^{
        [self setAlpha:1.0];
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        done = YES;
    }];
    // wait for animation to finish
    while (done == NO) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
    }
}

/**
 *	fade out current background color and fade in a new one
 */
- (void) fadeOutThenIn
{
        NSLog(@"fadeOut");
    __block BOOL done = NO;

    [UIView animateWithDuration:0.03 animations:^{
        [self setAlpha:0.8];
        self.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
        done = YES;
    }];
    // wait for animation to finish
    while (done == NO) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.005]];
    }
    
    [self setupColor];
    [self setAlpha:0.8];
    [UIView animateWithDuration:0.03 animations:^{
        [self setAlpha:1.0];
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        done = NO;
    }];
    // wait for animation to finish
    while (done == YES) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.005]];
    }
}
@end

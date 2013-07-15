//
//  TimeTile.h
//  FlipClock
//
//  Created by B.H.Liu on 13-7-11.
//  Copyright (c) 2013年 Appublisher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h> 

typedef enum {
	kFlipAnimationNormal = 0,
	kFlipAnimationTopDown,
	kFlipAnimationBottomDown
} kFlipAnimationState;

@interface TimeTile : UIView 
{
    UILabel *currentDigitLabel;
    UILabel *nextDigitLabel;
    UIView *topHalfFrontView;
    UIView* bottomHalfFrontView;
    UIView* topHalfBackView;
    UIView* bottomHalfBackView;
    
    NSMutableArray *splittedImages;
    NSMutableArray *digitViews;
    
    kFlipAnimationState animationState;
    NSInteger _currentIndex;
}

@property (nonatomic,readonly) NSInteger currentIndex;

- (void)initDisplayDigit:(NSInteger)digit;
- (void)animateToDigit:(NSInteger)digit;

@end

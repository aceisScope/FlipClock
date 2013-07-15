//
//  FlipClockView.h
//  FlipClock
//
//  Created by B.H.Liu on 13-7-13.
//  Copyright (c) 2013年 Appublisher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeTile.h"

typedef enum {
	kFlipTimeMinute = 0,
	kFlipTimeSecond
} kFlipTimePattern;

@interface FlipClockView : UIView
{
    CGSize tileSize;
    
    TimeTile *h1;
    TimeTile *h2;
    TimeTile *m1;
    TimeTile *m2;
    TimeTile *s1;
    TimeTile *s2;
    
    kFlipTimePattern timePattern;
}

- (void)initDisplayTime:(NSString*)time;
- (void)flipToTime:(NSString*)time;

- (void)setTimePattern:(kFlipTimePattern)pattern;

@end

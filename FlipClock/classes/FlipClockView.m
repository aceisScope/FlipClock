//
//  FlipClockView.m
//  FlipClock
//
//  Created by B.H.Liu on 13-7-13.
//  Copyright (c) 2013年 Appublisher. All rights reserved.
//

#import "FlipClockView.h"

#define MARGIN 10
#define PADDING 5

@implementation FlipClockView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        
        // Default pattern: hh-mm
        timePattern = kFlipTimeMinute;
        tileSize = CGSizeMake(((self.frame.size.width - PADDING*2-MARGIN*3)/4), self.frame.size.height - PADDING*2);
        
        
    }
    return self;
}

- (void)initDisplayTime:(NSString*)time
{
    NSArray *timeDigits = [time componentsSeparatedByString:@"-"];
    if (timeDigits.count < 2) {
        NSLog(@"wrong time format");
        return;
    }
    
    h1 = [[TimeTile alloc]initWithFrame: CGRectMake(MARGIN, PADDING, tileSize.width, tileSize.height)];
    h2 = [[TimeTile alloc]initWithFrame: CGRectMake(MARGIN + tileSize.width + PADDING, PADDING, tileSize.width, tileSize.height)];
    [self addSubview:h1];
    [self addSubview:h2];
    
    [h1 initDisplayDigit:[[timeDigits[0] substringToIndex:1]intValue]];
    [h2 initDisplayDigit:[[timeDigits[0] substringFromIndex:1]intValue]];
    
    m1 = [[TimeTile alloc]initWithFrame:CGRectMake(MARGIN*2 + tileSize.width*2 + PADDING, PADDING, tileSize.width, tileSize.height)];
    m2 = [[TimeTile alloc]initWithFrame:CGRectMake(MARGIN*2 + tileSize.width*3 + PADDING*2, PADDING, tileSize.width, tileSize.height)];
    [self addSubview:m1];
    [self addSubview:m2];
    
    [m1 initDisplayDigit:[[timeDigits[1] substringToIndex:1]intValue]];
    [m2 initDisplayDigit:[[timeDigits[1] substringFromIndex:1]intValue]];
    
    if (timePattern == kFlipTimeSecond && timeDigits.count == 3) {
        s1 = [[TimeTile alloc]initWithFrame:CGRectMake(MARGIN*3 + tileSize.width*4 + PADDING*2, PADDING, tileSize.width, tileSize.height)];
        s2 = [[TimeTile alloc]initWithFrame:CGRectMake(MARGIN*3 + tileSize.width*5 + PADDING*3, PADDING, tileSize.width, tileSize.height)];
        [self addSubview:s1];
        [self addSubview:s2];
        
        [s1 initDisplayDigit:[[timeDigits[2] substringToIndex:1]intValue]];
        [s2 initDisplayDigit:[[timeDigits[2] substringFromIndex:1]intValue]];
    }
    
}

- (void)flipToTime:(NSString*)time
{
    NSArray *timeDigits = [time componentsSeparatedByString:@"-"];
    if (timeDigits.count < 2) {
        NSLog(@"wrong time format");
        return;
    }
    
    NSInteger hour1 = [[timeDigits[0] substringToIndex:1]intValue];
    if (hour1 != h1.currentIndex) {
        [h1 animateToDigit:[[timeDigits[0] substringToIndex:1]intValue]];
    }
    
    NSInteger hour2 = [[timeDigits[0] substringFromIndex:1]intValue];
    if (hour2 != h2.currentIndex) {
        [h2 animateToDigit:[[timeDigits[0] substringFromIndex:1]intValue]];
    }
    
    NSInteger minute1 = [[timeDigits[1] substringToIndex:1]intValue];
    if (minute1 != m1.currentIndex) {
        [m1 animateToDigit:[[timeDigits[1] substringToIndex:1]intValue]];
    }
    
    NSInteger minute2 = [[timeDigits[1] substringFromIndex:1]intValue];
    if (minute2 != m2.currentIndex) {
        [m2 animateToDigit:[[timeDigits[1] substringFromIndex:1]intValue]];
    }
    
    if (timePattern == kFlipTimeSecond && timeDigits.count == 3) {
        NSInteger second1 = [[timeDigits[2] substringToIndex:1]intValue];
        if (second1 != s1.currentIndex) {
            [s1 animateToDigit:[[timeDigits[2] substringToIndex:1]intValue]];
        }
        
        NSInteger second2 = [[timeDigits[2] substringFromIndex:1]intValue];
        if (second2 != s2.currentIndex) {
            [s2 animateToDigit:[[timeDigits[2] substringFromIndex:1]intValue]];
        }
    }
}

- (void)setTimePattern:(kFlipTimePattern)pattern
{
    timePattern = pattern;
    
    tileSize = pattern == kFlipTimeMinute?CGSizeMake(((self.frame.size.width - PADDING*2-MARGIN*3)/4), self.frame.size.height - PADDING*2)
                                         :CGSizeMake(((self.frame.size.width - PADDING*3-MARGIN*4)/6), self.frame.size.height - PADDING*2);
}

@end

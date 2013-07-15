//
//  ViewController.m
//  FlipClock
//
//  Created by B.H.Liu on 13-7-11.
//  Copyright (c) 2013年 Appublisher. All rights reserved.
//

#import "ViewController.h"
#import "FlipClockView.h"

@interface ViewController ()

@property (nonatomic,strong) FlipClockView *clock1;
@property (nonatomic,strong) FlipClockView *clock2;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _clock1 = [[FlipClockView alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
    [self.view addSubview:_clock1];
    [_clock1 setTimePattern:kFlipTimeSecond];
    [_clock1 initDisplayTime:@"12-33-01"];
    _clock1.center = CGPointMake(self.view.frame.size.width/2, 120);
    
    _clock2 = [[FlipClockView alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
    [self.view addSubview:_clock2];
    [_clock2 setTimePattern:kFlipTimeMinute];
    [_clock2 initDisplayTime:@"06-15"];
    _clock2.center = CGPointMake(self.view.frame.size.width/2, 220);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPressed:(id)sender
{
    [_clock1 flipToTime:@"12-45-15"];
    [_clock2 flipToTime:@"08-06"];
}

@end

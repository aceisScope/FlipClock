//
//  TimeTile.m
//  FlipClock
//
//  Created by B.H.Liu on 13-7-11.
//  Copyright (c) 2013年 Appublisher. All rights reserved.
//

#import "TimeTile.h"

#define TEXT_COLOR [UIColor colorWithRed:0.35f green:0.51f blue:0.91f alpha:1.00f]
#define FONT_NAME @"HelveticaNeue-Light"

#pragma mark -
#pragma mark UIView helpers


@interface UIView(Extended)

- (UIImage *) imageByRenderingView;

@end


@implementation UIView(Extended)


- (UIImage *) imageByRenderingView
{
    CGFloat oldAlpha = self.alpha;
    self.alpha = 1;
    UIGraphicsBeginImageContext(self.bounds.size);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    self.alpha = oldAlpha;
	return resultingImage;
}

@end

@interface TimeTile ()

@property (nonatomic,readwrite) NSInteger currentIndex;

@end

@implementation TimeTile

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        digitViews = [NSMutableArray arrayWithObjects:[UIView new],[UIView new],nil];
        splittedImages = [NSMutableArray array];
        
        _currentIndex = -1;
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5.f;
        self.layer.masksToBounds = YES;
    }
    return self;
}



- (void)initDisplayDigit:(NSInteger)digit
{
    [self initDisplayDigitCurrentDigit:digit nextDigit:digit+1];
}

- (void)animateToDigit:(NSInteger)digit
{
    animationState = kFlipAnimationNormal;
    [self setNextDigit:digit];
    [self changeAnimationState];

    _currentIndex = digit>9?0:digit;

}

#pragma mark - private method

- (void)setNextDigit:(NSInteger)nextdigit
{
    [self initDisplayDigitCurrentDigit:_currentIndex nextDigit:nextdigit];
}

- (void)initDisplayDigitCurrentDigit:(NSInteger)currentdigit nextDigit:(NSInteger)nextdigit
{
    if (_currentIndex != currentdigit)
    {
        // Put the first view into array
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        label1.font = [UIFont fontWithName:FONT_NAME size:label1.frame.size.width ];
        label1.text = [NSString stringWithFormat:@"%d",currentdigit%10];
        label1.textAlignment = NSTextAlignmentCenter;
        label1.textColor = TEXT_COLOR;
        label1.backgroundColor = [UIColor whiteColor];
        [self addSubview:label1];
        
        // Put a dividing line over the label
        UIView *lineView1 = [[UIView alloc] init];
        lineView1.backgroundColor = [UIColor whiteColor];
        lineView1.frame = CGRectMake(0.f, 0.f, label1.frame.size.width, 3.f);
        lineView1.center = label1.center;
        [label1 addSubview:lineView1];
        
        digitViews[0] = label1;
        _currentIndex = currentdigit;
        
        [self addSubview:label1];
    }

    
    // Put the second view into array
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	label2.font = [UIFont fontWithName:FONT_NAME size:label2.frame.size.width ];
	label2.text = [NSString stringWithFormat:@"%d",nextdigit%10];
	label2.textAlignment = NSTextAlignmentCenter;
	label2.textColor = TEXT_COLOR;
	label2.backgroundColor = [UIColor whiteColor];
    
    // Put a dividing line over the label
	UIView *lineView2 = [[UIView alloc] init];
	lineView2.backgroundColor = [UIColor whiteColor];
	lineView2.frame = CGRectMake(0.f, 0.f, label2.frame.size.width, 2.f);
	lineView2.center = label2.center;
    [label2 addSubview:lineView2];
    
    if (digitViews.count == 2) {
        digitViews[1] = label2;
    }
    else if (digitViews.count < 2){
        [digitViews addObject:label2];
    }
}


- (NSArray*)splittingImagesForView:(UIView*)view
{
    UIImage *renderedImage = [view imageByRenderingView];
    
    // The size of each part is half the height of the whole image:
	CGSize size = CGSizeMake(renderedImage.size.width, renderedImage.size.height / 2);
    
    // Create image-based graphics context for top half
    UIGraphicsBeginImageContext(size);
    
    // Draw into context, bottom half is cropped off
    [renderedImage drawAtPoint:CGPointMake(0.0,0.0)];
    
    // Grab the current contents of the context as a UIImage
    // and add it to our array
    UIImage *top = UIGraphicsGetImageFromCurrentImageContext();
    
    // Now draw the image starting half way down, to get the bottom half
    [renderedImage drawAtPoint:CGPointMake(0.0,-[renderedImage size].height/2)];
    // And store that image in the array too
    UIImage *bottom = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *topHalfView = [[UIImageView alloc] initWithImage:top];
	UIImageView *bottomHalfView = [[UIImageView alloc] initWithImage:bottom];
    
    return @[topHalfView,bottomHalfView];
}


- (void)flipDownFromCurrentView:(UIView *)currentView toNextView:(UIView *)nextView withDuration:(CGFloat)aDuration
{
    // Get snapshots for the first view:
	NSArray *currentShots = [self splittingImagesForView:currentView];
	topHalfFrontView = currentShots[0];
	bottomHalfFrontView = currentShots[1];
    
    // Move this view to be where the original view is:
	topHalfFrontView.frame = CGRectOffset(topHalfFrontView.frame, currentView.frame.origin.x, currentView.frame.origin.y);
	[self addSubview:topHalfFrontView];
    
    // Move the bottom half into place:
	bottomHalfFrontView.frame = topHalfFrontView.frame;
	bottomHalfFrontView.frame = CGRectOffset(bottomHalfFrontView.frame, 0.f, topHalfFrontView.frame.size.height);
	[self addSubview:bottomHalfFrontView];
	// move original view:
	[currentView removeFromSuperview];
    
    // Get snapshots for the second view:
	NSArray *nextShots = [self splittingImagesForView:nextView];
	topHalfBackView = nextShots[0];
	bottomHalfBackView = nextShots[1];
	topHalfBackView.frame = topHalfFrontView.frame;
	// And place them in the view hierarchy:
	[self insertSubview:topHalfBackView belowSubview:topHalfFrontView];
	bottomHalfBackView.frame = bottomHalfFrontView.frame;
	[self insertSubview:bottomHalfBackView belowSubview:bottomHalfFrontView];
    
    /************************/
    /** applying animation **/
    /************************/
    
    // Skewed identity for camera perspective:
    // We use this instead of setting a sublayer transform on our view's layer,
	// because that gives an undesirable skew on views not centered horizontally.
	CATransform3D skewedIdentityTransform = CATransform3DIdentity;
	float zDistance = 1000;
	skewedIdentityTransform.m34 = 1.0 / -zDistance;

    // Top tile:
	// Set the anchor point to the bottom edge:
	CGPoint newTopViewAnchorPoint = CGPointMake(0.5, 1.0);
	CGPoint newTopViewCenter = [self center:topHalfFrontView.center movedFromAnchorPoint:topHalfFrontView.layer.anchorPoint toAnchorPoint:newTopViewAnchorPoint withFrame:topHalfFrontView.frame];
	topHalfFrontView.layer.anchorPoint = newTopViewAnchorPoint;
	topHalfFrontView.center = newTopViewCenter;
    
    // Add an animation to swing from top to bottom.
	CABasicAnimation *topAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
	topAnim.beginTime = CACurrentMediaTime();
	topAnim.duration = aDuration;
	topAnim.fromValue = [NSValue valueWithCATransform3D:skewedIdentityTransform];
	topAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(skewedIdentityTransform, -M_PI_2, 1.f, 0.f, 0.f)];
	topAnim.delegate = self;
	topAnim.removedOnCompletion = NO;
	topAnim.fillMode = kCAFillModeForwards;
	topAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	[topHalfFrontView.layer addAnimation:topAnim forKey:@"topDownFlip"];
    
    // Bottom tile:
	// Change its anchor point:
	CGPoint newAnchorPointBottomHalf = CGPointMake(0.5f, 0.f);
	CGPoint newBottomHalfCenter = [self center:bottomHalfBackView.center movedFromAnchorPoint:bottomHalfBackView.layer.anchorPoint toAnchorPoint:newAnchorPointBottomHalf withFrame:bottomHalfBackView.frame];
	bottomHalfBackView.layer.anchorPoint = newAnchorPointBottomHalf;
	bottomHalfBackView.center = newBottomHalfCenter;
    
	// Add an animation to swing from top to bottom.
	CABasicAnimation *bottomAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
	bottomAnim.beginTime = topAnim.beginTime + topAnim.duration;
	bottomAnim.duration = topAnim.duration / 3;
	bottomAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(skewedIdentityTransform, M_PI_2, 1.f, 0.f, 0.f)];
	bottomAnim.toValue = [NSValue valueWithCATransform3D:skewedIdentityTransform];
	bottomAnim.delegate = self;
	bottomAnim.removedOnCompletion = NO;
	bottomAnim.fillMode = kCAFillModeBoth;
	bottomAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	[bottomHalfBackView.layer addAnimation:bottomAnim forKey:@"bottomDownFlip"];
    
}

// Scales center points by the difference in their anchor points scaled to their frame size.
// Let you move anchor points around without dealing with CA's implicit frame math.
- (CGPoint)center:(CGPoint)oldCenter movedFromAnchorPoint:(CGPoint)oldAnchorPoint toAnchorPoint:(CGPoint)newAnchorPoint withFrame:(CGRect)frame;
{
	CGPoint anchorPointDiff = CGPointMake(newAnchorPoint.x - oldAnchorPoint.x, newAnchorPoint.y - oldAnchorPoint.y);
	CGPoint newCenter = CGPointMake(oldCenter.x + (anchorPointDiff.x * frame.size.width),
									oldCenter.y + (anchorPointDiff.y * frame.size.height));
	return newCenter;
}

- (void)changeAnimationState;
{
	switch (animationState) {
		case kFlipAnimationNormal:
		{
            UIView *firstView = digitViews[0];
            UIView *nextView = digitViews[1];
            
			[self flipDownFromCurrentView:firstView toNextView:nextView withDuration:.5f];
			animationState = kFlipAnimationTopDown;
		}
			break;
		case kFlipAnimationTopDown:
        {
			// Swap some tiles around:
			[bottomHalfBackView.superview bringSubviewToFront:bottomHalfBackView];
			animationState = kFlipAnimationBottomDown;
        }
			break;
		case kFlipAnimationBottomDown:
		{            
            // Remove unuseful digit views
            [digitViews removeObjectAtIndex:0];
            
			UIView *newView = digitViews[0];
            newView.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
            [self addSubview:newView];
            
			// Remove snapshots
			[topHalfFrontView removeFromSuperview];
			[bottomHalfFrontView removeFromSuperview];
			[topHalfBackView removeFromSuperview];
			[bottomHalfBackView removeFromSuperview];
			topHalfFrontView = bottomHalfFrontView = topHalfBackView = bottomHalfBackView = nil;
                        
			animationState = kFlipAnimationNormal;
		}
			break;
	}
}


#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag;
{
	[self changeAnimationState];
}


@end

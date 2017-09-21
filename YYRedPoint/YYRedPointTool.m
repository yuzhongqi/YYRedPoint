//
//  YYRedPointTool.m
//  YYRedPoint
//
//  Created by YuZhongqi on 2017/9/21.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "YYRedPointTool.h"
#import <QuartzCore/QuartzCore.h>

CGFloat const RedPointDefaultDiameter = 30;
static CGFloat const kCountMagnitudeAdaptationRatio = 0.3;
static CGFloat const kPopStartRatio = .85;
static CGFloat const kPopOutRatio = 1.05;
static CGFloat const kPopInRatio = .95;

@interface YYView : UIView
@property (nonatomic) BOOL isUserChangingBackgroundColor;
@end

@implementation YYView

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    if (self.isUserChangingBackgroundColor) {
        super.backgroundColor = backgroundColor;
        self.isUserChangingBackgroundColor = NO;
    }
}

@end


@implementation YYRedPointTool {
    int curOrderMagnitude;
    UILabel *countLabel;
    YYView *redCircle;
    CGPoint initialCenter;
    CGRect baseFrame;
    CGRect initialFrame;
    BOOL isIndeterminateMode;
}

#pragma maYY - SETUP

- (id)initWithView:(UIView *)view
{
    self = [super init];
    if (!self) return nil;
    
    [self setView:view andCount:0];
    
    return self;
}

- (id)initSmallPointWithView:(UIView *)view
{
    self = [super init];
    if (!self) return nil;
    
    [self setView:view];
    
    return self;
}

- (id)initWithBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    self = [self initWithView:[barButtonItem valueForKey:@"view"]];
    [self scaleCircleSizeBy:0.7];
    [self moveCircleByX:-5.0 Y:0];
    
    return self;
}


- (void)setView:(UIView *)view
{
    curOrderMagnitude = 0;
    
    CGRect frame = view.frame;
    
    isIndeterminateMode = NO;
    
    redCircle = [[YYView alloc]init];
    redCircle.userInteractionEnabled = NO;
    redCircle.isUserChangingBackgroundColor = YES;
    redCircle.backgroundColor = [UIColor redColor];
    
    countLabel = [[UILabel alloc]initWithFrame:redCircle.frame];
    countLabel.userInteractionEnabled = NO;
    self.count = 0;
    [countLabel setTextAlignment:NSTextAlignmentCenter];
    countLabel.textColor = [UIColor clearColor];
    countLabel.backgroundColor = [UIColor clearColor];
    
    [self setCircleAtFrame:CGRectMake(frame.size.width- (RedPointDefaultDiameter*2/3), -RedPointDefaultDiameter/3, 10, 10)];
    
    [view addSubview:redCircle];
    [view addSubview:countLabel];
    [view bringSubviewToFront:redCircle];
    [view bringSubviewToFront:countLabel];
    _redView = view;
    [self checkZero];
}



- (void)setView:(UIView *)view andCount:(int)startCount
{
    curOrderMagnitude = 0;
    
    CGRect frame = view.frame;
    
    isIndeterminateMode = NO;
    
    redCircle = [[YYView alloc]init];
    redCircle.userInteractionEnabled = NO;
    redCircle.isUserChangingBackgroundColor = YES;
    redCircle.backgroundColor = [UIColor redColor];
    
    countLabel = [[UILabel alloc]initWithFrame:redCircle.frame];
    countLabel.userInteractionEnabled = NO;
    self.count = startCount;
    [countLabel setTextAlignment:NSTextAlignmentCenter];
    countLabel.textColor = [UIColor whiteColor];
    countLabel.backgroundColor = [UIColor clearColor];
    
    [self setCircleAtFrame:CGRectMake(frame.size.width- (RedPointDefaultDiameter*2/3), -RedPointDefaultDiameter/3, RedPointDefaultDiameter, RedPointDefaultDiameter)];
    
    [view addSubview:redCircle];
    [view addSubview:countLabel];
    [view bringSubviewToFront:redCircle];
    [view bringSubviewToFront:countLabel];
    _redView = view;
    [self checkZero];
}

- (void)setCircleAtFrame:(CGRect)frame
{
    [redCircle setFrame:frame];
    initialCenter = CGPointMake(frame.origin.x+frame.size.width/2, frame.origin.y+frame.size.height/2);
    baseFrame = frame;
    initialFrame = frame;
    countLabel.frame = redCircle.frame;
    redCircle.layer.cornerRadius = frame.size.height/2;
    [countLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:frame.size.width/2]];
    [self expandToFitLargerDigits];
}

- (void)moveCircleByX:(CGFloat)x Y:(CGFloat)y
{
    CGRect frame = redCircle.frame;
    frame.origin.x += x;
    frame.origin.y += y;
    [self setCircleAtFrame:frame];
}

- (void)scaleCircleSizeBy:(CGFloat)scale
{
    CGRect fr = initialFrame;
    CGFloat width = fr.size.width * scale;
    CGFloat height = fr.size.height * scale;
    CGFloat wdiff = (fr.size.width - width) / 2;
    CGFloat hdiff = (fr.size.height - height) / 2;
    
    CGRect frame = CGRectMake(fr.origin.x + wdiff, fr.origin.y + hdiff, width, height);
    [self setCircleAtFrame:frame];
}

- (void)setCircleColor:(UIColor*)circleColor labelColor:(UIColor*)labelColor
{
    redCircle.isUserChangingBackgroundColor = YES;
    redCircle.backgroundColor = circleColor;
    [countLabel setTextColor:labelColor];
}

- (void)setCircleBorderColor:(UIColor *)color borderWidth:(CGFloat)width {
    redCircle.layer.borderColor = color.CGColor;
    redCircle.layer.borderWidth = width;
}

- (void)hideCount
{
    countLabel.hidden = YES;
    isIndeterminateMode = YES;
}

- (void)showCount
{
    isIndeterminateMode = NO;
    [self checkZero];
}

#pragma maYY - ATTRIBUTES

- (void)increment
{
    [self incrementBy:1];
}

- (void)incrementBy:(int)amount
{
    self.count += amount;
}

- (void)decrement
{
    [self decrementBy:1];
}

- (void)decrementBy:(int)amount
{
    if (amount >= self.count) {
        self.count = 0;
        return;
    }
    self.count -= amount;
}

- (void)setCount:(int)newCount
{
    _count = newCount;
    countLabel.text = [NSString stringWithFormat:@"%@", @(self.count)];
    [self checkZero];
    [self expandToFitLargerDigits];
}

- (void)setCountLabelFont:(UIFont *)font
{
    [countLabel setFont:font];
}

- (UIFont *)countLabelFont
{
    return countLabel.font;
}

#pragma maYY - ANIMATION

-(void)show{
    
    const float height = baseFrame.size.height;
    const float width = baseFrame.size.width;
    const float pop_end_h = height;
    const float pop_end_w = width;
    
    CGRect frame = redCircle.frame;
    CGPoint center = redCircle.center;
    frame.size.height = pop_end_h;
    frame.size.width = pop_end_w;
    redCircle.frame = frame;
    redCircle.center = center;
    
}

- (void)pop
{
    const float height = baseFrame.size.height;
    const float width = baseFrame.size.width;
    const float pop_start_h = height * kPopStartRatio;
    const float pop_start_w = width * kPopStartRatio;
    const float time_start = 0.05;
    const float pop_out_h = height * kPopOutRatio;
    const float pop_out_w = width * kPopOutRatio;
    const float time_out = .2;
    const float pop_in_h = height * kPopInRatio;
    const float pop_in_w = width * kPopInRatio;
    const float time_in = .05;
    const float pop_end_h = height;
    const float pop_end_w = width;
    const float time_end = 0.05;
    
    CABasicAnimation *startSize = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    startSize.duration = time_start;
    startSize.beginTime = 0;
    startSize.fromValue = @(pop_end_h / 2);
    startSize.toValue = @(pop_start_h / 2);
    startSize.removedOnCompletion = FALSE;
    
    CABasicAnimation *outSize = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    outSize.duration = time_out;
    outSize.beginTime = time_start;
    outSize.fromValue = startSize.toValue;
    outSize.toValue = @(pop_out_h / 2);
    outSize.removedOnCompletion = FALSE;
    
    CABasicAnimation *inSize = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    inSize.duration = time_in;
    inSize.beginTime = time_start+time_out;
    inSize.fromValue = outSize.toValue;
    inSize.toValue = @(pop_in_h / 2);
    inSize.removedOnCompletion = FALSE;
    
    CABasicAnimation *endSize = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    endSize.duration = time_end;
    endSize.beginTime = time_in+time_out+time_start;
    endSize.fromValue = inSize.toValue;
    endSize.toValue = @(pop_end_h / 2);
    endSize.removedOnCompletion = FALSE;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    [group setDuration: time_start+time_out+time_in+time_end];
    [group setAnimations:@[startSize, outSize, inSize, endSize]];
    
    [redCircle.layer addAnimation:group forKey:nil];
    
    [UIView animateWithDuration:time_start animations:^{
        CGRect frame = redCircle.frame;
        CGPoint center = redCircle.center;
        frame.size.height = pop_start_h;
        frame.size.width = pop_start_w;
        redCircle.frame = frame;
        redCircle.center = center;
    }completion:^(BOOL complete){
        [UIView animateWithDuration:time_out animations:^{
            CGRect frame = redCircle.frame;
            CGPoint center = redCircle.center;
            frame.size.height = pop_out_h;
            frame.size.width = pop_out_w;
            redCircle.frame = frame;
            redCircle.center = center;
        }completion:^(BOOL complete){
            [UIView animateWithDuration:time_in animations:^{
                CGRect frame = redCircle.frame;
                CGPoint center = redCircle.center;
                frame.size.height = pop_in_h;
                frame.size.width = pop_in_w;
                redCircle.frame = frame;
                redCircle.center = center;
            }completion:^(BOOL complete){
                [UIView animateWithDuration:time_end animations:^{
                    CGRect frame = redCircle.frame;
                    CGPoint center = redCircle.center;
                    frame.size.height = pop_end_h;
                    frame.size.width = pop_end_w;
                    redCircle.frame = frame;
                    redCircle.center = center;
                }];
            }];
        }];
    }];
}


#pragma maYY - HELPERS

- (void)bumpCenterY:(float)yVal
{
    CGPoint center = redCircle.center;
    center.y = initialCenter.y-yVal;
    redCircle.center = center;
    countLabel.center = center;
}

- (void)setAlpha:(float)alpha
{
    redCircle.alpha = alpha;
    countLabel.alpha = alpha;
}

//%%% hides the notification if the value is 0
- (void)checkZero
{
    if (self.count <= 0) {
        redCircle.hidden = YES;
        countLabel.hidden = YES;
    } else {
        redCircle.hidden = NO;
        if (!isIndeterminateMode) {
            countLabel.hidden = NO;
        }
    }
}

- (void)expandToFitLargerDigits {
    int orderOfMagnitude = log10((double)self.count);
    orderOfMagnitude = (orderOfMagnitude >= 2) ? orderOfMagnitude : 1;
    CGRect frame = initialFrame;
    frame.size.width = initialFrame.size.width * (1 + kCountMagnitudeAdaptationRatio * (orderOfMagnitude - 1));
    frame.origin.x = initialFrame.origin.x - (frame.size.width - initialFrame.size.width) / 2;
    
    [redCircle setFrame:frame];
    initialCenter = CGPointMake(frame.origin.x+frame.size.width/2, frame.origin.y+frame.size.height/2);
    baseFrame = frame;
    countLabel.frame = redCircle.frame;
    curOrderMagnitude = orderOfMagnitude;
}







@end

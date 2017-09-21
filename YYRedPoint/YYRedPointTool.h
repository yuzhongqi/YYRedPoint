//
//  YYRedPointTool.h
//  YYRedPoint
//
//  Created by YuZhongqi on 2017/9/21.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT CGFloat const RKNotificationHubDefaultDiameter;

@interface YYRedPointTool : NSObject

//%%% setup
- (id)initWithView:(UIView *)view;
- (id)initSmallPointWithView:(UIView *)view;
- (id)initWithBarButtonItem:(UIBarButtonItem *)barButtonItem;

//%%% adjustment methods
- (void)setView:(UIView *)view andCount:(int)startCount;
- (void)setCircleAtFrame:(CGRect)frame;
- (void)setCircleColor:(UIColor*)circleColor labelColor:(UIColor*)labelColor;
- (void)setCircleBorderColor:(UIColor *)color borderWidth:(CGFloat)width;
- (void)moveCircleByX:(CGFloat)x Y:(CGFloat)y;
- (void)scaleCircleSizeBy:(CGFloat)scale;
@property (nonatomic, strong) UIFont *countLabelFont;

//%%% changing the count
- (void)increment;
- (void)incrementBy:(int)amount;
- (void)decrement;
- (void)decrementBy:(int)amount;
@property (nonatomic, assign) int count;

//%%% hiding / showing the count
- (void)hideCount;
- (void)showCount;

//%%% animations
-(void)show;
- (void)pop;

@property (nonatomic)UIView *redView;

@end

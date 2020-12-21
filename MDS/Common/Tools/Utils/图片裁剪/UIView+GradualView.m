//
//  UIView+GradualView.m
//  SmartEng
//
//  Created by xhj on 2019/10/12.
//  Copyright © 2019 xhj. All rights reserved.
//

#import "UIView+GradualView.h"

@implementation UIView (GradualView)

-(UIView *)gradualColorViewWithTopColor:(UIColor *)startColor andBottomColor:(UIColor *)endColor andCornerRadius:(CGFloat)radius{
    //返回上下的渐变色
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    gradientLayer.colors = @[(__bridge id)startColor.CGColor,(__bridge id)endColor.CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    gradientLayer.cornerRadius = radius ? radius:0;
    [self.layer addSublayer:gradientLayer];
    return self;
}

-(UIView *)gradualColorViewWithLeftColor:(UIColor *)startColor andRightColor:(UIColor *)endColor{
    //返回左右的渐变色
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    gradientLayer.colors = @[(__bridge id)startColor.CGColor,(__bridge id)endColor.CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    [self.layer addSublayer:gradientLayer];
    return self;
}

-(UIView *)removeGradualColorView{
    //移除视图的渐变色
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    gradientLayer.colors = @[(__bridge id)[UIColor whiteColor].CGColor,(__bridge id)[UIColor whiteColor].CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    [self.layer addSublayer:gradientLayer];
    return  self;
}

@end

//
//  UIView+Frame.m
//  ocdk
//
//  Created by 程子扬 on 15-5-16.
//  Copyright (c) 2015年 程子扬. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)
-(CGFloat) x{
    return self.frame.origin.x;
}

-(CGFloat) y{
    return self.frame.origin.y;
}

-(CGFloat) right{
    return self.frame.origin.x + self.frame.size.width;
}

-(CGFloat) bottom{
    return self.frame.origin.y + self.frame.size.height;
}

-(CGFloat) width{
    return self.frame.size.width;
}

-(CGFloat) height{
    return self.frame.size.height;
}

-(void) setX:(CGFloat)x{
    CGRect rect = self.frame;
    rect.origin.x = x;
    self.frame = rect;
}

-(void) setY:(CGFloat)y{
    CGRect rect = self.frame;
     rect.origin.y = y;
    self.frame = rect;
}

-(void) setRight:(CGFloat)right{
    CGRect rect = self.frame;
    rect.origin.x = right - rect.size.width;
    self.frame = rect;
}

-(void) setBottom:(CGFloat)bottom{
    CGRect rect = self.frame;
    rect.origin.y = bottom - rect.size.height;
    self.frame = rect;
}

-(void) setWidth:(CGFloat)width{
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}

-(void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

-(void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

-(void)setSize:(CGSize)size{
    self.width      = size.width;
    self.height     = size.height;
}

-(CGSize)size{
    return CGSizeMake(self.width, self.height);
}

-(void) setHeight:(CGFloat)height{
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

-(CGFloat)centerX {
    return self.center.x;
}

-(CGFloat)centerY {
    return self.center.y;
}

+(void)showAlertView:(NSString *)title message:(NSString *)message{

    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
    
//    [alert AlertinitWithTitle:@"提示" message:message cancelButtonTitle:nil otherButtonTitles:@"确定" cancelButtonBlock:^{
//        
//    } otherButtonBlock:^{
//        
//    }];
}

/**
 * @brief 移除此view上的所有子视图
 */
- (void)removeAllSubviews {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    return;
}

+ (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0,0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

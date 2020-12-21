//
//  UIView+Frame.h
//  ocdk
//
//  Created by 程子扬 on 15-5-16.
//  Copyright (c) 2015年 程子扬. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView (Frame)
-(CGFloat) x;
-(CGFloat) y;
-(CGFloat) right;
-(CGFloat) bottom;
-(CGFloat) width;
-(CGFloat) height;
-(CGFloat)centerX;
-(CGFloat)centerY;
-(CGSize)size;
-(void) setX:(CGFloat) x;
-(void) setY:(CGFloat) y;
-(void)setSize:(CGSize)size;
-(void)setCenterX:(CGFloat)centerX ;
-(void)setCenterY:(CGFloat)centerY;
-(void) setRight:(CGFloat)right;
-(void) setBottom:(CGFloat) bottom;
-(void) setWidth:(CGFloat) width;
-(void) setHeight:(CGFloat) height;

- (void)removeAllSubviews;

+ (UIImage*) createImageWithColor: (UIColor*) color;

//显示提示框
// class func showAlertView(title:String,message:String)
+(void)showAlertView:(NSString *)title message:(NSString *)message;
//纯色转image
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
@end

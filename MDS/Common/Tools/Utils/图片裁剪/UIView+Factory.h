//
//  UIView+Factory.h
//  SmartEng
//
//  Created by rainsoft on 2020/12/15.
//  Copyright © 2020 xhj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Factory)
#pragma mark --- UILabel
+(UILabel*)creatLabWithText:(NSString*)text font:(UIFont*)font color:(UIColor*)color;
+(UILabel*)creatLabWithFont:(UIFont*)font color:(UIColor*)color;
+(void)setLineSpace:(CGFloat)lineSpace withText:(NSString *)text inLabel:(UILabel *)label;

#pragma mark  --- UIButton
+(UIButton*)createBtnWithTitle:(NSString*)title color:(UIColor*)color font:(UIFont*)font;
+(UIButton*)createBtnWithImg:(UIImage*)img title:(NSString*)title color:(UIColor*)color font:(UIFont*)font;
+(UIButton*)createBtnWithImg:(UIImage*)img;

#pragma mark  ---  切圆角
+(void)cut:(UIView*)view cornerRadius:(CGFloat)radius;
+(void)cut:(UIView*)view cornerRadius:(CGFloat)radius  borderColor:( UIColor*)color;

+(UIView*)createViewWithBackgroundColor:(UIColor*)bkColor;
@end

NS_ASSUME_NONNULL_END

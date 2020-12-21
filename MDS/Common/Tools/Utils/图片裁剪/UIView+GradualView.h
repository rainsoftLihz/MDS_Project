//
//  UIView+GradualView.h
//  SmartEng
//
//  Created by xhj on 2019/10/12.
//  Copyright © 2019 xhj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (GradualView)
/** 传递上下颜色返回一个颜色的渐变色视图 */
-(UIView *)gradualColorViewWithTopColor:(UIColor *)startColor andBottomColor:(UIColor *)endColor andCornerRadius:(CGFloat)radius;
/** 传递左右颜色返回一个颜色的渐变色视图 */
-(UIView *)gradualColorViewWithLeftColor:(UIColor *)startColor andRightColor:(UIColor *)endColor;
/** 移除渐变色*/
-(UIView *)removeGradualColorView;
@end

NS_ASSUME_NONNULL_END

//
//  UIView+Factory.m
//  SmartEng
//
//  Created by rainsoft on 2020/12/15.
//  Copyright © 2020 xhj. All rights reserved.
//

#import "UIView+Factory.h"

@implementation UIView (Factory)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"

#pragma mark --- UILabel
+(UILabel*)creatLabWithText:(NSString*)text font:(UIFont*)font color:(UIColor*)color{
    UILabel* lab = [[UILabel alloc] init];
    lab.font = font;
    lab.textColor = color;
    if (text != nil) {
        lab.text = text;
    }
    return lab;
}

+(UILabel*)creatLabWithFont:(UIFont*)font color:(UIColor*)color{
    return [UIView creatLabWithText:@"" font:font color:color];
}

/**
 设置固定行间距文本
 
 @param lineSpace 行间距
 @param text 文本内容
 @param label 要设置的label
 */
+(void)setLineSpace:(CGFloat)lineSpace withText:(NSString *)text inLabel:(UILabel *)label{
    if (!text || !label) {
        return;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;  //设置行间距
    paragraphStyle.lineBreakMode = label.lineBreakMode;
    paragraphStyle.alignment = label.textAlignment;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    label.attributedText = attributedString;
}


#pragma mark --- UITextField
+(UITextField*)creatTextFildWithHolder:(NSString*)holderStr holderColor:(UIColor*)holderColor textClolr:(UIColor*)textColor textFont:(UIFont*)textFont {
    UITextField* textF = [[UITextField alloc] init];
    textF.font = textFont;
    textF.textColor = textColor;
    NSAttributedString *placeHolder = [[NSAttributedString alloc] initWithString:holderStr attributes:
                                       @{NSForegroundColorAttributeName:holderColor,NSFontAttributeName:textF.font}];
    textF.attributedPlaceholder = placeHolder;
    return textF;
}

//左边间距
+(UITextField*)creatTextFildWithHolder:(NSString*)holderStr holderColor:(UIColor*)holderColor textClolr:(UIColor*)textColor textFont:(UIFont*)textFont leftSpace:(CGFloat)space{
    UITextField* textF = [self creatTextFildWithHolder:holderStr holderColor:holderColor textClolr:textColor textFont:textFont];

    UIView *leftView = [[UIView alloc] init];
    leftView.frame = CGRectMake(0, 0, 15, 44);
    textF.leftViewMode = UITextFieldViewModeAlways;
    textF.leftView = leftView;
    return textF;
}

#pragma mark  --- UIButton
+(UIButton*)createBtnWithTitle:(NSString*)title color:(UIColor*)color font:(UIFont*)font{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.titleLabel.font = font;;
    return btn;
}

+(UIButton*)createBtnWithImg:(UIImage*)img title:(NSString*)title color:(UIColor*)color font:(UIFont*)font{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (img) {
        [btn setImage:img forState:UIControlStateNormal];
    }
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.titleLabel.font = font;;
    return btn;
}

+(UIButton*)createBtnWithImg:(UIImage*)img{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (img) {
        [btn setBackgroundImage:img forState:UIControlStateNormal];
        [btn setBackgroundImage:img forState:UIControlStateHighlighted];
    }
    return btn;
}

#pragma mark  ---  切圆角
+(void)cut:(UIView*)view cornerRadius:(CGFloat)radius{
    [self cut:view cornerRadius:radius borderColor:nil];
}

+(void)cut:(UIView*)view cornerRadius:(CGFloat)radius  borderColor:( UIColor*)color{
    view.layer.cornerRadius = radius;
    view.layer.masksToBounds = YES;
    if (color) {
        view.layer.borderWidth = 0.8;
        view.layer.borderColor = color.CGColor;
    }
}



+(UIView*)createViewWithBackgroundColor:(UIColor*)bkColor{
    UIView* llView = [[UIView alloc] init];
    llView.backgroundColor = bkColor;
    return llView;
}


#pragma mark --- 计算文字大小
+(CGSize)calStrWith:(NSString*)text andFontSize:(CGFloat)fontsize{
    CGSize size=[text boundingRectWithSize:CGSizeMake(MAXFLOAT,MAXFLOAT)
                                   options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontsize]}context:nil].size;
    return size;
}

#pragma clang diagnostic pop
@end

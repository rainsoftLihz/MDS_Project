//
//  UIView+Img.h
//  MDS
//
//  Created by rainsoft on 2020/12/16.
//  Copyright © 2020 jzt. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Img)
+(UIImage*)imageFromView:(UIView *) v rect:(CGRect) rect;

+(UIImage *)clipImgFromView:(UIImageView*)imgView clipRect:(CGRect)cropFrame;
@end

NS_ASSUME_NONNULL_END

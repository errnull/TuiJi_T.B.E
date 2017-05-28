//
//  UIImage+Image.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/5/30.
//  Copyright © 2016年 TUIJI. All rights reserved.
//


@interface UIImage (Image)

/**
 *  load the original image without rendering
 */
+ (instancetype)imageWithOriginalName:(NSString *)imageName;

+ (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage;

- (UIImage *)imageToUpMirrored;

+ (UIImage *)imageWithTJColor:(UIColor *)color;

+ (UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;
@end

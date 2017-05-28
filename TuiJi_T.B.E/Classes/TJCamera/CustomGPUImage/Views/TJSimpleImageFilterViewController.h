//
//  TJSimpleImageFilterViewController.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/10/26.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TJSimpleImageFilterViewController;

@protocol TJSimpleImageFilterDelegate <NSObject>

- (void)imageCropper:(TJSimpleImageFilterViewController *)cropperViewController didFinished:(UIImage *)editedImage;
- (void)imageCropperDidCancel:(TJSimpleImageFilterViewController *)cropperViewController;

@end

@interface TJSimpleImageFilterViewController : UIViewController

- (instancetype)initWithImage:(UIImage *)originalImage
                    cropFrame:(CGRect)cropFrame
              limitScaleRatio:(CGFloat)limitRatio;

@property (nonatomic ,assign) CGRect cropFrame;

/**
 *  original image
 */
@property (nonatomic, weak) UIImage *originalImage;


/**
 *  limitRatio
 */
@property (nonatomic ,assign) CGFloat limitRatio;

@property (nonatomic ,assign) id<TJSimpleImageFilterDelegate> delegate;
@end

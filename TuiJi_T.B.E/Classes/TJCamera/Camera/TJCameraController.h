//
//  TJCameraController.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/10/22.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJCameraController : UIViewController

+ (instancetype)cameraViewController;

@property (copy, nonatomic) GenericCallback callback;

@property (nonatomic ,assign) BOOL isCameraForIcon;

@property (nonatomic ,assign) BOOL isOnlyForVideo;

@end

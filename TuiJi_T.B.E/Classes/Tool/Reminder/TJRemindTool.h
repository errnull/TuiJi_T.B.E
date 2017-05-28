//
//  TJRemindTool.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/7/28.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBProgressHUD;

@interface TJRemindTool : NSObject

+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;


+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;

+ (MBProgressHUD *)showMessage:(NSString *)message;

+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;

//+ (MBProgressHUD *)showLoadIng:(NSString *)loading;
//+ (MBProgressHUD *)showLoadIng:(NSString *)loading toView:(UIView *)view;


@end

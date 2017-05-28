//
//  TJRemindTool.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/7/28.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJRemindTool.h"
#import "MBProgressHUD.h"

#define TJRemindTime 1.2f

@implementation TJRemindTool


+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}
+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self hideHUD];
    
    if (view == nil) view = TJKeyWindow;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    // Set the custom view mode to show any view.
    hud.mode = MBProgressHUDModeCustomView;
    // Set an image view with a checkmark.
    UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    // Looks a bit nicer if we make it square.
    hud.square = YES;
    // Optional label text.
    hud.label.text = success;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // Change the background view style and color.
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    [hud hideAnimated:YES afterDelay:TJRemindTime];
}

+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}
+ (void)showError:(NSString *)error toView:(UIView *)view
{
    [self hideHUD];
    
    if (view == nil) view = TJKeyWindow;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = error;
    // Move to bottm center.
    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // Change the background view style and color.
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    
    [hud hideAnimated:YES afterDelay:TJRemindTime];
}



+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view
{
    [self hideHUD];
    
    if (view == nil) view = TJKeyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;

    // Change the background view style and color.
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    return hud;
}

//+ (MBProgressHUD *)showLoadIng:(NSString *)loading
//{
//    return [self showLoadIng:loading toView:nil];
//}
//+ (MBProgressHUD *)showLoadIng:(NSString *)loading toView:(UIView *)view
//{
//    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.label.text = loading;
//    
//    // 隐藏时候从父控件中移除
//    hud.removeFromSuperViewOnHide = YES;
//    
//    // Change the background view style and color.
//    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
//    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
//    
//    return hud;
//}

+ (void)hideHUDForView:(UIView *)view
{
    if (view == nil) view = TJKeyWindow;
    [MBProgressHUD hideHUDForView:view animated:YES];
}
+ (void)hideHUD
{
    [self hideHUDForView:nil];
}
@end

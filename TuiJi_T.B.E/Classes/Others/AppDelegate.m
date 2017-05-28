//
//  AppDelegate.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/5/30.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "AppDelegate.h"
#import "TJTabBarController.h"
#import "NTJNotificationCenter.h"
#import "TJCustomAttachmentDecoder.h"

#import <AVOSCloud/AVOSCloud.h>

@interface AppDelegate ()<NIMLoginManagerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // create window
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    //显示状态栏
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    
    //设置第三方
    [self setUpVendorWithOptions:launchOptions];
    
    //创建主数据文件夹
    [TJDataCenter createMainDataFolder];

    //choose root view controller
    [TJGuideTool guideRootViewController:self.window];
    
    //display window
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)dealloc{
    
    [[[NIMSDK sharedSDK] loginManager] removeDelegate:self];
}

/**
 *  生成,保存,提交 ID
 */
- (void)setUpVendorWithOptions:(NSDictionary *)launchOptions
{
    //网易云信 ID 提交
    [[NIMSDK sharedSDK] registerWithAppID:@"ac6eccef8da70e8df0e590297791a920"
                                  cerName:@"DEBUG"];
    
    [NIMCustomObject registerCustomDecoder:[TJCustomAttachmentDecoder new]];
    [[NTJNotificationCenter sharedCenter] start];

    
    //设置云信登录代理
    [[[NIMSDK sharedSDK] loginManager] addDelegate:self];
    
    
    //高德地图 ID
    [TJLocationTool setupAMapServicesApiKey:@"7d96de222e7cd784afb697d55fd0ada3"];
    
    //leadcloud
    [AVOSCloud setApplicationId:@"uVEnRLSuNKawwuelGKlFOGm4-gzGzoHsz" clientKey:@"WgP4L5nu0lTE7RTt1cW2NzmU"];
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [AVOSCloud setAllLogsEnabled:YES];
}

/**
 *  检测上次登录的设备是否当前设备,如果不是,注销账户要求重新登录
 */
- (void)onAutoLoginFailed:(NSError *)error{
    
//    [TJRemindTool showError:@"登录信息失效,请重新登录!"];
//    
//    //清除登录信息
//    [TJAccountTool deleteAccountData];
//    
//    //清空全部旧资料
//    [TJDataCenter deleteAllData];
//    
//    //重新选择根控制器
//    [TJGuideTool guideRootViewController:TJKeyWindow];
}


/**
 * 收到内存警告时调用
 */
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    //停止所有下载
    [[SDWebImageManager sharedManager] cancelAll];
    //删除缓存
    [[SDWebImageManager sharedManager].imageCache clearMemory];
    
}

@end

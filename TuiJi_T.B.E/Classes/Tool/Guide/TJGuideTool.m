//
//  TJGuideTool.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/6/2.
//  Copyright © 2016年 TUIJI. All rights reserved.
//


#import "TJGuideTool.h"
#import "TJNewFeatureController.h"
#import "TJTabBarController.h"
#import "TJSignInNavController.h"
#import "TJSignInViewController.h"
#import "TJInformationViewController.h"
#import "TJAccount.h"

#import "TJTabBar.h"

#define TJVersionKey @"version"
#define TJUserDefaults [NSUserDefaults standardUserDefaults]

@implementation TJGuideTool

+(void)guideRootViewController:(UIWindow *)window
{
    // 选择根控制器
    // 判断下有没有授权
    
    if (TJAccountCurrent) { // 已经授权
        
        if (!([TJAccountCurrent.code isEqualToString:TJStatusUserNeedSetUpInfo])) {
            
//            NIMAutoLoginData *autoLoginData = [[NIMAutoLoginData alloc] init];
//            autoLoginData.account = TJAccountCurrent.userId;
//            autoLoginData.token = TJAccountCurrent.token;
//            
//            [[[NIMSDK sharedSDK] loginManager] autoLogin:autoLoginData];
        }

        
        //判断是否需要初始化个人资料
        if ([TJAccountCurrent.code isEqualToString:TJStatusUserNeedSetUpInfo]) {
            
            TJAccountCurrent.code = TJStatusSussess;
            [TJAccountTool saveAccount:TJAccountCurrent];
            
            // 设置窗口的根控制器
            TJInformationViewController *infoViewController = [[TJInformationViewController alloc] init];
            
            TJSignInNavController *navController = [[TJSignInNavController alloc] initWithRootViewController:infoViewController];
            
            window.rootViewController = navController;
            
            return;
        }
        
        
        
        // 1.获取当前的版本号
        NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
        
        // 2.获取上一次的版本号
        NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:TJVersionKey];
        
        // v1.0
        // 判断当前是否有新的版本
        if ([currentVersion isEqualToString:lastVersion]) { // 没有最新的版本号
            
            // 创建tabBarVc
            TJTabBarController *tabBarVc = [[TJTabBarController alloc] init];
            
            // 设置窗口的根控制器
            window.rootViewController = tabBarVc;
            
            
        }else{ // 有最新的版本号
            
            // 进入新特性界面
            TJNewFeatureController *newFeatureVC = [[TJNewFeatureController alloc] init];
            window.rootViewController = newFeatureVC;
            
            // 保持当前的版本，用偏好设置
            [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:TJVersionKey];
        }

        //设置默认realm数据库
        [RLMRealmConfiguration setDefaultConfiguration:TJMainDataBase.configuration];
        
    }else{
        
        // 设置窗口的根控制器
        TJSignInViewController *signInViewController = [[TJSignInViewController alloc] init];
        
        TJSignInNavController *navController = [[TJSignInNavController alloc] initWithRootViewController:signInViewController];
        
        window.rootViewController = navController;
    }
}


@end

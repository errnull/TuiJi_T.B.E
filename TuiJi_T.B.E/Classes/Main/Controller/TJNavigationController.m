//
//  TJNavigationController.m
//  TuiJi_T.B.E
//
//  Created by zhanZhan on 16/7/14.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJNavigationController.h"
#import "TJTabBarController.h"


@interface TJNavigationController ()<UINavigationControllerDelegate>

@property (nonatomic, strong) id<UIGestureRecognizerDelegate> popDelegate;

@end

@implementation TJNavigationController

#pragma mark - system method 

- (void)pushToLightViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    self.navigationBar.translucent = NO;
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"dark_navigationBarBackGroundWhite.png"] forBarMetrics:UIBarMetricsDefault];
    
    [self pushViewController:viewController animated:animated];
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    if (self = [super initWithRootViewController:rootViewController]) {
        //关闭模糊效果
        self.navigationBar.translucent = NO;
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:TJAutoChooseThemeImage(@"navigationBarBackGround")] forBarMetrics:UIBarMetricsDefault];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //保存代理以复原
    self.popDelegate = self.interactivePopGestureRecognizer.delegate;

    self.delegate = self;
    
    if ([TJUserInfoCurrent.background intValue]) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }else{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
}

/**
 *  设置状态栏字体颜色为白色
 */
//- (UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
//}

/**
 *  set up back button
 */
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    //set up the contents of fault root navigation bar
    if (self.viewControllers.count != 0) {
        
        NSString *backImageName = @"navigationbar_back";
        if([UIApplication sharedApplication].statusBarStyle == UIStatusBarStyleDefault){
            backImageName = @"navigationbar_back_black";
        }
        //左边
        UIBarButtonItem *backBarBtnItem = [TJUICreator createBarBtnItemWithSize:CGSizeMake(20, 20)
                                                                          Image:backImageName
                                                                      highImage:[backImageName stringByAppendingString:@"_highlighted"]
                                                                         target:self
                                                                         action:@selector(back)
                                                               forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = backBarBtnItem;
        
    }
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}


- (void)dealloc{
    NSLog(@"%s",__func__);
}


#pragma mark - NavigationController delegate

/**
 *  导航控制器即将跳转时调用
 */
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    TJTabBarController *tabBarVC = (TJTabBarController *)TJKeyWindow.rootViewController;

    if (![tabBarVC isKindOfClass:[UITabBarController class]]) {
        return;
    }
    
    //移除系统的tabBarButton
    //移除系统自带的tabbarButton
    for (UIView *view in tabBarVC.tabBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [view removeFromSuperview];
        }
    }
}

/**
 *  导航控制器完成跳转时调用
 */
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    //判断根控制器
    if(viewController == self.viewControllers[0]){
        self.interactivePopGestureRecognizer.delegate = self.popDelegate;
    }else{
        self.interactivePopGestureRecognizer.delegate = nil;
    }
}

@end

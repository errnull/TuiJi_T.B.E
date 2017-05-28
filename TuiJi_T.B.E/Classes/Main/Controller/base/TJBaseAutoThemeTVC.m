//
//  TJBaseAutoThemeTVC.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/22.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJBaseAutoThemeTVC.h"

@interface TJBaseAutoThemeTVC ()

@end

@implementation TJBaseAutoThemeTVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    
    if ([TJUserInfoCurrent.background intValue]) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"dark_navigationBarBackGround.png"] forBarMetrics:UIBarMetricsDefault];
        
    }else{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBarBackGround.png"] forBarMetrics:UIBarMetricsDefault];
    }

    
}


@end

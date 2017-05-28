//
//  TJTabBarController.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/5/30.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TJTabBar;

@interface TJTabBarController : UITabBarController

- (void)tabBar:(TJTabBar *)tabBar didClickButton:(NSInteger)index;

@end

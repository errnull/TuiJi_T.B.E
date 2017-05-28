//
//  TJTabBar.h
//  TuiJi
//
//  Created by TUIJI on 16/5/18.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TJTabBar;

@protocol TJTabBarDelegate <NSObject>

@optional
- (void)tabBar:(TJTabBar *)tabBar didClickButton:(NSInteger)index;

@end

@interface TJTabBar : UIView

//items:保存每一个按钮对应的tabBarItem模型
@property (nonatomic ,strong) NSArray *items;

@property (nonatomic, weak) id<TJTabBarDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *buttons;

- (void)btnClick:(UIButton *)button;
@end

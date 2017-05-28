//
//  TJTabBarController.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/5/30.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJTabBarController.h"
#import "TJTabBar.h"

#import "TJHomeTVController.h"
#import "TJContactTVController.h"
#import "TJTimeLineController.h"
#import "TJTimeLineTableView.h"
#import "TJDiscoverViewController.h"
#import "TJProfileViewController.h"


#import "MJRefresh.h"



@interface TJTabBarController ()<TJTabBarDelegate>

@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, strong) TJHomeTVController *home;
@property (nonatomic, strong) TJContactTVController *contact;
@property (nonatomic, strong) TJTimeLineController *timeLine;
@property (nonatomic, strong) TJDiscoverViewController *discover;
@property (nonatomic, strong) TJProfileViewController *profile;

@end

@implementation TJTabBarController

#pragma mark - system method
/**
 *  懒加载
 */
- (NSMutableArray *)items
{
    if (_items == nil) {
        
        _items = [NSMutableArray array];
        
    }
    return _items;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //add all sub view controller
    [self setUpAllSubViewController];
    
    // self define tabBar
    [self setUpTabBar];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //移除系统自带的tabbarButton
    for (UIView *view in self.tabBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [view removeFromSuperview];
        }
    }
}


- (void)dealloc{
    NSLog(@"%s",__func__);
}


#pragma mark - private method
/**
 *  set up all sub view controller
 */
- (void)setUpAllSubViewController
{
    // 首页(消息)
    TJHomeTVController *home = [[TJHomeTVController alloc] init];
    [self setUpOneSubViewController:home
                              image:[UIImage imageNamed:TJAutoChooseThemeImage(@"tabbar_home")]
                      selectedImage:[UIImage imageNamed:TJAutoChooseThemeImage(@"tabbar_home")]
                                title:nil];
    _home = home;
    
    // 联系人
    TJContactTVController *contact = [[TJContactTVController alloc] init];
    [self setUpOneSubViewController:contact
                              image:[UIImage imageNamed:TJAutoChooseThemeImage(@"tabbar_contact")]
                      selectedImage:[UIImage imageNamed:TJAutoChooseThemeImage(@"tabbar_contact")]
                              title:nil];
    _contact = contact;

    // 推几圈
    TJTimeLineController *timeLine = [[TJTimeLineController alloc] init];
    [self setUpOneSubViewController:timeLine
                              image:[UIImage imageNamed:TJAutoChooseThemeImage(@"tabbar_timeline")]
                      selectedImage:[UIImage imageNamed:TJAutoChooseThemeImage(@"tabbar_timeline")]
                              title:nil];
    _timeLine = timeLine;
    
    // 发现
    TJDiscoverViewController *discover = [[TJDiscoverViewController alloc] init];
    [self setUpOneSubViewController:discover
                              image:[UIImage imageNamed:TJAutoChooseThemeImage(@"tabbar_discover")]
                        selectedImage:[UIImage imageNamed:TJAutoChooseThemeImage(@"tabbar_discover")]
                                title:nil];
    _discover = discover;
    
    
    // 我的
    TJProfileViewController *profile = [[TJProfileViewController alloc] init];
    [self setUpOneSubViewController:profile
                              image:[UIImage imageNamed:TJAutoChooseThemeImage(@"tabbar_profile")]
                        selectedImage:[UIImage imageNamed:TJAutoChooseThemeImage(@"tabbar_profile")]
                                title:nil];
    _profile = profile;
}

/**
 *  set up one sub view controller
 */
- (void)setUpOneSubViewController:(UIViewController *)viewController
                              image:(UIImage *)image
                      selectedImage:(UIImage *)selectedImage
                              title:(NSString *)title
{
    viewController.tabBarItem.title = title;
    viewController.tabBarItem.image = image;
    viewController.tabBarItem.selectedImage = selectedImage;
    
    // 保存tabBarItem模型到数组
    [self.items addObject:viewController.tabBarItem];
    
    TJNavigationController *nav = [[TJNavigationController alloc] initWithRootViewController:viewController];
    
    [self addChildViewController:nav];

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect frame = self.tabBar.frame;
    frame.size.height = TJHeightTabBar;
    frame.origin.y = self.view.frame.size.height - frame.size.height;
    self.tabBar.frame = frame;
    

    self.tabBar.barStyle = UIBarStyleBlack;//此处需要设置barStyle，否则颜色会分成上下两层
}

/**
 *  set up tabbar
 */
- (void)setUpTabBar
{
    //自定义tabBar
    TJTabBar *tabBar = [[TJTabBar alloc] initWithFrame:TJRectFromSize(CGSizeMake(self.tabBar.width, TJHeightTabBar))];
    
    tabBar.backgroundColor = TJColorAutoTabNavBg;
    
    //设置代理
    tabBar.delegate = self;
    
    //给tabBar传递tabBarItem模型
    tabBar.items = self.items;
    
    //添加自定义tabBar
    [self.tabBar addSubview:tabBar];
}

#pragma tabBar 代理方法
/**
 *  tabBarButton 点击事件
 */
- (void)tabBar:(TJTabBar *)tabBar didClickButton:(NSInteger)index{
    
    if ((index == 2) && (self.selectedIndex == 2 || _timeLine.timeLineList.count == 0)) { // 点击首页，刷新
        [_timeLine.timeLineTbaleView.mj_header beginRefreshing];
    }
    
    if(index == 4 && self.selectedIndex == 4){
        [_profile reloadData];
    }
    
    self.selectedIndex = index;

}
@end

//
//  TJDiscoverViewController.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/8/17.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJDiscoverViewController.h"

#import "TJGlobalNewsTVC.h"
#import "TJNewsSquareCVC.h"
#import "TJTopScrollView.h"

#import "TJNotificationModel.h"


@interface TJDiscoverViewController ()<TJTopScrollViewDelegate, UIScrollViewDelegate,NIMSystemNotificationManagerDelegate>

@property (nonatomic, strong) NSArray *titleImages;
@property (nonatomic, weak) TJTopScrollView *topScrollView;
@property (nonatomic, weak) UIScrollView *mainScrollView;

@end

@implementation TJDiscoverViewController

#pragma mark - system method

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupChildViewController];
    
    [self setUpMainScrollView];
    
    [self setUpNavigationBar];
    [[[NIMSDK sharedSDK] systemNotificationManager] addDelegate:self];
}

- (void)dealloc{
    [[[NIMSDK sharedSDK] systemNotificationManager] removeDelegate:self];
}

- (void)setUpNavigationBar
{
    //titleView
    UIView *titleView = [TJUICreator createTitleViewWithSize:CGSizeMake(100, 23)
                                                        text:@"全球"
                                                   textColor:TJColorAutoTitle
                                                 sysFontSize:20];
    self.navigationItem.titleView = titleView;
    
    //rightView
    //右边按钮
    UIBarButtonItem *searchBarBtnItem = [TJUICreator createBarBtnItemWithSize:CGSizeMake(18, 18)
                                                                        Image:TJAutoChooseThemeImage(@"navigationbar_search")
                                                                    highImage:TJAutoChooseThemeImage(@"navigationbar_search_highlighted")
                                                                       target:self
                                                                       action:@selector(searchItemClick:)
                                                             forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = searchBarBtnItem;
}

- (void)setupChildViewController
{
    TJNewsSquareCVC *newsSquare = [[TJNewsSquareCVC alloc] init];
    [self addChildViewController:newsSquare];
    
    TJGlobalNewsTVC *globalNews = [[TJGlobalNewsTVC alloc] init];
    [self addChildViewController:globalNews];
}

- (void)setUpMainScrollView
{
    self.titleImages = @[@"discover_square", @"discover_global"];
    
    TJTopScrollView *topScrollView = [TJTopScrollView topScrollViewWithFrame:CGRectMake(0, 0, TJWidthDevice, 40)];
    topScrollView.titleViews = [NSArray arrayWithArray:_titleImages];
    topScrollView.topSrollViewDelegate = self;
    _topScrollView = topScrollView;
    [self.view addSubview:_topScrollView];
    
    // 创建底部滚动视图
    UIScrollView *mainScrollView = [[UIScrollView alloc] init];
    mainScrollView.frame = CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height);
    mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width * _titleImages.count, 0);
    mainScrollView.backgroundColor = [UIColor clearColor];
    // 开启分页
    mainScrollView.pagingEnabled = YES;
    // 没有弹簧效果
    mainScrollView.bounces = NO;
    // 隐藏水平滚动条
    mainScrollView.showsHorizontalScrollIndicator = NO;
    // 设置代理
    mainScrollView.delegate = self;
    _mainScrollView = mainScrollView;
    [self.view addSubview:_mainScrollView];
    
    [self showVc:1];
    [self showVc:0];
    
    [self.view insertSubview:_mainScrollView belowSubview:_topScrollView];
}

// 显示控制器的view
- (void)showVc:(NSInteger)index
{
    
    CGFloat offsetX = index * TJWidthDevice;
    
    UIViewController *vc = self.childViewControllers[index];
    
    // 判断控制器的view有没有加载过,如果已经加载过,就不需要加载
    if (vc.isViewLoaded) return;
    
    [self.mainScrollView addSubview:vc.view];

    vc.view.frame = CGRectMake(offsetX, 0, TJWidthDevice, self.view.height-149);
}

/**
 *  按钮事件点击监听
 */
- (void)searchItemClick:(UIBarButtonItem *)sender
{
    self.tabBarController.tabBar.hidden = YES;
}

#pragma TopScrollView Delegate
- (void)topScrollView:(TJTopScrollView *)topScrollView didSelectTitleAtIndex:(NSInteger)index{
    
    // 1 计算滚动的位置
    CGFloat offsetX = index * self.view.frame.size.width;
    self.mainScrollView.contentOffset = CGPointMake(offsetX, 0);
    
    // 2.给对应位置添加对应子控制器
    [self showVc:index];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    // 计算滚动到哪一页
    NSInteger index = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    // 1.添加子控制器view
    [self showVc:index];
    
    
    // 2.把对应的标题选中
    [[NSNotificationCenter defaultCenter] postNotificationName:@"change" object:@(index) userInfo:nil];
    

}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // 计算滚动到哪一页
    NSInteger index = scrollView.contentOffset.x / scrollView.bounds.size.width;

    // 2.把对应的标题选中
    UIButton *selTitleView = self.topScrollView.allTitleViews[index];
    
    [self.topScrollView selectedTitleView:selTitleView];
}

#pragma mark - NIMSystemNotificationManagerDelegate
- (void)onReceiveCustomSystemNotification:(NIMCustomSystemNotification *)notification{
    TJNotificationModel *notificationModel = [TJNotificationModel mj_objectWithKeyValues:notification.content];
//    if ([notificationModel.code isEqualToString:@"1004"]) {
//        
//    }
}
@end

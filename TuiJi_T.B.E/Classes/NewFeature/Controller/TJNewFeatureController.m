//
//  TJNewFeatureController.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/7/20.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#define TJPageCount 4

#import "TJNewFeatureController.h"
#import "TJNewFeatureCell.h"

@interface TJNewFeatureController ()
/**
 *  页面点
 */
@property (nonatomic, weak) UIPageControl *control;
@end

@implementation TJNewFeatureController

static NSString *reuseID = @"cell";


#pragma mark - system method
- (instancetype)init{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    //设置cell尺寸
    flowLayout.itemSize = TJRectFullScreen.size;
    //清空行距
    flowLayout.minimumLineSpacing = 0;
    //设置滚动方向
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    return [super initWithCollectionViewLayout:flowLayout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册cell
    [self.collectionView registerClass:[TJNewFeatureCell class] forCellWithReuseIdentifier:reuseID];
    
    //禁止分页和弹性
    self.collectionView.pagingEnabled = YES;
    self.collectionView.bounces = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    // 添加pageController
    [self setUpPageControl];
}
// 添加pageController
- (void)setUpPageControl
{
    // 添加pageController,只需要设置位置，不需要管理尺寸
    UIPageControl *control = [[UIPageControl alloc] init];
    
    control.numberOfPages = 4;
    control.pageIndicatorTintColor = [UIColor blackColor];
    control.currentPageIndicatorTintColor = [UIColor redColor];
    
    // 设置center
    control.center = CGPointMake(self.view.width * 0.5, self.view.height);
    _control = control;
    [self.view addSubview:control];
}

#pragma mark - UIScrollView代理
// 只要一滚动就会调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 获取当前的偏移量，计算当前第几页
    int page = scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5;
    
    // 设置页数
    _control.currentPage = page;
}

#pragma mark - collectionView delegate

/**
 *  返回每一组的行数
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return TJPageCount;
}

/**
 *  返回cell内容
 */
- (TJNewFeatureCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TJNewFeatureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseID forIndexPath:indexPath];
    
    //给cell传图片
    
    //拼接图片名称
    NSString *imageName = [NSString stringWithFormat:@"newFeature_0%ld",indexPath.row];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
    
    cell.image = [UIImage imageWithContentsOfFile:path];
    
    [cell setIndexPath:indexPath count:TJPageCount];
    
    
    
    
    
    return cell;
}
@end

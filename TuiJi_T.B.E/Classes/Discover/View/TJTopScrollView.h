//
//  TJTopScrollView.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/8/17.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TJTopScrollView;

@protocol TJTopScrollViewDelegate <NSObject>

- (void)topScrollView:(TJTopScrollView *)topScrollView didSelectTitleAtIndex:(NSInteger)index;

@end

@interface TJTopScrollView : UIScrollView

/**
 *  标题图片名称数组
 */
@property (nonatomic ,strong) NSArray *titleViews;

/**
 *  标题图片
 */
@property (nonatomic, strong) NSMutableArray *allTitleViews;

/**
 *  代理
 */
@property (nonatomic, weak) id<TJTopScrollViewDelegate> topSrollViewDelegate;

/**
 *  类方法
 */
+ (instancetype)topScrollViewWithFrame:(CGRect)frame;

/**
 *  被选中的标题
 */
- (void)selectedTitleView:(UIButton *)titleView;

@end

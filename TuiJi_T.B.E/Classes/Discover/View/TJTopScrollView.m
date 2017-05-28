//
//  TJTopScrollView.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/8/17.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJTopScrollView.h"

@interface TJTopScrollView ()

@property (nonatomic, weak) UIButton *titleVew;

/**
 *  选中的标题imageView
 */
@property (nonatomic, weak) UIButton *selectedTitleView;
//
///**
// *  滑动条
// */
//@property (nonatomic, weak) UIView *indicatorView;

@end

@implementation TJTopScrollView

//指示器的高度
static CGFloat const indicatorHeight = 1;
//形变的度数
static CGFloat const radio = 1.0;

#pragma mark - public method

+ (instancetype)topScrollViewWithFrame:(CGRect)frame
{
    return [[self alloc] initWithFrame:frame];
}

#pragma mark - system method
/**
 *  懒加载
 */
- (NSMutableArray *)allTitleViews{
    if (!_allTitleViews) {
        _allTitleViews = [NSMutableArray array];
    }
    return _allTitleViews;
}
/**
 *  setter方法
 */
- (void)setTitleViews:(NSArray *)titleViews{
    _titleViews = titleViews;;
    
    //创建标题imageView
    CGFloat titleX = 0;
    CGFloat titleH = self.height - indicatorHeight;
    
    CGFloat btnWidth = TJWidthDevice * 0.5;
    CGFloat imageMargin = (btnWidth - 39) * 0.5;
    for (NSInteger i = 0; i < self.titleViews.count; i++) {
        NSString *imageName = titleViews[i];
        NSString *imageNameSele = [imageName stringByAppendingString:@"_h"];
        UIButton *titleView = [TJUICreator createButtonWithSize:CGSizeMake(btnWidth, titleH)
                                                    NormalImage:imageName
                                                  selectedImage:imageNameSele
                                                         target:self
                                                         action:@selector(titleViewClick:)];
        titleView.imageEdgeInsets = UIEdgeInsetsMake(0, imageMargin, 0, imageMargin);
        titleView.x = titleX;
        titleView.tag = i;
        
        titleX += TJWidthDevice*0.5;
        //添加titleView到数组
        [self.allTitleViews addObject:titleView];
        
        // 默认选中第0个
        if (i == 0) {
            [self titleViewClick:titleView];
        }
        
        [self addSubview:titleView];
    }
    // 计算scrollView的宽度
    CGFloat scrollViewWidth = CGRectGetMaxX(self.subviews.lastObject.frame);
    self.contentSize = CGSizeMake(scrollViewWidth, self.frame.size.height);

//    // 添加指示器
//    UIView *indicatorView = [[UIView alloc] init];
//    indicatorView.backgroundColor = TJColorBlackFont;
//    indicatorView.height = indicatorHeight;
//    indicatorView.y = self.frame.size.height - indicatorHeight;
//    _indicatorView = indicatorView;
//    [self addSubview:_indicatorView];
//    
//    
//    // 立刻根据文字内容计算第一个label的宽度
//    _indicatorView.width = TJWidthDevice*0.5;
//    _indicatorView.x = 0;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = TJColorWhite;
        self.showsHorizontalScrollIndicator = NO;
        self.bounces = NO;
        
        //下划线
        UIView *bottomLine = [TJUICreator createLineWithSize:CGSizeMake(TJWidthDevice, 0.5) bgColor:TJColorLine];
        bottomLine.gjcf_origin = CGPointMake(0, self.height - 0.5);
        [self addSubview:bottomLine];
    }
    return self;
}


#pragma mark - private method
- (void)titleViewClick:(UIButton *)sender
{
    //设置选中效果
    [self selectedTitleView:sender];
    
    NSInteger tag = sender.tag;
    
    if ([self.topSrollViewDelegate respondsToSelector:@selector(topScrollView:didSelectTitleAtIndex:)]) {
        [self.topSrollViewDelegate topScrollView:self didSelectTitleAtIndex:tag];
    }
}

/**
 *  设置选中
 */
- (void)selectedTitleView:(UIButton *)titleView {
    // 取消高亮
    _selectedTitleView.selected = NO;
    // 取消形变
    _selectedTitleView.transform = CGAffineTransformIdentity;
    
    // 高亮
    titleView.selected = YES;
    // 形变
    titleView.transform = CGAffineTransformMakeScale(radio, radio);
    
    _selectedTitleView = titleView;
    
//    // 改变指示器位置
//    [UIView animateWithDuration:0.20 animations:^{
//        CGPoint center = self.indicatorView.center;
//        center.x = titleView.center.x;
//        self.indicatorView.center = center;
//    }];
}
@end

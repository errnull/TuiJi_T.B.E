//
//  TJTabBar.m
//  TuiJi
//
//  Created by TUIJI on 16/5/18.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJTabBar.h"
#import "TJTabBarButton.h"


@interface TJTabBar ()

@property (nonatomic, weak) UIButton *selectedButton;

@end

@implementation TJTabBar

#pragma mark - system method
/**
 *  setter方法
 */
- (void)setItems:(NSArray *)items{
    _items = items;
    
    //遍历模型数组,创建对应的tabBarButton
    for (UITabBarItem *item in _items) {
        TJTabBarButton *button = [TJTabBarButton buttonWithType:UIButtonTypeCustom];
        
        //给按钮赋值模型,按钮的内容由模型决定
        button.item = item;
        button.tag = self.buttons.count;
        
        [button addTarget:self
                   action:@selector(btnClick:)
         forControlEvents:UIControlEventTouchDown];
        
        if (button.tag == 2) {
            //当选中第0个
            [self btnClick:button];
        }
        
        [self addSubview:button];
        //把按钮添加到按钮数组中
        [self.buttons addObject:button];
    }
}

/**
 *  懒加载
 */
- (NSMutableArray *)buttons{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

/**
 *  调整子控件的位置
 */
- (void)layoutSubviews{
    [super layoutSubviews];
    
    int i = 0;
    
    CGFloat btnW = self.width / self.buttons.count;

    for (UIView *tabBarButton in self.buttons) {
        //设置tabBarButton的frame
        tabBarButton.frame = CGRectMake(i * btnW, 0, btnW, self.height);
        i++;
    }
    
    UIColor *lineColor = TJColorLine;
    if (![TJUserInfoCurrent.background intValue]) {
        lineColor = TJColorClear;
    }
    
    UIView *lineView = [TJUICreator createLineWithSize:CGSizeMake(TJWidthDevice, 0.5) bgColor:lineColor];
    [TJAutoLayoutor layView:lineView atTheTopMiddleOfTheView:self offset:CGSizeZero];
}

#pragma mark - private Method
/**
 *  点击tabbaButton时调用
 */
- (void)btnClick:(UIButton *)button
{
    _selectedButton.selected = NO;
    _selectedButton.backgroundColor = nil;
    
    //播放动画
    [self runAnimationWithImageView:button];

    button.selected = YES;
    button.backgroundColor = TJColorAutoTabBtnH;

    

    _selectedButton = button;
    
    //通知tabBarVC切换控制器
    if ([_delegate respondsToSelector:@selector(tabBar:didClickButton:)]) {
        [_delegate tabBar:self didClickButton:button.tag];
    }
}

/**
 *  开始播放动画
 */
- (void)runAnimationWithImageView:(UIButton *)button
{
    UIImageView *imageView = button.imageView;
    //如果当前有动画正在执行,就不再开始动画
    if (imageView.isAnimating) {
        return;
    }
    
    //计算
    NSInteger animationCount = 30;
    NSInteger animationIndex = button.tag + 1;
    
    //创建可变数组
    NSMutableArray *images = [NSMutableArray array];
    
    //往数组中添加图片
    for (int index = 0; index < animationCount; index++) {
        //拼接图片名称
        NSString *imageName = [NSString stringWithFormat:@"tabbar_animation%02ld_%02d",(long)animationIndex,index];
        
        //路径
        NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:TJAutoChooseThemeImage(imageName)] ;
        
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        
        [images addObject:image];
    }
    //  把图片赋值给imageView动画数组【帧动画】
    imageView.animationImages = images;
    
    //  整个动画播放一圈的时间
    imageView.animationDuration = 1;
    
    //  动画的重复次数
    imageView.animationRepeatCount = 1;
    
    //  开始播放动画
    [imageView startAnimating];
    
    //在动画执行结束0.1秒后清空animationImages
    CGFloat delay = imageView.animationDuration + 0.1;
    [self performSelector:@selector(clearImagesWithSender:) withObject:imageView afterDelay:delay];  
}

/**
 *  清空动画图片
 */
- (void)clearImagesWithSender:(UIImageView *)sender
{
    sender.animationImages = nil;
}

@end

//
//  TJTabBarButton.m
//  TuiJi_T.B.E
//
//  Created by zhanZhan on 16/7/14.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJTabBarButton.h"
#import "TJbadgeValue.h"

@interface TJTabBarButton ()

@property (nonatomic, weak) TJbadgeValue *badgeView;

@end

@implementation TJTabBarButton

#pragma mark - system method
/**
 *  重写setHighLight方法,取消高亮做的事情
 */
- (void)setHighlighted:(BOOL)highlighted{}

// 懒加载badgeView
- (TJbadgeValue *)badgeView
{
    if (_badgeView == nil) {
        TJbadgeValue *btn = [TJbadgeValue buttonWithType:UIButtonTypeCustom];
        
        [self addSubview:btn];
        
        _badgeView = btn;
    }
    
    return _badgeView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //图片居中
        self.imageView.contentMode = UIViewContentModeCenter;
    }
    return self;
}

/**
 *  setter方法 传递item给tabBarButton的内容赋值
 */
- (void)setItem:(UITabBarItem *)item{
    _item = item;
    
    //KVO:时刻监听一个对象的属性有没有改变
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
    
    [item addObserver:self
           forKeyPath:@"image"
              options:NSKeyValueObservingOptionNew
              context:nil];
    
    [item addObserver:self
           forKeyPath:@"badgeValue"
              options:NSKeyValueObservingOptionNew
              context:nil];
    
}

/**
 *  上方法中只要监听的属性一有新值就会调用这个方法
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    [self setImage:_item.image forState:UIControlStateNormal];
    [self setImage:_item.selectedImage forState:UIControlStateSelected];
    
    // 设置badgeValue
    self.badgeView.badgeValue = _item.badgeValue;
}


/**
 *  移除tabbarButtonitem KVO 观察者
 */
- (void)removeFromSuperview{
    [_item removeObserver:self forKeyPath:@"image"];
    [_item removeObserver:self forKeyPath:@"badgeValue"];
}

/**
 *  修改按钮内部子控件的frame
 */
- (void)layoutSubviews{
    [super layoutSubviews];
    
    //imageView
    self.imageView.frame = TJRectFromSize(self.size);
    
    // 3.badgeView
    self.badgeView.x = self.width - self.badgeView.width - 10;
    self.badgeView.y = 3;

}
@end

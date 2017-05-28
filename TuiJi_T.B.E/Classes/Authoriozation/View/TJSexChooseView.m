//
//  TJSexChooseView.m
//  TJSexChooseButtonDemo
//
//  Created by TuiJi on 16/6/21.
//  Copyright © 2016年 zhanZhanMac. All rights reserved.
//

#import "TJSexChooseView.h"

@interface TJSexChooseView ()

@property (nonatomic, weak) UIButton *manB;
@property (nonatomic, weak) UIButton *womanB;


@end

@implementation TJSexChooseView

- (instancetype)initWithSize:(CGSize)size{
    if (self = [super init]) {
        self.frame = TJRectFromSize(size);
        [self setBackgroundColor:TJColorGrayBg];
        [self setUpSubViews];
        [self layoutSubView];
        self.isMan = YES;
        self.manB.selected = YES;
    }
    return self;
}

- (void)setUpSubViews
{
    //man button
    UIButton *manB = [TJUICreator createButtonWithSize:TJAutoSizeMake(20, 28)
                                           NormalImage:@"man"
                                      selectedImage:@"man_h"
                                                target:self
                                                action:@selector(manBClick)];
    manB.imageEdgeInsets = UIEdgeInsetsMake(4, 3, 4, 3);
    _manB = manB;
    [self addSubview:_manB];
    
    //woman button
    UIButton *womanB = [TJUICreator createButtonWithSize:TJAutoSizeMake(20, 28)
                                           NormalImage:@"woman"
                                      selectedImage:@"woman_h"
                                                target:self
                                                action:@selector(womanBClick)];
    womanB.imageEdgeInsets = UIEdgeInsetsMake(4, 3, 4, 3);
    _womanB = womanB;
    [self addSubview:_womanB];
}

- (void)layoutSubView
{
    [TJAutoLayoutor layView:_manB atTheLeftMiddleOfTheView:self offset:TJAutoSizeMake(12, 0)];
    [TJAutoLayoutor layView:_womanB atTheRightMiddleOfTheView:self offset:TJAutoSizeMake(12, 0)];
}

- (void)manBClick
{
    if (_isMan) {
        return;
    }
    _manB.selected = YES;
    _womanB.selected = NO;
    _isMan = YES;
    
}

- (void)womanBClick
{
    if (!_isMan) {
        return;
    }
    _womanB.selected = YES;
    _manB.selected = NO;
    _isMan = NO;
}

@end

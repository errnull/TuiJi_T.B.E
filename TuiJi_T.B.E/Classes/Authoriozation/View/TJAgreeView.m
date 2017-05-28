//
//  TJAgreeView.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/6/16.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJAgreeView.h"

@interface TJAgreeView ()

@property (nonatomic, weak) UILabel *leftView;
@property (nonatomic, weak) UIButton *rightView;

@end

@implementation TJAgreeView

- (instancetype)initWithsize:(CGSize)size
                      target:(id)target
                      action:(SEL)action
{
    if (self = [super init]) {
        self.frame = TJRectFromSize(size);
        [self setBackgroundColor:TJColorWhiteBg];
        [self setUpSubViewsWithTarget:target action:action];
        [self layoutSubViews];
    }
    return self;
}

/**
 *  set up SubViews
 */
- (void)setUpSubViewsWithTarget:(id)target action:(SEL)action
{
    //leftView
    UILabel *leftView = [TJUICreator createLabelWithSize:CGSizeMake(102, 20)
                                                    text:@"完成注册表示您同意"
                                             sysFontSize:11];
    leftView.backgroundColor = TJColorGrayBg;
    _leftView = leftView;
    [self addSubview:_leftView];
    
    //rightView
    UIButton *rightView = [TJUICreator createButtonWithTitle:@"推己用户服务协定"
                                                        size:CGSizeMake(80, 20)
                                                  titleColor:TJColorGrayFontDark
                                                        font:TJFontWithSize(10)
                                                  buttonType:UIButtonTypeCustom
                                                     bgColor:TJColorClear
                                                      corner:0
                                                      target:target
                                                      action:action];
    _rightView = rightView;
    [self addSubview:rightView];
}



- (void)layoutSubViews
{
    [TJAutoLayoutor layView:_leftView atTheLeftMiddleOfTheView:self offset:CGSizeZero];
    [TJAutoLayoutor layView:_rightView atTheRightMiddleOfTheView:self offset:TJSizeWithHeight(-1.5)];
}


- (void)rightBtnClick
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
    UIWebView *webView = [[UIWebView alloc] init];
    [webView loadRequest:request];
}

@end

//
//  TJInPutView.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/6/6.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJInPutView.h"
#import "TJAnimTextField.h"

#import "TJVerityButton.h"
#import "TJSignUpViewController.h"

#define textHeight 30.0

@interface TJInPutView ()<UITextFieldDelegate>

@property (nonatomic, weak) UIImageView *leftView;
@property (nonatomic, weak) TJAnimTextField *textView;

@end

@implementation TJInPutView

- (NSString *)text{
    
    return _textView.textFiled.text;
}

- (instancetype)initWithsize:(CGSize)size
                        Type:(TJInPutViewType)inPutViewType
{
    if (self = [super init]) {
        self.frame = TJRectFromSize(size);
        [self setBackgroundColor:TJColorGrayBg];
        [self setUpSubViewsWithType:(TJInPutViewType)inPutViewType];
        [self layoutSubViewsWithType:(TJInPutViewType)inPutViewType];
    }
    return self;
}

/**
 *  set up SubViews
 */
- (void)setUpSubViewsWithType:(TJInPutViewType)inPutViewType
{
//    TJInPutViewTypeAccount = 0,        //账号输入
//    TJInPutViewTypePassword,           //密码输入
//    TJInPutViewTypeVerification        //验证码输入
    
    //判断按钮类型
    if (inPutViewType == TJInPutViewTypeAccount) {
        //leftView
        UIImageView *leftView = [TJUICreator createImageViewWithName:@"left_message"
                                                                size:TJAutoSizeMake(18.5, 16)];
        _leftView = leftView;
        [self addSubview:_leftView];
        
        //textField
        TJAnimTextField *textView = [TJUICreator createAnimTextFieldWithSize:TJAutoSizeMake(275, textHeight)
                                                                        Font:TJFontWithSize(16)
                                                                   textColor:TJColorBlackFont
                                                              backgroundColor:TJColorGrayBg
                                                                 borderStyle:UITextBorderStyleNone
                                                                 placeholder:@"请输入账户"
                                                                keyboardType:UIKeyboardTypeNumberPad
                                                               returnKeyType:UIReturnKeyDefault
                                                                    delegate:self];
    


        
        
        textView.textFiled.clearButtonMode = UITextFieldViewModeAlways;
        _textView = textView;
        [self addSubview:_textView];
        
        //rightView
        //none
        
    }else if(inPutViewType == TJInPutViewTypePassword){
        //leftView
        UIImageView *leftView = [TJUICreator createImageViewWithName:@"left_lock"
                                                                size:TJAutoSizeMake(14.5, 17)];
        _leftView = leftView;
        [self addSubview:_leftView];
        
        //textField
        TJAnimTextField *textView = [TJUICreator createAnimTextFieldWithSize:TJAutoSizeMake(275, textHeight)
                                                                        Font:TJFontSize(16)
                                                                   textColor:TJColorBlackFont
                                                             backgroundColor:TJColorGrayBg
                                                                 borderStyle:UITextBorderStyleNone
                                                                 placeholder:@"请输入密码"
                                                                keyboardType:UIKeyboardTypeASCIICapable
                                                               returnKeyType:UIReturnKeyGo
                                                                    delegate:self];
        textView.textFiled.clearButtonMode = UITextFieldViewModeAlways;
        textView.textFiled.secureTextEntry = YES;
        _textView = textView;
        [self addSubview:_textView];
        
        //rightView
        //none
        
    }else if(inPutViewType == TJInPutViewTypeVerification){
        //leftView
        UIImageView *leftView = [TJUICreator createImageViewWithName:@"left_number"
                                                                size:TJAutoSizeMake(16, 17)];
        _leftView = leftView;
        [self addSubview:_leftView];
        
        //textField
        TJAnimTextField *textView = [TJUICreator createAnimTextFieldWithSize:TJAutoSizeMake(193, textHeight)
                                                                        Font:TJFontWithSize(16)
                                                                   textColor:TJColorBlackFont
                                                             backgroundColor:TJColorGrayBg
                                                                 borderStyle:UITextBorderStyleNone
                                                                 placeholder:@"获取验证码"
                                                                keyboardType:UIKeyboardTypeNumberPad
                                                               returnKeyType:UIReturnKeyDefault
                                                                    delegate:self];
        textView.textFiled.clearButtonMode = UITextFieldViewModeAlways;
        
        _textView = textView;
        [self addSubview:_textView];
        
        //rightView
        TJVerityButton *rightView = [TJUICreator createVerityButtonWithSize:TJAutoSizeMake(74, 30)
                                                                      Title:@"获取验证码"
                                                                       font:TJFontWithSize (11)
                                                                       time:30.0
                                                                     corner:12.0
                                                                     target:self
                                                                     action:@selector(getVerityCode)];

        _rightView = rightView;
        [self addSubview:_rightView];

    }else if (inPutViewType == TJInPutViewTypeNickName){
        //leftView
        //none
        
        //textField
        TJAnimTextField *textView = [TJUICreator createAnimTextFieldWithSize:TJAutoSizeMake(self.width, textHeight)
                                                                        Font:TJFontWithSize(17)
                                                                   textColor:TJColor(110, 110, 110)
                                                             backgroundColor:TJColorGrayBg
                                                                 borderStyle:UITextBorderStyleNone
                                                                 placeholder:@"昵称限制15字内, 不以符号开头"
                                                                keyboardType:UIKeyboardTypeDefault
                                                               returnKeyType:UIReturnKeyDefault
                                                                    delegate:self];
        
        textView.textAlignment = NSTextAlignmentCenter;
        _textView = textView;
        [self addSubview:_textView];
        
        //rightView
        //none
    }
}

- (void)getVerityCode
{
    [(TJSignUpViewController *)self.target getVerificationCode];
}
/**
 *  draw a line in the buttom of the view
 */
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(context, 0.0, self.height);
    CGContextAddLineToPoint(context, self.width, self.height);
    
    [TJColorlightGray set];
    
    CGContextSetLineWidth(context, 3.0);
    
    CGContextStrokePath(context);
    
}

- (void)startAnimation
{
    [self.rightView startLoading];
}

- (void)layoutSubViewsWithType:(TJInPutViewType)inPutViewType
{
    CGFloat leftMargin = 8;
    CGFloat rightMargin = 0;
    //判断按钮类型
    if (inPutViewType <= TJInPutViewTypePassword) {
        [TJAutoLayoutor layView:_leftView atTheLeftMiddleOfTheView:self offset:TJSizeWithWidth(leftMargin)];
        [TJAutoLayoutor layView:_textView atTheLeftMiddleOfTheView:self offset:TJSizeWithWidth(40)];
        [TJAutoLayoutor layView:_textView atTheRightMiddleOfTheView:self offset:TJSizeWithWidth(rightMargin)];
        
        
    }else if(inPutViewType == TJInPutViewTypeVerification){
        [TJAutoLayoutor layView:_leftView atTheLeftMiddleOfTheView:self offset:TJSizeWithWidth(leftMargin)];
        [TJAutoLayoutor layView:_textView atTheLeftMiddleOfTheView:self offset:TJSizeWithWidth(40)];
        [TJAutoLayoutor layView:_rightView atTheRightMiddleOfTheView:self offset:TJSizeWithWidth(8)];
        [TJAutoLayoutor layView:_rightView toTheRightOfTheView:_textView span:CGSizeZero];
    }else if (inPutViewType == TJInPutViewTypeNickName){
        [TJAutoLayoutor layView:_textView atCenterOfTheView:self offset:CGSizeMake(0, -10)];
    }
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.textView.placerLabel.alpha = 1.0;
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.textView.textFiled.text.length != 0) {
        [UIView animateWithDuration:0.8 animations:^{
            self.textView.placerLabel.alpha = 0.0;
        }];
    }
}

@end

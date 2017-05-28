//
//  TJAnimTextField.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/6/15.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJAnimTextField.h"

@interface TJAnimTextField ()

{
    BOOL isNull;
    CGFloat labelH;
}

@end

@implementation TJAnimTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        //默认动画
        isNull = YES;
        labelH = 20;
        //占位符
        _placerLabel = [[UILabel alloc]initWithFrame:frame];
        [self addSubview:_placerLabel];
        //输入框
        _textFiled = [[UITextField alloc]initWithFrame:frame];
        _textFiled.borderStyle = UITextBorderStyleRoundedRect;
        [_textFiled addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventEditingChanged];
        _textFiled.backgroundColor = [UIColor clearColor];
        [self addSubview:_textFiled];
    }
    return self;
}
#pragma mark - 占位符颜色
-(void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;
    _placerLabel.textColor = _placeholderColor;
}

#pragma mark - 对齐方式
-(void)setTextAlignment:(NSTextAlignment)textAlignment{
    _textAlignment = textAlignment;
    _placerLabel.textAlignment = _textAlignment;
    _textFiled.textAlignment = _textAlignment;
}
#pragma mark - 占位符
-(void)setPlaceStr:(NSString *)placeStr{
    _placeStr = placeStr;
    _placerLabel.text = _placeStr;
    
}
#pragma mark - 字体
- (void)setPlaceholderFont:(UIFont *)placeholderFont{
    _placeholderFont = placeholderFont;
    _placerLabel.font = _placeholderFont;
    _textFiled.font = _placeholderFont;
}
#pragma mark - 输入框文字颜色
-(void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    _textFiled.textColor = _textColor;
}

#pragma mark -监测textField的输入
-(void)valueChange:(UITextField*)sender{
    
    [self animationBound];
    //取出当前输入的文字
    _textInput = sender.text;
    
}

#pragma mark -弹簧的动画
-(void)animationBound{
    CGRect labelRect = self.textFiled.frame ;
    if (isNull) {
        isNull = NO;
        labelRect.origin.y = self.textFiled.frame.origin.y - self.textFiled.frame.size.height + 6;
        //开始描写动画效果
        [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.3 initialSpringVelocity:5.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.placerLabel.frame = labelRect;
        } completion:nil];
    }else if (!_textFiled.text.length){
        isNull = YES;
        labelRect.origin.y = self.textFiled.frame.origin.y;
        [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.3 initialSpringVelocity:5.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.placerLabel.frame = labelRect;
        } completion:nil];
    }
}

@end

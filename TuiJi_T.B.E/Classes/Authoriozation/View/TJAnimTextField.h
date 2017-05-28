//
//  TJAnimTextField.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/6/15.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJAnimTextField : UIView

/**
 *  输入框文字颜色
 */
@property(strong,nonatomic) UIColor *textColor;
/**
 *  占位符
 */
@property (copy,nonatomic)NSString *placeStr;
/**
 *  占位符颜色
 */
@property(strong,nonatomic) UIColor *placeholderColor;
/**
 *  占位符字体，和textField字体大小相同
 */
@property(strong,nonatomic) UIFont *placeholderFont;
/**
 *  文字对齐方式
 */
@property (assign,nonatomic)NSTextAlignment textAlignment;
/**
 *  输入的文字类容
 */
@property (copy,nonatomic,readonly)NSString *textInput;


@property (strong,nonatomic)UITextField *textFiled;
@property (strong,nonatomic)UILabel *placerLabel;

@end

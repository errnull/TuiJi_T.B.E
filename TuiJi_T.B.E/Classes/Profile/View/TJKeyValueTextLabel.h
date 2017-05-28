//
//  TJKeyValueTextLabel.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 2016/9/29.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJKeyValueTextLabel : UILabel

/**
 *  标题文本
 */
@property (nonatomic ,copy) NSString *keyText;

/**
 *  内容文本
 */
@property (nonatomic ,copy) NSString *valueText;

- (instancetype)initWithSize:(CGSize)size
                     textKey:(NSString *)textKey
                   textValue:(NSString *)textValue
                    keyColor:(UIColor *)keyColor
                  valueColor:(UIColor *)valueColor
                     keyFont:(UIFont *)keyFont
                   valueFont:(UIFont *)valueFont;
@end

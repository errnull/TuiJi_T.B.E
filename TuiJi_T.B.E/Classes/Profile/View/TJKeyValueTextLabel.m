//
//  TJKeyValueTextLabel.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 2016/9/29.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJKeyValueTextLabel.h"

@implementation TJKeyValueTextLabel

- (instancetype)initWithSize:(CGSize)size
                     textKey:(NSString *)textKey
                   textValue:(NSString *)textValue
                    keyColor:(UIColor *)keyColor
                  valueColor:(UIColor *)valueColor
                     keyFont:(UIFont *)keyFont
                   valueFont:(UIFont *)valueFont
{
    if (self = [super initWithFrame:TJRectFromSize(size)]) {
        
        textValue = TJStringIsNull(textValue) ? @"  " : textValue;
        
        NSString *totalStr = [textKey stringByAppendingString:textValue];
        
        NSMutableAttributedString *abs = [[NSMutableAttributedString alloc] initWithString:totalStr];
        
        //range
        NSRange keyRange = [totalStr rangeOfString:textKey];
        NSRange valueRange = [totalStr rangeOfString:textValue];
        
        //设置字体大小
        [abs addAttribute:NSFontAttributeName value:keyFont range:keyRange];
        [abs addAttribute:NSFontAttributeName value:valueFont range:valueRange];
        
        //颜色
        [abs addAttribute:NSForegroundColorAttributeName value:keyColor range:keyRange];
        [abs addAttribute:NSForegroundColorAttributeName value:valueColor range:valueRange];
        
        self.attributedText = abs;
    }
    return self;
}

@end

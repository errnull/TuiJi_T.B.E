//
//  UIColor+TJColor.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/13.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "UIColor+TJColor.h"

static NSMutableArray *_ramdomColorList;

@implementation UIColor (TJColor)

+ (NSMutableArray *)ramdomColorList
{
    if (!_ramdomColorList) {
        
        _ramdomColorList = [NSMutableArray array];
        
        [_ramdomColorList addObject:TJColor(255, 227, 251)];
        [_ramdomColorList addObject:TJColor(232, 255, 140)];
        [_ramdomColorList addObject:TJColor(255, 222, 201)];
        [_ramdomColorList addObject:TJColor(245, 164, 51)];
        [_ramdomColorList addObject:TJColor(179, 209, 193)];
        [_ramdomColorList addObject:TJColor(167, 148, 150)];
        [_ramdomColorList addObject:TJColor(219, 217, 183)];
        [_ramdomColorList addObject:TJColor(229, 123, 133)];
        [_ramdomColorList addObject:TJColor(137, 119, 179)];
        [_ramdomColorList addObject:TJColor(214, 208, 206)];
        [_ramdomColorList addObject:TJColor(129, 194, 214)];
        [_ramdomColorList addObject:TJColor(129, 146, 214)];
        [_ramdomColorList addObject:TJColor(217, 179, 230)];
        [_ramdomColorList addObject:TJColor(220, 247, 161)];
        [_ramdomColorList addObject:TJColor(242, 114, 125)];
        [_ramdomColorList addObject:TJColor(190, 217, 132)];
        [_ramdomColorList addObject:TJColor(242, 195, 107)];
        [_ramdomColorList addObject:TJColor(242, 147, 92)];
        [_ramdomColorList addObject:TJColor(242, 106, 75)];
        [_ramdomColorList addObject:TJColor(141, 124, 105)];
    }
    return _ramdomColorList;
}

+ (UIColor *)randomColorInListWithAlpha:(CGFloat)alpha
{
    [self ramdomColorList];
    
    //生成0 - 20随机数
    NSInteger ramdomNum = arc4random() % 20;
    
    return [_ramdomColorList[ramdomNum] colorWithAlphaComponent:alpha];
}


@end

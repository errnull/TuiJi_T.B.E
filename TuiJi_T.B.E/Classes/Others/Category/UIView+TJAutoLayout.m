//
//  UIView+TJAutoLayout.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/6/6.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "UIView+TJAutoLayout.h"

@implementation UIView (TJAutoLayout)

- (CGPoint)tjPoint
{
    //刷新布局
    [self.superview layoutIfNeeded];
    [self layoutIfNeeded];
    return self.frame.origin;
}

- (CGSize)tjSize
{
    //刷新布局
    [self layoutIfNeeded];
    [self.superview layoutIfNeeded];
    return self.frame.size;
}
@end

//
//  UIView+TJAutoLayout.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/6/6.
//  Copyright © 2016年 TUIJI. All rights reserved.
//
/**
 *  此类提供自动布局后view的宽高和坐标
 */


@interface UIView (TJAutoLayout)

@property (nonatomic ,assign, readonly) CGPoint tjPoint;
@property (nonatomic ,assign, readonly) CGSize tjSize;

@end

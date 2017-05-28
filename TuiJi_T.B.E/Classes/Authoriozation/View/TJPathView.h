//
//  TJPathView.h
//  TJVerityBtnDemo
//
//  Created by TUIJI on 16/6/19.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PROGRESS_LINE_WIDTH 2 //弧线的宽度
#define degressToRadius(ang) (M_PI*(ang)/180.0f) //把角度转换成PI的方式

@interface TJPathView : UIView
{
//    CAShapeLayer * _trackLayer;
    CAShapeLayer * _progressLayer;
}


- (instancetype)initWithFrame:(CGRect)frame time:(NSTimeInterval)time;

@end

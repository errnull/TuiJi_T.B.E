//
//  TJPathView.m
//  TJVerityBtnDemo
//
//  Created by TUIJI on 16/6/19.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJPathView.h"

#define RYUIColorWithRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@implementation TJPathView


- (instancetype)initWithFrame:(CGRect)frame time:(NSTimeInterval)time{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        [self gradentWithFrame:frame time:time];
    }
    return self;
}

- (void)gradentWithFrame:(CGRect)frame time:(NSTimeInterval)time
{
    
    //设置贝塞尔曲线
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)
                                                        radius:(frame.size.width-PROGRESS_LINE_WIDTH)/2-5
                                                    startAngle:degressToRadius(-87)
                                                      endAngle:degressToRadius(273)
                                                     clockwise:YES];
    
    //遮罩层
    
    _progressLayer = [CAShapeLayer layer];
    
    _progressLayer.frame = self.bounds;
    
    _progressLayer.fillColor =  [[UIColor clearColor] CGColor];
    //    _progressLayer.fillColor =  [[UIColor whiteColor] CGColor];
    
    _progressLayer.strokeColor=[UIColor blackColor].CGColor;
    
    //线边角
    _progressLayer.lineCap = kCALineCapRound;
    
    
    //线宽
    _progressLayer.lineWidth = PROGRESS_LINE_WIDTH;
    
    
    
    //渐变图层
    CALayer * grain = [CALayer layer];
    
    
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(self.bounds.size.width/2-10, 0, self.bounds.size.width/2+10, self.bounds.size.height);
    
    
    [gradientLayer setColors:[NSArray arrayWithObjects:(id)[RYUIColorWithRGB(1, 148, 230) CGColor],(id)[RYUIColorWithRGB(0, 185, 255) CGColor], nil]];
    
    [gradientLayer setLocations:@[@0.01,@0.99]];
    
    [gradientLayer setStartPoint:CGPointMake(0.05, 1)];
    
    [gradientLayer setEndPoint:CGPointMake(0.9, 0)];
    [grain addSublayer:gradientLayer];
    
    
    CAGradientLayer * gradientLayer1 = [CAGradientLayer layer];
    gradientLayer1.frame = CGRectMake(0, 0, self.bounds.size.width/2, self.bounds.size.height);
    
    
    [gradientLayer1 setColors:[NSArray arrayWithObjects:(id)[RYUIColorWithRGB(0, 106, 205) CGColor],(id)[RYUIColorWithRGB(1, 148, 230) CGColor], nil]];
    [gradientLayer1 setLocations:@[@0.3,@1]];
    
    [gradientLayer1 setStartPoint:CGPointMake(0.9, 0.05)];
    
    [gradientLayer1 setEndPoint:CGPointMake(1, 1)];
    [grain addSublayer:gradientLayer1];
    
    //用progressLayer来截取渐变层 遮罩
    
    [grain setMask:_progressLayer];
    
    [self.layer addSublayer:grain];
    
    
    //增加动画
    
    CABasicAnimation *pathAnimation=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    
    //时间
    pathAnimation.duration = time;
    
    pathAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    pathAnimation.fromValue=[NSNumber numberWithFloat:0.0f];
    
    pathAnimation.toValue=[NSNumber numberWithFloat:1.0f];
    
    pathAnimation.autoreverses=NO;
    pathAnimation.repeatCount = INFINITY;
    _progressLayer.path=path.CGPath;
    
    [_progressLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
}
@end

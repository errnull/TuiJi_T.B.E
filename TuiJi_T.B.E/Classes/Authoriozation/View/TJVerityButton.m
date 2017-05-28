//
//  TJVerityButton.m
//  TJVerityBtnDemo
//
//  Created by TUIJI on 16/6/17.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJVerityButton.h"
#import "TJPathView.h"

@interface TJVerityButton ()


@end

@implementation TJVerityButton
{
    CGFloat defaultW;
    CGFloat defaultH;
    CGFloat defaultR;
    CGFloat scale;
    UIView *bgView;
    NSTimeInterval _time;
    TJPathView *_path;
}

-(instancetype)initWithFrame:(CGRect)frame
                    setTitle:(NSString *)title
                        font:(UIFont *)font
                        time:(NSTimeInterval)time
                      corner:(float)corner
                      target:(id)target
                      action:(SEL)action
{
    if (self = [super initWithFrame:frame]) {
        [self initSetting];
        
        _time = time;
        
        //旋转中心颜色 跳出颜色
        self.contentColor = [UIColor colorWithRed:219/255.0 green:227/255.0 blue:236/255.0 alpha:1.0];
        
        //旋转颜色
        self.progressColor = [UIColor greenColor];
        
        [self.forDisplayButton setTitle:title forState:UIControlStateNormal];
        [self.forDisplayButton.titleLabel setFont:font];
        [self.forDisplayButton setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6] forState:UIControlStateNormal];
        
        [self.forDisplayButton setBackgroundImage:[[UIImage imageNamed:@"button_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
        
        [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    }
    
    return self;
}

- (void)initSetting{
    scale = 1.2;
    bgView = [[UIView alloc]initWithFrame:self.bounds];
    bgView.userInteractionEnabled = NO;
    bgView.hidden = YES;
    [self addSubview:bgView];
    
    
    defaultW = bgView.frame.size.width;
    defaultH = bgView.frame.size.height;
    defaultR = bgView.layer.cornerRadius;
    
//    [self addTarget:self action:@selector(startLoading) forControlEvents:UIControlEventTouchUpInside];
    
    _forDisplayButton = [[UIButton alloc]initWithFrame:self.bounds];
    _forDisplayButton.userInteractionEnabled = NO;
    [self addSubview:_forDisplayButton];
}



//-(CGRect)frame{
//    CGRect frame = [super frame];
//    //    CGRectMake((SELF_WIDTH-286)/2+146, SELF_HEIGHT-84, 140, 36)
//    self.forDisplayButton.frame = frame;
//    return frame;
//}

-(void)setContentColor:(UIColor *)contentColor{
    _contentColor = contentColor;
    bgView.backgroundColor = contentColor;
}

-(void)setProgressColor:(UIColor *)progressColor{
    _progressColor = progressColor;
}

- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    [self.forDisplayButton setHighlighted:highlighted];
}

- (void)startLoading{
    
    self.userInteractionEnabled = NO;
    
    bgView.hidden = NO;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fromValue = [NSNumber numberWithFloat:defaultR];
    animation.toValue = [NSNumber numberWithFloat:defaultH*scale*0.5];
    animation.duration = 0.2;
    [bgView.layer setCornerRadius:defaultH*scale*0.5];
    [bgView.layer addAnimation:animation forKey:@"cornerRadius"];
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        bgView.layer.bounds = CGRectMake(0, 0, defaultW*scale, defaultH*scale);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
            bgView.layer.bounds = CGRectMake(0, 0, defaultH*scale, defaultH*scale);
            self.forDisplayButton.transform = CGAffineTransformMakeScale(0, 0);
            self.forDisplayButton.alpha = 0;
        } completion:^(BOOL finished) {
            self.forDisplayButton.hidden = YES;
            
            TJPathView *path = [[TJPathView alloc] initWithFrame:bgView.frame time:_time];
        
            _path = path;
            
            [self addSubview:_path];
            
            [self performSelector:@selector(stopLoading) withObject:nil afterDelay:_time];
        }];
    }];
}

- (void)stopLoading{
    [_path removeFromSuperview];
    
    self.forDisplayButton.hidden = NO;
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:
     UIViewAnimationOptionCurveLinear animations:^{
         self.forDisplayButton.transform = CGAffineTransformMakeScale(1, 1);
         self.forDisplayButton.alpha = 1;
     } completion:^(BOOL finished) {
     }];
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        bgView.layer.bounds = CGRectMake(0, 0, defaultW*scale, defaultH*scale);
    } completion:^(BOOL finished) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
        animation.timingFunction = [CAMediaTimingFunction     functionWithName:kCAMediaTimingFunctionLinear];
        animation.fromValue = [NSNumber numberWithFloat:bgView.layer.cornerRadius];
        animation.toValue = [NSNumber numberWithFloat:defaultR];
        animation.duration = 0.2;
        [bgView.layer setCornerRadius:defaultR];
        [bgView.layer addAnimation:animation forKey:@"cornerRadius"];
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
            bgView.layer.bounds = CGRectMake(0, 0, defaultW, defaultH);
        } completion:^(BOOL finished) {
            bgView.hidden = YES;
            self.userInteractionEnabled = YES;
        }];
    }];
}
@end

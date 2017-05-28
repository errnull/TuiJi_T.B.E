//
//  TJNewStatusAlertView.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/12/3.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJNewStatusAlertView.h"

@interface TJNewStatusAlertView ()
{
    UIView *_currentLastView;
}

@property (weak, nonatomic) IBOutlet UIImageView *icon1;
@property (weak, nonatomic) IBOutlet UILabel *count1;

@property (weak, nonatomic) IBOutlet UIImageView *icon2;
@property (weak, nonatomic) IBOutlet UILabel *count2;

@property (weak, nonatomic) IBOutlet UIImageView *icon3;
@property (weak, nonatomic) IBOutlet UILabel *count3;

@property (weak, nonatomic) IBOutlet UIImageView *icon4;
@property (weak, nonatomic) IBOutlet UILabel *count4;

@end

@implementation TJNewStatusAlertView

+ (instancetype)newStatusAlertView{
    
    TJNewStatusAlertView *newStatusAlertView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TJNewStatusAlertView class]) owner:nil options:nil] lastObject];
    
    newStatusAlertView.layer.cornerRadius = 39*0.5;
    newStatusAlertView.layer.masksToBounds = YES;
    
    newStatusAlertView.size = CGSizeMake(TJWidthDevice, 39);
//    
    return newStatusAlertView;
}

- (void)addTarget:(id)target action:(SEL)action{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:target action:action];
    
    [self addGestureRecognizer:tapGesture];
}

- (void)setDataDic:(NSMutableDictionary *)dataDic{
    
    int i = 0;
    for (NSString *str in dataDic) {
        
        UIImageView *imageView = self.subviews[i];
        imageView.image = [UIImage imageNamed:str];
        imageView.hidden = NO;
        i++;
        UILabel *label = self.subviews[i];
        label.text = [NSString stringWithFormat:@"%@",dataDic[str]];
        label.hidden = NO;
        i++;
        
        _currentLastView = label;
    }
    [self layoutSubviews];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _currentX = _currentLastView.gjcf_right + 8;
}

@end

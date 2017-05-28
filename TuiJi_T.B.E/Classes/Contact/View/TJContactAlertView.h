//
//  TJContactAlertView.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/3.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TJContact;
@class TJContactAlertView;

@protocol TJContactAlertViewDelegate <NSObject>

- (void)contactAlertView:(TJContactAlertView *)contactAlertView talkViewClick:(UIButton *)sender;

- (void)contactAlertView:(TJContactAlertView *)contactAlertView sendViewClick:(UIButton *)sender;
- (void)contactAlertView:(TJContactAlertView *)contactAlertView personalViewClick:(UIButton *)sender;
- (void)contactAlertView:(TJContactAlertView *)contactAlertView videoViewClick:(UIButton *)sender;
- (void)contactAlertView:(TJContactAlertView *)contactAlertView settingViewClick:(UIButton *)sender;
@end

@interface TJContactAlertView : UIView

@property (nonatomic, strong) TJContact *contact;

@property (nonatomic, weak) id<TJContactAlertViewDelegate> delegate;

- (void)alertShow;
- (void)dismissAlert;

+ (instancetype)contactAlertView;
@end

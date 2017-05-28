//
//  TJMyInfoView.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 2016/9/29.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TJMyInfoView;

@protocol TJMyInfoViewDelegate <NSObject>

- (void)myInfoView:(TJMyInfoView *)myInfoView editUserInfoViewClick:(UIButton *)sender;

- (void)myInfoView:(TJMyInfoView *)myInfoView isPublicViewClick:(UIButton *)sender;

- (void)myInfoView:(TJMyInfoView *)myInfoView fansViewClick:(UIButton *)sender;

- (void)myInfoView:(TJMyInfoView *)myInfoView attentionViewClick:(UIButton *)sender;

@end

@interface TJMyInfoView : UIView

@property (nonatomic, weak) id<TJMyInfoViewDelegate> delegate;

@property (nonatomic ,assign) CGFloat myInfoViewRealHeight;

@property (nonatomic ,copy) NSString *tuiwenNumber;
@property (nonatomic ,copy) NSString *fansNumber;
@property (nonatomic ,copy) NSString *attentionNumber;

- (void)showRedPoint;
- (void)hideRedPoint;

@end

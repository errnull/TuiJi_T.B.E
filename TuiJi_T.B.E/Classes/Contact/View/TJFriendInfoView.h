//
//  TJFriendInfoView.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/12/7.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TJUserInfo;
@interface TJFriendInfoView : UIView

@property (nonatomic ,assign) CGFloat myInfoViewRealHeight;

@property (nonatomic ,copy) NSString *tuiwenNumber;
@property (nonatomic ,copy) NSString *fansNumber;
@property (nonatomic ,copy) NSString *attentionNumber;

@property (nonatomic ,strong) TJUserInfo *currentFriendInfo;
- (instancetype)initWithUserInfo:(TJUserInfo *)userInfo;
@end

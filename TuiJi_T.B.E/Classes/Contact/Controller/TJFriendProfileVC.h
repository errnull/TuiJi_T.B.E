//
//  TJFriendProfileVC.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/14.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TJUserInfo;
@interface TJFriendProfileVC : TJBaseAutoThemeVC

@property (nonatomic ,strong) TJUserInfo *currentFriendInfo;

- (instancetype)initWithUserInfo:(TJUserInfo *)userInfo;

@end

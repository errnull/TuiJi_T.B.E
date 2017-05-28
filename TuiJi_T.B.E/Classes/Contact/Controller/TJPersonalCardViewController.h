//
//  TJPersonalCardViewController.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/8/4.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TJNewUserInfoCard;

@interface TJPersonalCardViewController : UIViewController

/**
 *  用户数据模型
 */
@property (nonatomic, strong) TJNewUserInfoCard *userInfo;
@end

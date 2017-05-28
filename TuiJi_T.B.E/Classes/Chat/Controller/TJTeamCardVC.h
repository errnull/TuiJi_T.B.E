//
//  TJTeamCardVC.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/11.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJTeamCardVC : UIViewController

@property (nonatomic, strong) NIMTeam *team;

+ (instancetype)teamCardVC;
@end

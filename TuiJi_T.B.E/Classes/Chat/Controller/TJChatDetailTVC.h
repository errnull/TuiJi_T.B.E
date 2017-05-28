//
//  TJChatDetailTVC.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/6.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TJContact;
@interface TJChatDetailTVC : UITableViewController

+ (instancetype)chatDetailTVC;

@property (nonatomic, strong) TJContact *currentContact;

@end


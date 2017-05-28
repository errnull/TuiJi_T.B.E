//
//  TJMessageCell.h
//  TuiJi_T.B.E
//
//  Created by zhanZhan on 16/7/15.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJMessage.h"

@interface TJMessageCell : UITableViewCell

@property (nonatomic, strong) TJMessage *message;

@property (nonatomic,assign) NSInteger sessionUnreadCount;

@end

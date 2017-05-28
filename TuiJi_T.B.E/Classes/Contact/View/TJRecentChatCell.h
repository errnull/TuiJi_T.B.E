//
//  TJRecentChatCell.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/5.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TJMessage;
@class TJGroupContact;
@class TJContact;
@interface TJRecentChatCell : UITableViewCell

@property (nonatomic, strong) TJMessage *message;
@property (nonatomic, strong) TJGroupContact *groupContact;
@property (nonatomic, strong) TJContact *contact;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

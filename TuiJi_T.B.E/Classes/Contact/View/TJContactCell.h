//
//  TJContactCell.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/7/25.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TJContact;
@class TJGroupContactMenber;
@interface TJContactCell : UITableViewCell

@property (nonatomic, strong) TJContact *contact;

@property (nonatomic, strong) TJGroupContactMenber *member;

@property (nonatomic,assign) NSInteger sessionUnreadCount;
@end

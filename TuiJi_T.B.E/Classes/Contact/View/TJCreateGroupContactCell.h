//
//  TJCreateGroupContactCell.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/7.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TJContact;
@interface TJCreateGroupContactCell : UITableViewCell


@property (nonatomic, strong) TJContact *contact;

+(instancetype)cellWithTableView:(UITableView *)tableView;
@end

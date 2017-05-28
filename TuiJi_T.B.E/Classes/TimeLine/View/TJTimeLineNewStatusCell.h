//
//  TJTimeLineNewStatusCell.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/12/7.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TJTimeLineNewStatus;
@interface TJTimeLineNewStatusCell : UITableViewCell

@property (nonatomic, strong) TJTimeLineNewStatus *timeLineStatus;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

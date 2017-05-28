//
//  TJMyTuiTimeLineViewCell.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 2016/9/30.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TJTimeLine;

@protocol TJMyTuiTimeLineViewCellDelegate <NSObject>

- (void)tableViewCell:(UITableViewCell *)tableViewCell moreViewClick:(UIButton *)sender;

- (void)tableViewCell:(UITableViewCell *)tableViewCell likeViewClick:(UIButton *)sender;

- (void)tableViewCell:(UITableViewCell *)tableViewCell commentClick:(UIButton *)sender;

- (void)tableViewCell:(UITableViewCell *)tableViewCell transmitViewClick:(UIButton *)sender;

- (void)tableViewCell:(UITableViewCell *)tableViewCell translatViewClick:(UIButton *)sender;
@end

@interface TJMyTuiTimeLineViewCell : UITableViewCell

@property (nonatomic, weak) id<TJMyTuiTimeLineViewCellDelegate> myTimeLineViewCellDelegate;

@property (nonatomic, strong) TJTimeLine *myTimeLine;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

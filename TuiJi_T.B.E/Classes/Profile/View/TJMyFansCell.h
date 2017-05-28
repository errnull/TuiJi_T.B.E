//
//  TJMyFansCell.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/12/9.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TJMyFans;
@class TJAttention;
@class TJMyFansCell;
@protocol TJMyFansDelegate <NSObject>

- (void)myFansCell:(TJMyFansCell *)myFansCell didClickAttentionView:(UIButton *)attentionView;

@end

@interface TJMyFansCell : UITableViewCell

@property (nonatomic, strong) TJMyFans *myFans;
@property (nonatomic, strong) TJAttention *myAttention;

@property (nonatomic, weak) id<TJMyFansDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

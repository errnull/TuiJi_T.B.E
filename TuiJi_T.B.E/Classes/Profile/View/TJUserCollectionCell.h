//
//  TJUserCollectionCell.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/22.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TJUserCollectionModel;
@class TJUserCollectionCell;

@protocol TJUserCollectionCellDelegate <NSObject>

- (void)userCollectionCell:(TJUserCollectionCell *)userCollectionCell moreViewClick:(UIButton *)sender;

@end

@interface TJUserCollectionCell : UITableViewCell

@property (nonatomic, weak) id<TJUserCollectionCellDelegate> delegate;
@property (nonatomic, strong) TJUserCollectionModel *userCollectionModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

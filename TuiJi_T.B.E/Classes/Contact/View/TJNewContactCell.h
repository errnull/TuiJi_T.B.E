//
//  TJNewContactCell.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/8/10.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TJNewContactRequest;

@protocol TJNewContactCellDelegate <NSObject>

- (void)tableViewCell:(UITableViewCell *)tableViewCell agreeViewClick:(UIButton *)sender;

@end

@interface TJNewContactCell : UITableViewCell

@property (nonatomic, strong) TJNewContactRequest *addNewContact;

@property (nonatomic ,weak) id<TJNewContactCellDelegate> delegate;

/**
 *  标题专用
 */
@property (nonatomic, weak) UILabel *titleView;

/**
 *  头像
 */
@property (nonatomic, weak) UIImageView *iconView;

/**
 *  昵称
 */
@property (nonatomic, weak) UILabel *nameView;

/**
 *  请求详情
 */
@property (nonatomic, weak) UILabel *detailView;

/**
 *  右边状态按钮
 */
@property (nonatomic, weak) UIButton *rightView;


/**
 *  cell类型
 */
@property (nonatomic ,assign) TJNewFriendCellType cellType;

@end

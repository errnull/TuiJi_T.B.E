//
//  TJTimeLineCell.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/9/10.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TJTimeLine;

@protocol TJTimeLineCellDelegate <NSObject>
/**
 *  头像点击事件
 */
- (void)tableViewCell:(UITableViewCell *)tableViewCell iconViewDidClick:(UIButton *)sender;

/**
 *  更多按钮点击事件
 */
- (void)tableViewCell:(UITableViewCell *)tableViewCell moreViewDidClick:(UIButton *)sender;

/**
 *  喜欢按钮点击事件
 */
- (void)tableViewCell:(UITableViewCell *)tableViewCell likeViewDidClick:(UIButton *)sender;

/**
 *  评论按钮点击事件
 */
- (void)tableViewCell:(UITableViewCell *)tableViewCell commentViewDidClick:(UIButton *)sender;

/**
 *  转发按钮点击事件
 */
- (void)tableViewCell:(UITableViewCell *)tableViewCell transMitViewDidClick:(UIButton *)sender;

/**
 *  翻译按钮点击事件
 */
- (void)tableViewCell:(UITableViewCell *)tableViewCell translatViewDidClick:(UIButton *)sender;

/**
 *  图片加载完毕
 */
- (void)tableViewCell:(UITableViewCell *)tableViewCell webImageDidFinishLoad:(UIImage *)image;

@end

@interface TJTimeLineCell : UITableViewCell

/**
 *  代理
 */
@property (nonatomic, weak) id timeLineCellDelegate;

/**
 *  模型
 */
@property (nonatomic, strong) TJTimeLine *timeLine;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

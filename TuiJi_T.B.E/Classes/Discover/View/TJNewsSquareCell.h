//
//  TJNewsSquareCell.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/2.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TJSquareNews;

@protocol TJSquareNewsCellDelegate <NSObject>
/**
 *  头像点击事件
 */
- (void)tableViewCell:(UITableViewCell *)tableViewCell iconViewDidClick:(UIButton *)sender;

/**
 *  关注点击事件
 */
- (void)tableViewCell:(UITableViewCell *)tableViewCell attentionViewDidClick:(UIButton *)sender;

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

///**
// *  图片加载完毕
// */
//- (void)tableViewCell:(UITableViewCell *)tableViewCell webImageDidFinishLoad:(UIImage *)image;

@end

@interface TJNewsSquareCell : UITableViewCell

/**
 *  代理
 */
@property (nonatomic, weak) id<TJSquareNewsCellDelegate> squareNewsCellDelegate;


@property (nonatomic, strong) TJSquareNews *squareNews;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (weak, nonatomic) IBOutlet UILabel *textView;
@end

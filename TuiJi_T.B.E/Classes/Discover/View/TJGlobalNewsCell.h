//
//  TJGlobalNewsCell.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 2016/10/2.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TJGlobalNews;
@class TJGlobalNewsCell;

@protocol TJGlobalNewsCellDelegate <NSObject>

- (void)globalNewsCell:(TJGlobalNewsCell *)globalNewsCell webImageDidFinishLoad:(UIImage *)image;

@end

@interface TJGlobalNewsCell : UITableViewCell

@property (nonatomic, strong) TJGlobalNews *globalNews;
@property (nonatomic, weak) id<TJGlobalNewsCellDelegate> globalNewCellDelegate;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end

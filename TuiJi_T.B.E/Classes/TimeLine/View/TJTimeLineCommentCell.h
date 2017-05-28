//
//  TJTimeLineCommentCell.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/15.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TJCommentModel;
@class TJSquareCommentModel;
@interface TJTimeLineCommentCell : UITableViewCell

@property (nonatomic, strong) TJCommentModel *commentModel;
@property (nonatomic, strong) TJSquareCommentModel *squareCommentModel;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end

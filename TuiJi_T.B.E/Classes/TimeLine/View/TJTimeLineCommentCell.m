//
//  TJTimeLineCommentCell.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/15.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJTimeLineCommentCell.h"
#import "TJCommentModel.h"
#import "TJCommentUserInfo.h"
#import "TJSquareCommentModel.h"

@interface TJTimeLineCommentCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameView;
@property (weak, nonatomic) IBOutlet UILabel *timeView;
@property (weak, nonatomic) IBOutlet UILabel *commentView;



@end

@implementation TJTimeLineCommentCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseID = @"cell";
    TJTimeLineCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TJTimeLineCommentCell class]) owner:nil options:nil] firstObject];
        
        cell.iconView.layer.cornerRadius = 8;
        cell.iconView.layer.masksToBounds = YES;
    }
    return cell;
}

- (void)setCommentModel:(TJCommentModel *)commentModel{
    _commentModel = commentModel;
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:_commentModel.hostFriendsInfo.headImage]];
    [_nameView setText:_commentModel.hostFriendsInfo.remark];
    [_timeView setText:_commentModel.commTime];

    [_commentView setAttributedText:_commentModel.realComments];
    
}

- (void)setSquareCommentModel:(TJSquareCommentModel *)squareCommentModel{
    _squareCommentModel = squareCommentModel;
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:_squareCommentModel.interlocutorpicture]];
    [_nameView setText:_squareCommentModel.lnterlocutorname];
    [_timeView setText:_squareCommentModel.time];
    
    [_commentView setAttributedText:_squareCommentModel.realComments];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {}

@end

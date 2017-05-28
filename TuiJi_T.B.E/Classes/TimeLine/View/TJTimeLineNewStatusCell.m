//
//  TJTimeLineNewStatusCell.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/12/7.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJTimeLineNewStatusCell.h"
#import "TJTimeLineNewStatus.h"

#import "TJContact.h"

@interface TJTimeLineNewStatusCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *textView;

@property (weak, nonatomic) IBOutlet UILabel *timeView;


@end


@implementation TJTimeLineNewStatusCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {}

- (void)setTimeLineStatus:(TJTimeLineNewStatus *)timeLineStatus{
    _timeLineStatus = timeLineStatus;
    
    TJContact *contact = [TJContact contactWithUserId:_timeLineStatus.uId];
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString: contact.headImage]];
    [_textView setText:_timeLineStatus.message];
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseID = @"cell";
    TJTimeLineNewStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TJTimeLineNewStatusCell class]) owner:nil options:nil] firstObject];
        
        cell.iconView.layer.cornerRadius = 8;
        cell.iconView.layer.masksToBounds = YES;
    }
    return cell;
}
@end

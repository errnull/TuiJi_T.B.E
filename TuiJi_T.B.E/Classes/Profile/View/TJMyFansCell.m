//
//  TJMyFansCell.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/12/9.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJMyFansCell.h"
#import "TJMyFans.h"
#import "TJAttention.h"

@interface TJMyFansCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *nameView;

@property (weak, nonatomic) IBOutlet UIButton *attentionView;

@end

@implementation TJMyFansCell
- (IBAction)attentionViewClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(myFansCell:didClickAttentionView:)]) {
        [self.delegate myFansCell:self didClickAttentionView:sender];
    }
}


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseID = @"cell";
    TJMyFansCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TJMyFansCell class]) owner:nil options:nil] firstObject];
        
        cell.iconView.layer.cornerRadius = 8;
        cell.iconView.layer.masksToBounds = YES;
    }
    return cell;
}

- (void)setMyFans:(TJMyFans *)myFans{
    _myFans = myFans;
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:_myFans.fanspicture]];
    [_nameView setText:_myFans.fanname];
    
    if ([TJAttentionTool isMyAttention:_myFans.fanid]) {
        _attentionView.selected = YES;
    }
}

- (void)setMyAttention:(TJAttention *)myAttention{
    _myAttention = myAttention;
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:_myAttention.attentionpicture]];
    [_nameView setText:_myAttention.attentionname];

    NSString *attentionID = _myAttention.attentionid;
    if (TJStringIsNull(attentionID)) {
        attentionID = _myAttention.attentionname;
    }
    
    if ([TJAttentionTool isMyAttention:attentionID]) {
        _attentionView.selected = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {}

@end

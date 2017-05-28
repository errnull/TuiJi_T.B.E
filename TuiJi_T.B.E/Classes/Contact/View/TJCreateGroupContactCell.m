//
//  TJCreateGroupContactCell.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/7.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJCreateGroupContactCell.h"
#import "TJContact.h"

@interface TJCreateGroupContactCell ()
@property (weak, nonatomic) IBOutlet UIButton *showSelectedView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameView;


@end

@implementation TJCreateGroupContactCell

- (void)setContact:(TJContact *)contact{
    _contact = contact;
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:_contact.headImage]];
    [_nameView setText:_contact.nickname];
    _showSelectedView.selected = _contact.contactSelected;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseID = @"cell";
    TJCreateGroupContactCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TJCreateGroupContactCell class]) owner:nil options:nil] firstObject];
        
        cell.iconView.layer.cornerRadius = 8;
        cell.iconView.layer.masksToBounds = YES;
    }
    return cell;
}

@end

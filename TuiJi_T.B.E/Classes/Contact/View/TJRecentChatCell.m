//
//  TJRecentChatCell.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/5.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJRecentChatCell.h"
#import "TJMessage.h"
#import "TJGroupContact.h"
#import "TJContact.h"

@interface TJRecentChatCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameView;

@end

@implementation TJRecentChatCell

- (void)setMessage:(TJMessage *)message{
    _message = message;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:_message.icon] placeholderImage:[UIImage imageNamed:@"myicon"]];
    [self.nameView setText:_message.name];
}

- (void)setGroupContact:(TJGroupContact *)groupContact{
    _groupContact = groupContact;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:_groupContact.teamHeadIcon] placeholderImage:[UIImage imageNamed:@"myicon_team"]];
    [self.nameView setText:_groupContact.teamName];
}

- (void)setContact:(TJContact *)contact{
    _contact = contact;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:_contact.headImage] placeholderImage:[UIImage imageNamed:@"myicon"]];
    [self.nameView setText:_contact.remark];
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseID = @"cell";
    TJRecentChatCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TJRecentChatCell class]) owner:nil options:nil] firstObject];
        
        cell.iconView.layer.cornerRadius = 8;
        cell.iconView.layer.masksToBounds = YES;
    }
    return cell;
}

@end

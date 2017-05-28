//
//  TJGroupMemberPreCollCell.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/10.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJGroupMemberPreCollCell.h"
#import "TJGroupContactMenber.h"

#import <SDWebImage/UIButton+WebCache.h>

@interface TJGroupMemberPreCollCell ()

@property (weak, nonatomic) IBOutlet UIButton *iconView;

@property (weak, nonatomic) IBOutlet UILabel *nameView;

@end

@implementation TJGroupMemberPreCollCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _iconView.layer.cornerRadius = 8;
    _iconView.layer.masksToBounds = YES;
}


- (void)setGroupContactMenber:(TJGroupContactMenber *)groupContactMenber{
    _groupContactMenber = groupContactMenber;
    
    if ([_groupContactMenber.nickname isEqualToString:TJSpecialMark]) {
        //末尾两个按钮
        [_iconView setImage:[UIImage imageNamed:_groupContactMenber.headImage] forState:UIControlStateNormal];
        [_iconView setImage:[UIImage imageNamed:[_groupContactMenber.headImage stringByAppendingString:@"_h"]] forState:UIControlStateHighlighted];
        
        [_nameView setText:@""];
    }else{
        //用户
        [_iconView sd_setImageWithURL:[NSURL URLWithString:_groupContactMenber.headImage] forState:UIControlStateNormal];
        [_nameView setText:_groupContactMenber.nickname];
        
    }
    
}

@end

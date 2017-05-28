//
//  TJTransmitToContactCell.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/17.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJTransmitToContactCell.h"

#import "TJContact.h"

@interface TJTransmitToContactCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *nameView;

@end

@implementation TJTransmitToContactCell

- (void)setRecentContact:(TJContact *)recentContact{
    _recentContact = recentContact;
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:_recentContact.headImage]];
    [_nameView setText:_recentContact.remark];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end

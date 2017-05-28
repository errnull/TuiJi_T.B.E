//
//  TJDropDownMenuCell.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 2016/9/28.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJDropDownMenuCell.h"
#import "TJDropDownCellModel.h"

@interface TJDropDownMenuCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *textView;

@end

@implementation TJDropDownMenuCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseID = @"cell";
    TJDropDownMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJDropDownMenuCell" owner:nil options:nil] firstObject];
        
        cell.backgroundColor = TJColorClear;
    }
    return cell;
}

- (void)setDropDownModel:(TJDropDownCellModel *)dropDownModel{
    _dropDownModel = dropDownModel;
    
    _iconView.image = [UIImage imageNamed:_dropDownModel.icon];
    _textView.text = _dropDownModel.text;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

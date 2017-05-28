//
//  TJUserCollectionCell.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/22.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJUserCollectionCell.h"
#import "TJUserCollectionModel.h"

#import "BLImageSize.h"

@interface TJUserCollectionCell ()
@property (weak, nonatomic) IBOutlet UILabel *textView;

@property (weak, nonatomic) IBOutlet UIImageView *pictureView;

- (IBAction)moreViewClick:(UIButton *)sender;

@end

@implementation TJUserCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {}

- (void)setUserCollectionModel:(TJUserCollectionModel *)userCollectionModel{
    _userCollectionModel = userCollectionModel;
    
    [_textView setText:_userCollectionModel.tContent];
    
    [_pictureView sd_setImageWithURL:[NSURL URLWithString:_userCollectionModel.imgsUrl]];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseID = @"cell";
    TJUserCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TJUserCollectionCell class]) owner:nil options:nil] firstObject];
        
    }
    return cell;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (_userCollectionModel) {
        CGSize strSize = [_userCollectionModel.tContent sizeWithFont:TJFontWithSize(14) maxSize:CGSizeMake(TJWidthDevice - 55, MAXFLOAT)];
        
        //不超出两行的高度
        _textView.height = (strSize.height > 39) ? 39 : strSize.height;
        
        _pictureView.gjcf_top = _textView.gjcf_bottom + 4;
        
        if (!TJStringIsNull(_userCollectionModel.imgsUrl)) {
            _pictureView.height = TJWidthDevice - 6;
        }else{
            _pictureView.height = 0.1;
        }
    }
}

- (IBAction)moreViewClick:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(userCollectionCell:moreViewClick:)]) {
        [_delegate userCollectionCell:self moreViewClick:sender];
    }
}
@end

//
//  TJMyTuiTimeLineViewCell.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 2016/9/30.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJMyTuiTimeLineViewCell.h"
#import "TJTimeLine.h"
#import "TJUserInfo.h"

#import "BLImageSize.h"

@interface TJMyTuiTimeLineViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *textView;
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (weak, nonatomic) IBOutlet UILabel *praiseView;
@property (weak, nonatomic) IBOutlet UILabel *commentCountView;
@property (weak, nonatomic) IBOutlet UIButton *likeView;
@property (weak, nonatomic) IBOutlet UILabel *locationView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIImageView *location_icon;

- (IBAction)moreViewClick:(UIButton *)sender;
- (IBAction)likeViewClick:(UIButton *)sender;
- (IBAction)commentClick:(UIButton *)sender;
- (IBAction)transmitViewClick:(UIButton *)sender;
- (IBAction)translatViewClick:(UIButton *)sender;

@end


@implementation TJMyTuiTimeLineViewCell

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat strWidth = TJWidthDevice - 113;
    
    CGSize strSize = [_myTimeLine.tContent sizeWithFont:TJFontWithSize(13) maxSize:CGSizeMake(strWidth, MAXFLOAT)];
    
    //不超出两行的高度
    strSize.height = (strSize.height > 36) ? 36 : strSize.height;
    
    _textView.height = strSize.height;
    
    if (_myTimeLine.imgsUrl.count) {
        
        NSString *pictureURLStr = [_myTimeLine.imgsUrl firstObject];
        
        CGSize pictureSize = [BLImageSize downloadImageSizeWithURL:pictureURLStr];
        
        if (pictureSize.width > 0) {
            _pictureView.height = (TJWidthDevice - 67) * (pictureSize.height / pictureSize.width);
        }else{
            _pictureView.height = (TJWidthDevice - 67);
        }
    }
    
    
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseID = @"cell";
    TJMyTuiTimeLineViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJMyTuiTimeLineViewCell" owner:nil options:nil] firstObject];
    }
    cell.iconView.layer.cornerRadius = 8;
    cell.iconView.layer.masksToBounds = YES;
    cell.lineView.hidden = YES;
    
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {}

- (void)setMyTimeLine:(TJTimeLine *)myTimeLine{
    _myTimeLine = myTimeLine;
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:_myTimeLine.headImage] placeholderImage:[UIImage imageNamed:@"myicon"]];
    
    CGFloat strWidth = TJWidthDevice - 113;
    CGSize strSize = [_myTimeLine.tContent sizeWithFont:TJFontWithSize(13) maxSize:CGSizeMake(strWidth, MAXFLOAT)];
    _textView.size = strSize;
    _textView.text = _myTimeLine.tContent;
    
    if (_myTimeLine.imgsUrl.count) {
        [_pictureView sd_setImageWithURL:[NSURL URLWithString:[_myTimeLine.imgsUrl firstObject]]];
    }else{
        _lineView.hidden = NO;
    }
    
    
    _praiseView.text = [_myTimeLine.praiseNum stringByAppendingString:@" 次赞"];
    _commentCountView.text = [[@"所有 " stringByAppendingString:_myTimeLine.commentNum] stringByAppendingString:@" 次评论"];
//    _locationView.text = _myTimeLine
    
    self.likeView.selected = [_myTimeLine.isMyPraise integerValue];
    
    
    
    if (!TJStringIsNull(_myTimeLine.tAddress)) {
        _locationView.text = _myTimeLine.tAddress;
        _location_icon.hidden = NO;
    }
    
}
- (IBAction)moreViewClick:(UIButton *)sender {
    if ([self.myTimeLineViewCellDelegate respondsToSelector:@selector(tableViewCell:moreViewClick:)]) {
        [self.myTimeLineViewCellDelegate tableViewCell:self moreViewClick:sender];
    }
}
- (IBAction)likeViewClick:(UIButton *)sender {
    if ([self.myTimeLineViewCellDelegate respondsToSelector:@selector(tableViewCell:likeViewClick:)]) {
        [self.myTimeLineViewCellDelegate tableViewCell:self likeViewClick:sender];
    }
    
    
    
}

- (IBAction)commentClick:(UIButton *)sender {
    if ([self.myTimeLineViewCellDelegate respondsToSelector:@selector(tableViewCell:commentClick:)]) {
        [self.myTimeLineViewCellDelegate tableViewCell:self commentClick:sender];
    }
}

- (IBAction)transmitViewClick:(UIButton *)sender {
    if ([self.myTimeLineViewCellDelegate respondsToSelector:@selector(tableViewCell:transmitViewClick:)]) {
        [self.myTimeLineViewCellDelegate tableViewCell:self transmitViewClick:sender];
    }
}

- (IBAction)translatViewClick:(UIButton *)sender {
    if ([self.myTimeLineViewCellDelegate respondsToSelector:@selector(tableViewCell:translatViewClick:)]) {
        [self.myTimeLineViewCellDelegate tableViewCell:self translatViewClick:sender];
    }
}
@end

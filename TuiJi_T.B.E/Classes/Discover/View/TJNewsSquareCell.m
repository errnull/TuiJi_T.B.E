//
//  TJNewsSquareCell.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/2.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJNewsSquareCell.h"
#import "TJSquareNews.h"

#import "BLImageSize.h"

@interface TJNewsSquareCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nickView;
@property (weak, nonatomic) IBOutlet UILabel *timeView;
@property (weak, nonatomic) IBOutlet UIButton *attentionView;
@property (weak, nonatomic) IBOutlet UIButton *moreView;
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;

@property (weak, nonatomic) IBOutlet UIButton *transmitView;
@property (weak, nonatomic) IBOutlet UILabel *praiseView;
@property (weak, nonatomic) IBOutlet UILabel *commentCountView;
@property (weak, nonatomic) IBOutlet UIButton *likeView;
@property (weak, nonatomic) IBOutlet UIButton *commentView;

@property (weak, nonatomic) IBOutlet UILabel *locationView;
@property (weak, nonatomic) IBOutlet UIImageView *location_icon;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation TJNewsSquareCell

- (void)setSquareNews:(TJSquareNews *)squareNews{
    _squareNews = squareNews;
    
    if (!TJStringIsNull(_squareNews.coordinate)) {
        _locationView.text = _squareNews.coordinate;
        _location_icon.hidden = NO;
    }
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:_squareNews.userIcon]];
    [_nickView setText:_squareNews.username];
    [_timeView setText:_squareNews.time];
    [_pictureView sd_setImageWithURL:[NSURL URLWithString:_squareNews.imageUrl]];
    
    _iconView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconViewClick)];
    [_iconView addGestureRecognizer:tapGesture];
    
    if (TJStringIsNull(_squareNews.content)) {
        self.lineView.hidden = YES;
    }
    
    [_textView setText:_squareNews.content];
    [_praiseView setText:[_squareNews.praisenumber stringByAppendingString:@" 次赞"]];
    [_commentCountView setText:[[@"所有 " stringByAppendingString:@"20"] stringByAppendingString:@" 次评论"]];
    
    NSString *userId = _squareNews.userid;
    if (TJStringIsNull(userId)) {
        userId = _squareNews.username;
    }
    
    if ([TJAttentionTool isMyAttention:userId]) {
        _attentionView.selected = YES;
    }
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    _pictureView.gjcf_top = _iconView.gjcf_bottom + 14;
    
    if (!TJStringIsNull(_squareNews.imageUrl)) {
        CGSize pictureSize = [BLImageSize downloadImageSizeWithURL:_squareNews.imageUrl];
        if (pictureSize.width > 0) {
            _pictureView.width = TJWidthDevice;
            _pictureView.height = TJWidthDevice * (pictureSize.height / pictureSize.width);
        }else{
            _pictureView.height = TJWidthDevice;
        }
    }
    
    _textView.gjcf_top = _pictureView.gjcf_bottom + 4;
    
    CGSize strSize = [_squareNews.content sizeWithFont:TJFontWithSize(13) maxSize:CGSizeMake(TJWidthDevice-62, MAXFLOAT)];
    //不超出两行的高度
    _textView.height = (strSize.height > 36) ? 36 : strSize.height;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {}


+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseID = @"cell";
    TJNewsSquareCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TJNewsSquareCell class]) owner:nil options:nil] firstObject];
    }
    
    cell.iconView.layer.cornerRadius = 8;
    cell.iconView.layer.masksToBounds = YES;
    
    return cell;
}

//iconViewClick
- (void)iconViewClick
{
    if ([self.squareNewsCellDelegate respondsToSelector:@selector(tableViewCell:iconViewDidClick:)]) {
        [self.squareNewsCellDelegate tableViewCell:self iconViewDidClick:nil];
    }
}

- (IBAction)attentionViewClick:(UIButton *)sender {
    if ([self.squareNewsCellDelegate respondsToSelector:@selector(tableViewCell:translatViewDidClick:)]) {
        [self.squareNewsCellDelegate tableViewCell:self attentionViewDidClick:sender];
    }
}

- (IBAction)moreViewClick:(UIButton *)sender {
    if ([self.squareNewsCellDelegate respondsToSelector:@selector(tableViewCell:moreViewDidClick:)]) {
        [self.squareNewsCellDelegate tableViewCell:self moreViewDidClick:sender];
    }
}

- (IBAction)likeViewClick:(UIButton *)sender {
    if ([self.squareNewsCellDelegate respondsToSelector:@selector(tableViewCell:likeViewDidClick:)]) {
        [self.squareNewsCellDelegate tableViewCell:self likeViewDidClick:sender];
    }
}

- (IBAction)commentViewClick:(UIButton *)sender {
    if ([self.squareNewsCellDelegate respondsToSelector:@selector(tableViewCell:commentViewDidClick:)]) {
        [self.squareNewsCellDelegate tableViewCell:self commentViewDidClick:sender];
    }
}

- (IBAction)transmitViewClick:(UIButton *)sender {
    if ([self.squareNewsCellDelegate respondsToSelector:@selector(tableViewCell:transMitViewDidClick:)]) {
        [self.squareNewsCellDelegate tableViewCell:self transMitViewDidClick:sender];
    }
}

- (IBAction)translatViewClick:(UIButton *)sender {
    if ([self.squareNewsCellDelegate respondsToSelector:@selector(tableViewCell:translatViewDidClick:)]) {
        [self.squareNewsCellDelegate tableViewCell:self translatViewDidClick:sender];
    }
}

@end

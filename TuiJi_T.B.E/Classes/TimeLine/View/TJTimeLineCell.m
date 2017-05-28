//
//  TJTimeLineCell.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/9/10.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJTimeLineCell.h"

#import "TJRegionView.h"
#import "TJTimeLine.h"

#import "TJContact.h"

#import "BLImageSize.h"

#import "ZXVideo.h"
#import "ZXVideoPlayerController.h"

@interface TJTimeLineCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nickView;
@property (weak, nonatomic) IBOutlet UILabel *timeView;
@property (weak, nonatomic) IBOutlet UILabel *textView;
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (weak, nonatomic) IBOutlet UILabel *praiseView;
@property (weak, nonatomic) IBOutlet UILabel *commentCountView;
@property (weak, nonatomic) IBOutlet UIButton *likeView;
@property (weak, nonatomic) IBOutlet UILabel *locationView;
@property (weak, nonatomic) IBOutlet UIImageView *location_icon;
@property (weak, nonatomic) IBOutlet UIImageView *videoTypeView;
@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet UIImageView *transmitIconView;
@property (weak, nonatomic) IBOutlet UILabel *transmitNameView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *transmitIconViewH;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic, strong) ZXVideo *video;

@property (nonatomic, strong) ZXVideoPlayerController *videoController;


- (IBAction)moreViewClick:(UIButton *)sender;
- (IBAction)translatViewClick:(UIButton *)sender;
- (IBAction)likeViewClick:(UIButton *)sender;
- (IBAction)commentViewClick:(UIButton *)sender;
- (IBAction)transmitViewClick:(UIButton *)sender;


@end

@implementation TJTimeLineCell
CGRect _frame;

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize strSize = [_timeLine.tContent sizeWithFont:TJFontWithSize(13) maxSize:CGSizeMake(TJWidthDevice-62, MAXFLOAT)];
    
    //不超出两行的高度
    _textView.height = (strSize.height > 36) ? 36 : strSize.height;
    
    if (_timeLine.imgsUrl.count) {
        CGSize pictureSize = [BLImageSize downloadImageSizeWithURL:[_timeLine.imgsUrl firstObject]];
        if (pictureSize.width > 0) {
            _pictureView.height = TJWidthDevice * (pictureSize.height / pictureSize.width);
        }else{
            _pictureView.height = TJWidthDevice;
        }
        
    }else{
        _lineView.hidden = NO;
    }
    
    _pictureView.gjcf_top = _textView.gjcf_bottom + 4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseID = @"cell";
    TJTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJTimeLineCell" owner:nil options:nil] firstObject];
    }
    cell.iconView.layer.cornerRadius = 8;
    cell.iconView.layer.masksToBounds = YES;
    cell.lineView.hidden = YES;
    
    return cell;
}

- (void)setTimeLine:(TJTimeLine *)timeLine{
    _timeLine = timeLine;

    [_iconView sd_setImageWithURL:[NSURL URLWithString:_timeLine.headImage]];
    
    _iconView.userInteractionEnabled = YES;

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconViewClick)];
    [_iconView addGestureRecognizer:tapGesture];
    
    _nickView.text = _timeLine.nickname;
    _timeView.text = _timeLine.tTime;
    
    
    TJTimeLine *currentTimeLine = _timeLine;
    if (_timeLine.transmitTimeLine) {
        currentTimeLine = _timeLine.transmitTimeLine;
        [_transmitIconView sd_setImageWithURL:[NSURL URLWithString:_timeLine.headImage]];
        [_transmitNameView setText:_timeLine.nickname];
        
        _transmitIconViewH.constant = 28;
    }
    
    _textView.text = currentTimeLine.tContent;
    
    if (!TJStringIsNull(currentTimeLine.tAddress)) {
        _locationView.text = currentTimeLine.tAddress;
        _location_icon.hidden = NO;
    }
    
    if ([timeLine.tType isEqualToString:@"4"]) {
        self.videoTypeView.hidden = NO;
        self.videoView.hidden = NO;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(beginPlayVideo)];
        [self.videoView addGestureRecognizer:tapGesture];

        ZXVideo *video = [[ZXVideo alloc] init];
        video.playUrl = currentTimeLine.mulmediaUrl;
        
        _video = video;

        
    }
    
    if (currentTimeLine.imgsUrl.count) {
        
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        
        NSURL *imageURL = [NSURL URLWithString:[currentTimeLine.imgsUrl firstObject]];
        
        BOOL needLoadImageInternet = ![manager diskImageExistsForURL:imageURL];
        if (needLoadImageInternet) {
            _pictureView.alpha = 0;
        }
        [_pictureView sd_setImageWithURL:[NSURL URLWithString:[currentTimeLine.imgsUrl firstObject]]
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                   
                                   if (needLoadImageInternet) {
                                       [UIView animateWithDuration:1 animations:^{
                                           _pictureView.alpha = 1;
                                       }];
                                   }
                                   
                                   if ([self.timeLineCellDelegate respondsToSelector:@selector(tableViewCell:webImageDidFinishLoad:)]) {
                                       [self.timeLineCellDelegate tableViewCell:self webImageDidFinishLoad:image];
                                   }
                               }];
    }
    _praiseView.text = [_timeLine.praiseNum stringByAppendingString:@" 次赞"];
    _commentCountView.text = [[@"所有 " stringByAppendingString:_timeLine.commentNum] stringByAppendingString:@" 次评论"];
    
    self.likeView.selected = [_timeLine.isMyPraise integerValue];
}

- (void)beginPlayVideo
{
    if (!self.videoController) {
        self.videoController = [[ZXVideoPlayerController alloc] initWithFrame:CGRectMake(0, 0, self.videoView.width, self.videoView.height)];
        
        __weak typeof(self) weakSelf = self;
        self.videoController.videoPlayerGoBackBlock = ^{
            __strong typeof(self) strongSelf = weakSelf;
            
            strongSelf.videoController = nil;
        };
    
        [self.videoController showInView:self.videoView];
    }
    [self.videoController removeController];
    self.videoController.video = self.video;
}


- (void)iconViewClick
{
    if ([self.timeLineCellDelegate respondsToSelector:@selector(tableViewCell:iconViewDidClick:)]) {
        [self.timeLineCellDelegate tableViewCell:self iconViewDidClick:nil];
    }
}



- (IBAction)translatViewClick:(UIButton *)sender {
    if ([self.timeLineCellDelegate respondsToSelector:@selector(tableViewCell:translatViewDidClick:)]) {
        [self.timeLineCellDelegate tableViewCell:self translatViewDidClick:sender];
    }
}

- (IBAction)likeViewClick:(UIButton *)sender {
    if ([self.timeLineCellDelegate respondsToSelector:@selector(tableViewCell:likeViewDidClick:)]) {
        [self.timeLineCellDelegate tableViewCell:self likeViewDidClick:sender];
    }
}

- (IBAction)commentViewClick:(UIButton *)sender {
    if ([self.timeLineCellDelegate respondsToSelector:@selector(tableViewCell:commentViewDidClick:)]) {
        [self.timeLineCellDelegate tableViewCell:self commentViewDidClick:sender];
    }
}

- (IBAction)transmitViewClick:(UIButton *)sender {
    if ([self.timeLineCellDelegate respondsToSelector:@selector(tableViewCell:transMitViewDidClick:)]) {
        [self.timeLineCellDelegate tableViewCell:self transMitViewDidClick:sender];
    }
}



- (IBAction)moreViewClick:(UIButton *)sender {
    if ([self.timeLineCellDelegate respondsToSelector:@selector(tableViewCell:moreViewDidClick:)]) {
        [self.timeLineCellDelegate tableViewCell:self moreViewDidClick:sender];
    }
}


@end

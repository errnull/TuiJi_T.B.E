//
//  TJGlobalNewsCell.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 2016/10/2.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJGlobalNewsCell.h"

#import "TJGlobalNews.h"

#import "BLImageSize.h"

@interface TJGlobalNewsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *textView;
@property (weak, nonatomic) IBOutlet UILabel *fromView;
@property (weak, nonatomic) IBOutlet UIButton *moreView;

- (IBAction)moreViewClick:(id)sender;

@end

@implementation TJGlobalNewsCell

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (_globalNews.titlePicture) {
        CGSize pictureSize = [BLImageSize downloadImageSizeWithURL:_globalNews.titlePicture];
        if (pictureSize.width > 0) {
            _pictureView.height = (TJWidthDevice - 17) * (pictureSize.height / pictureSize.width);
        }else{
            _pictureView.height = (TJWidthDevice - 17);
        }
        
    }
    CGSize strSize = [_globalNews.contentCatch sizeWithFont:TJFontWithSize(14) maxSize:CGSizeMake(TJWidthDevice-39, MAXFLOAT)];
    
    //不超出两行的高度
    _textView.height = (strSize.height > 39) ? 39 : strSize.height;
    
    _pictureView.gjcf_top = _moreView.gjcf_bottom + 12;
    _textView.gjcf_top = _titleView.gjcf_bottom + 8;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseID = @"cell";
    TJGlobalNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJGlobalNewsCell" owner:nil options:nil] firstObject];
        
        cell.backgroundColor = TJColorGrayBg;
    }
    return cell;
}

- (void)setGlobalNews:(TJGlobalNews *)globalNews{
    _globalNews = globalNews;
    
    _pictureView.alpha = 0;
    
    [_pictureView sd_setImageWithURL:[NSURL URLWithString:_globalNews.titlePicture]
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                               
                               [UIView animateWithDuration:1 animations:^{
                                   _pictureView.alpha = 1;
                               }];
                               
                               if ([self.globalNewCellDelegate respondsToSelector:@selector(globalNewsCell:webImageDidFinishLoad:)]) {
                                   [self.globalNewCellDelegate globalNewsCell:self webImageDidFinishLoad:image];
                               }
                               
    }];
    [_titleView setText:_globalNews.title];
    [_textView setText:_globalNews.contentCatch];
    [_fromView setText:globalNews.fromMediaCHI];

    
}


- (IBAction)moreViewClick:(id)sender {
    
    NSLog(@"");
    
}
@end

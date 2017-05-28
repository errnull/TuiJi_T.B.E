//
//  GJGCChatFriendContentTypeLocationCell.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/24.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "GJGCChatFriendContentTypeLocationCell.h"
#import "TJLocationMessageObject.h"

@interface GJGCChatFriendContentTypeLocationCell()

@property (nonatomic, weak) UIImageView *showImageView;
@property (nonatomic, weak) UIImageView *locationIconView;
@property (nonatomic, weak) UILabel *locationView;

@end

@implementation GJGCChatFriendContentTypeLocationCell

#pragma mark - 初始化

{
    TJLocationMessageObject *_locationMessageObject;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.bgshadowView.backgroundColor = TJColorClear;
        
        self.contentImageView = [[UIImageView alloc]init];
        self.contentImageView.image = GJCFImageStrecth(nil, 2, 2);
        self.contentImageView.gjcf_size = (CGSize){160,160};
        self.contentImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnContentImageView)];
        tapR.numberOfTapsRequired = 1;
        [self.bgshadowView addGestureRecognizer:tapR];
        [self.bgshadowView addSubview:self.contentImageView];
        
        self.blankImageView = [[UIImageView alloc]initWithImage:nil];
        [self.contentImageView addSubview:self.blankImageView];
        self.blankImageView.gjcf_centerX = self.contentImageView.gjcf_width/2;
        self.blankImageView.gjcf_centerY = self.contentImageView.gjcf_height/2;
        
        self.progressView = [[GJCUProgressView alloc]init];
        self.progressView.frame = self.contentImageView.bounds;
        self.progressView.hidden = YES;
        [self.contentImageView addSubview:self.progressView];
        
        UIImageView *showImageView = [TJUICreator createImageViewWithName:@"showLocation" size:CGSizeMake(231, 143)];
        _showImageView = showImageView;
        [TJAutoLayoutor layView:_showImageView atTheTopMiddleOfTheView:self.bgshadowView offset:CGSizeMake(0, 8)];
     
        UIImageView *locationIconView = [TJUICreator createImageViewWithName:@"timeLine_location_finish" size:CGSizeMake(11, 19)];
        _locationIconView = locationIconView;
        [self.bgshadowView addSubview:_locationIconView];
        [TJAutoLayoutor layView:_locationIconView belowTheView:_showImageView span:CGSizeMake(-16, 16) alignmentType:AlignmentLeft];
        
        UILabel *locationView = [TJUICreator createLabelWithSize:CGSizeMake(180, 20)
                                                            text:@""
                                                           color:TJColorBlackFont
                                                            font:TJFontWithSize(16)];
        _locationView = locationView;
        [self.bgshadowView addSubview:_locationView];
        [TJAutoLayoutor layView:_locationView toTheRightOfTheView:_locationIconView span:CGSizeMake(10, 0)];
        
    }
    return self;
}

#pragma mark - 点击图片

- (void)tapOnContentImageView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(transmitCellDidTap:location:)]) {
        [self.delegate transmitCellDidTap:self location:_locationMessageObject];
    }
}

- (void)resetState
{
    
}

- (void)resetStateWithPrepareSize:(CGSize)pSize
{
    self.contentImageView.gjcf_size = pSize;
    self.contentImageView.image = GJCFImageStrecth([UIImage imageNamed:@"IM聊天页-占位图-BG.png"], 2, 2);
    [self resetMaxBlankImageViewSize];
    self.blankImageView.gjcf_centerX = self.contentImageView.gjcf_width/2;
    self.blankImageView.gjcf_centerY = self.contentImageView.gjcf_height/2;
    self.progressView.frame = self.contentImageView.bounds;
    self.blankImageView.hidden = NO;
    self.progressView.progress = 0.f;
    self.progressView.hidden = YES;
}

- (void)resetMaxBlankImageViewSize
{
    CGFloat blankToBord = 8.f;
    
    CGFloat minSide = MIN(self.contentImageView.gjcf_width, self.contentImageView.gjcf_height);
    
    CGFloat blankWidth = minSide - 2*blankToBord;
    
    self.blankImageView.gjcf_size = CGSizeMake(blankWidth, blankWidth);
}

- (void)removePrepareState
{
    self.blankImageView.hidden = YES;
    self.progressView.hidden = YES;
}

#pragma mark - 设置内容
- (void)setContentModel:(GJGCChatContentBaseModel *)contentModel
{
    if (!contentModel) {
        return;
    }
    [super setContentModel:contentModel];
    
    GJGCChatFriendContentModel *chatContentModel = (GJGCChatFriendContentModel *)contentModel;
    TJLocationMessageObject *locationMessageObject = (TJLocationMessageObject *)chatContentModel.transmitExtensionObject;
    
    _locationMessageObject = locationMessageObject;

    [_locationView setText:_locationMessageObject.title];
//        
        self.contentSize = CGSizeMake(247, 195);
//
        self.bgshadowView.backgroundColor = TJColorWhiteBg;
//        
        //    /* 重设气泡 */
        self.bgshadowView.gjcf_height = self.contentSize.height;
        self.bgshadowView.gjcf_width = self.contentSize.width;
    
    [self adjustContent];
}

- (void)setDownloadProgress:(CGFloat)downloadProgress
{
    if (_downloadProgress == downloadProgress) {
        return;
    }
    self.progressView.hidden = NO;
    _downloadProgress = downloadProgress;
    self.progressView.progress = downloadProgress;
}

/**
 *  重新设置imgUrl
 *
 *
 */
- (void)reCutImageUrl
{
}

#pragma mark - 长按事件

- (void)goToShowLongPressMenu:(UILongPressGestureRecognizer *)sender
{
    [super goToShowLongPressMenu:sender];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        //
        [self becomeFirstResponder];
        UIMenuController *popMenu = [UIMenuController sharedMenuController];
        UIMenuItem *item1 = [[UIMenuItem alloc] initWithTitle:@"保存到手机" action:@selector(saveImage:)];
        UIMenuItem *item2 = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteMessage:)];
        NSArray *menuItems = @[item1,item2];
        [popMenu setMenuItems:menuItems];
        [popMenu setArrowDirection:UIMenuControllerArrowDown];
        
        [popMenu setTargetRect:self.bgshadowView.frame inView:self];
        [popMenu setMenuVisible:YES animated:YES];
        
    }
    
}

- (void)faildState
{
    CGSize thumbNoScaleSize;
    if (self.imgUrl) {
        
        CGSize imageSize = CGSizeMake(80, 140);
        thumbNoScaleSize = [GJGCImageResizeHelper getCutImageSize:imageSize maxSize:CGSizeMake(160, 160)];
        
    }else{
        
        thumbNoScaleSize = (CGSize){160,160};
    }
    
    self.contentImageView.gjcf_size = thumbNoScaleSize;
    self.contentImageView.image = GJCFImageStrecth([UIImage imageNamed:@"IM聊天页-占位图-BG.png"], 2, 2);
    self.blankImageView.gjcf_centerX = self.contentImageView.gjcf_width/2;
    self.blankImageView.gjcf_centerY = self.contentImageView.gjcf_height/2;
    self.blankImageView.hidden = NO;
    self.progressView.progress = 0.f;
    self.progressView.hidden = YES;
}

- (void)successDownloadWithImageData:(NSData *)imageData
{
    if (imageData) {
        [self  removePrepareState];
        self.contentImageView.image = [UIImage imageWithData:imageData];
    }
}

/**
 *  保存图片
 *
 *  @param sender
 */
- (void)saveImage:(UIMenuItem *)sender
{
    [TJDataCenter saveImage:self.contentImageView.image Success:^{} failure:^(NSError *error) {}];
}


- (BOOL)canBecomeFirstResponder
{
    return YES;
}


- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(saveImage:) || action == @selector(deleteMessage:) || action == @selector(reSendMessage)) {
        return YES;
    }
    return NO; //隐藏系统默认的菜单项
}



@end

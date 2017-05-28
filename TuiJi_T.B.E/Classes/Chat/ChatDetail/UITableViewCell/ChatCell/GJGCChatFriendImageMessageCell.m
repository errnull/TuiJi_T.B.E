//
//  GJGCChatFriendImageMessageCell.m
//  ZYChat
//
//  Created by ZYVincent on 14-11-5.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJGCChatFriendImageMessageCell.h"

@interface GJGCChatFriendImageMessageCell ()

@end

@implementation GJGCChatFriendImageMessageCell


#pragma mark - 初始化
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
            
    }
    return self;
}

#pragma mark - 点击图片

- (void)tapOnContentImageView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageMessageCellDidTap:)]) {
        [self.delegate imageMessageCellDidTap:self];
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
    self.isFromSelf = chatContentModel.isFromSelf;
    
//    EMImageMessageBody *imageMessageBody = (EMImageMessageBody *)chatContentModel.message.body;
    
//    [self resetStateWithPrepareSize:imageMessageBody.thumbnailSize];
    
//    if (chatContentModel.isFromSelf || imageMessageBody.thumbnailDownloadStatus == EMDownloadStatusSuccessed) {
    
        self.contentSize = CGSizeMake(228, chatContentModel.originImageHeight * (228.0 / chatContentModel.originImageWidth));
        self.contentImageView.gjcf_size = self.contentSize;
    if (![chatContentModel.thumbImageCachePath containsString:@"Application"]) {
        chatContentModel.thumbImageCachePath = [[GJCFCachePathManager shareManager]mainImageCacheFilePath:chatContentModel.thumbImageCachePath];
    }
    
        self.contentImageView.image = GJCFQuickImageByFilePath(chatContentModel.thumbImageCachePath);
    
//    }
    
//    /* 重设气泡 */
    self.bgshadowView.gjcf_height = self.contentImageView.gjcf_height + 10;
    self.bgshadowView.gjcf_width = self.contentImageView.gjcf_width + 10;
    
//    self.bgshadowView.backgroundColor = TJColorWithRandomAlpha(0.6);
    
    [self adjustContent];
    
//    self.contentImageView.gjcf_top = 6.f;
    if (self.isFromSelf) {
        
        self.contentImageView.gjcf_left = -14.f;
        
    }else{
        
        self.contentImageView.gjcf_left = 24.f;
    }
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
//    CGSize imgRealSize = [self.imgUrl gjim_getimageUrlSize];
//    CGFloat smallWidth = 160;
//    CGFloat smallHeight = imgRealSize.height * 160 / imgRealSize.width;
//    if (isnan(smallHeight)) {
//        smallHeight = 0;
//    }
//    self.imgUrl = [self.imgUrl gjim_restructImageUrlWithSize:CGSizeMake(160, smallHeight)];
//    if (imgRealSize.height > imgRealSize.width) {
//        smallHeight = 160;
//        smallWidth = imgRealSize.width * 160 / imgRealSize.height;
//        self.imgUrl = [self.imgUrl gjim_restructImageUrlWithSize:CGSizeMake(smallWidth, smallHeight)];
//    }
    
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
 *  @param sender <#sender description#>
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

//
//  GJGCChatFriendContentTypeTransmitCell.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/19.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "GJGCChatFriendContentTypeTransmitCell.h"
#import "TJTransmitTimeLineObject.h"


@interface GJGCChatFriendContentTypeTransmitCell ()

@property (nonatomic, weak) UIImageView *transmitIconView;
@property (nonatomic, weak) UILabel *transmitNameView;

@property (nonatomic, weak) UILabel *transmitContextView;

@property (nonatomic, weak) UIView *bottomLine;

@end

@implementation GJGCChatFriendContentTypeTransmitCell
#pragma mark - 初始化

{
    TJTransmitTimeLineObject *_transmitTimeLineObject;
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
        
        UIImageView *transmitIconView = [TJUICreator createImageViewWithSize:CGSizeMake(30, 30)];
        _transmitIconView = transmitIconView;
        [TJAutoLayoutor layView:_transmitIconView atTheLeftTopOfTheView:self.bgshadowView offset:CGSizeMake(14, 10)];
        
        UILabel *transmitNameView = [TJUICreator createLabelWithSize:CGSizeMake(120, 20)
                                                                text:@""
                                                               color:TJColorBlackFont
                                                                font:TJFontWithSize(13)];
        transmitNameView.backgroundColor = TJColorClear;
        _transmitNameView = transmitNameView;
        [self.bgshadowView addSubview:_transmitNameView];
        [TJAutoLayoutor layView:_transmitNameView toTheRightOfTheView:_transmitIconView span:TJSizeWithWidth(12)];
        
        UILabel *transmitContextView = [TJUICreator createLabelWithSize:CGSizeMake(185, 33)
                                                                   text:@""
                                                                  color:TJColorBlackFont
                                                                   font:TJFontWithSize(11)];
        transmitContextView.hidden = YES;
        transmitContextView.numberOfLines = 2;
        transmitContextView.backgroundColor = TJColorClear;
        _transmitContextView = transmitContextView;
        [self.bgshadowView addSubview:_transmitContextView];
        
        //下划线
        UIView *bottomLine = [TJUICreator createLineWithSize:CGSizeMake(TJWidthDevice, 0.5) bgColor:TJColorLine];
        bottomLine.hidden = YES;
        _bottomLine = bottomLine;
        [self.bgshadowView addSubview:_bottomLine];
    }
    return self;
}

#pragma mark - 点击图片

- (void)tapOnContentImageView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(transmitCellDidTap:tramsmit:)]) {
        [self.delegate transmitCellDidTap:self tramsmit:_transmitTimeLineObject];
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
    TJTransmitTimeLineObject *transmitTimeLineObject = (TJTransmitTimeLineObject *)chatContentModel.transmitExtensionObject;

    _transmitTimeLineObject = transmitTimeLineObject;
    [_transmitIconView sd_setImageWithURL:[NSURL URLWithString:_transmitTimeLineObject.headImage]];
    [_transmitNameView setText:_transmitTimeLineObject.nickname];
    
    if (TJStringIsNull(_transmitTimeLineObject.imgUrl)) {
        
        self.contentSize = TJAutoSizeMake(203, 0.1);
        self.contentImageView.gjcf_size = TJAutoSizeMake(203, 82);
        
        self.bgshadowView.backgroundColor = TJColorWhiteBg;
        
        //    /* 重设气泡 */
        self.bgshadowView.gjcf_height = self.contentSize.height;
        self.bgshadowView.gjcf_width = self.contentSize.width;
        
        [_transmitContextView setText:_transmitTimeLineObject.context];
        
        [TJAutoLayoutor layView:_transmitContextView atTheBottomMiddleOfTheView:self.bgshadowView offset:TJSizeWithHeight(10)];
        [TJAutoLayoutor layView:_bottomLine aboveTheView:_transmitContextView span:TJSizeWithHeight(14)];
        
        _transmitContextView.hidden = NO;
        _bottomLine.hidden = NO;
    }else{
        
        self.contentSize = TJAutoSizeMake(203, 261);
        self.contentImageView.gjcf_size = TJAutoSizeMake(203, 203);
        
        [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:_transmitTimeLineObject.imgUrl]];
        
        self.bgshadowView.backgroundColor = TJColorWhiteBg;
        
        //    /* 重设气泡 */
        self.bgshadowView.gjcf_height = self.contentSize.height;
        self.bgshadowView.gjcf_width = self.contentSize.width;
        
        //照片位置
        //        self.contentImageView.gjcf_left = self.bgshadowView.gjcf_left;
        self.contentImageView.gjcf_bottom = self.bgshadowView.gjcf_bottom;
//        self.contentImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        
        
        
    }
    
    
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

//
//  TJPersonalInfoView.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/8/3.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJPersonalInfoView.h"
#import "TJUserInfo.h"

#import "HMScannerController.h"

@interface TJPersonalInfoView ()

/**
 *  头像
 */
@property (nonatomic, weak) UIImageView *iconView;

/**
 *  昵称
 */
@property (nonatomic, weak) UILabel *nickNameView;

/**
 *  二维码
 */
@property (nonatomic, weak) UIImageView *QRCodeView;


@end

@implementation TJPersonalInfoView

#pragma mark - system method

/**
 *  init
 */
- (instancetype)initWithSize:(CGSize)size{
    if (self = [super initWithFrame:TJRectFromSize(size)]) {
        //创建所有子控件
        [self setUpAllSubViews];
        //自动布局
        [self layoutAllSubViews];
        self.backgroundColor = TJColorWhiteBg;
    }
    return self;
}

#pragma mark - private method
/**
 *  创建所有子控件
 */
- (void)setUpAllSubViews
{
    //头像
    UIImageView *iconView = [TJUICreator createImageViewWithName:@"myicon"
                                                            size:TJAutoSizeMake(84, 84)
                                                          radius:10];
    NSString *urlStr = TJUserInfoCurrent.uPicture;
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    [iconView sd_setImageWithURL:url
                placeholderImage:[UIImage imageNamed:@"myicon"]];
    _iconView = iconView;
    [self addSubview:_iconView];
    
    //昵称
    UILabel *nickNameView = [TJUICreator createLabelWithSize:TJAutoSizeMake(100, 35)
                                                        text:TJUserInfoCurrent.uNickname
                                                       color:TJColorBlackFont
                                                        font:TJFontWithSize(18)];
    _nickNameView = nickNameView;
    [self addSubview:_nickNameView];
    
    //二维码
    UIImageView *QRCodeView = [TJUICreator createImageViewWithName:@"myicon"
                                                              size:TJAutoSizeMake(248, 248)
                                                            radius:10];
    _QRCodeView = QRCodeView;
    [self addSubview:_QRCodeView];
    
    NSString* strUrl = TJUserInfoCurrent.uPicture;
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSString* key = [manager cacheKeyForURL:[NSURL URLWithString:strUrl]];
    SDImageCache* cache = [SDImageCache sharedImageCache];
    //此方法会先从memory中取。
    UIImage *image = [cache imageFromDiskCacheForKey:key];
    
    [HMScannerController cardImageWithCardName:[@"tuiji:" stringByAppendingString:TJUserInfoCurrent.uUsername]
                                        avatar:image
                                         scale:0.2
                                    completion:^(UIImage *image) {
                                    
                                        [QRCodeView setImage:image];
                                        
                                    }];
}

/**
 *  自动布局
 */
- (void)layoutAllSubViews
{
    [TJAutoLayoutor layView:_iconView atTheLeftTopOfTheView:self offset:TJAutoSizeMake(37, 31)];
    [TJAutoLayoutor layView:_nickNameView toTheRightOfTheView:_iconView span:TJSizeWithWidth(35)];
    [TJAutoLayoutor layView:_QRCodeView atTheBottomMiddleOfTheView:self offset:TJSizeWithHeight(36)];
}
@end

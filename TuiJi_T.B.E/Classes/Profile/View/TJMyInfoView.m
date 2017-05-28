//
//  TJMyInfoView.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 2016/9/29.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJMyInfoView.h"
#import "TJRegionView.h"
#import "TJKeyValueTextLabel.h"

#import "TJUserInfo.h"

@interface TJMyInfoView ()

/**
 *  头像
 */
@property (nonatomic, weak) UIImageView *iconView;

/**
 *  昵称
 */
@property (nonatomic, weak) UILabel *nickNameView;

/**
 *  性别
 */
@property (nonatomic, weak) UIImageView *sexView;

/**
 *  地区
 */
@property (nonatomic, weak) TJRegionView *regionView;

/**
 *  推己号
 */
@property (nonatomic, weak) TJKeyValueTextLabel *tuijiView;

/**
 *  个性签名
 */
@property (nonatomic, weak) UILabel *signatureView;

/**
 *  编辑个人资料
 */
@property (nonatomic, weak) UIButton *editUserInfoView;

/**
 *  是否成为公众人物
 */
@property (nonatomic, weak) UIButton *isPublicView;

/**
 *  公众推文数
 */
@property (nonatomic, weak) UILabel *publicTuiwenView;

/**
 *  个人推文数
 */
@property (nonatomic, weak) UILabel *privateTuiwenView;

/**
 *  关注数
 */
@property (nonatomic, weak) UILabel *attentionView;

/**
 *  关注者
 */
@property (nonatomic, weak) UILabel *fansView;

/**
 *  小红点
 */
@property (nonatomic, weak) UIView *redPointView;
@end

@implementation TJMyInfoView

- (CGFloat)myInfoViewRealHeight{
    if ([TJUserInfoCurrent.uPublic isEqualToString:@"0"]) {
        _myInfoViewRealHeight = self.editUserInfoView.tjPoint.y + self.editUserInfoView.tjSize.height + 14 + 39;
    }else{
        _myInfoViewRealHeight = self.fansView.tjPoint.y + self.fansView.tjSize.height + 14 + 39;
    }
    
    return _myInfoViewRealHeight;
}

#pragma mark - system method
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setUpAllSubViews];
        
        [self layoutAllSubViews];
        
        self.height = self.myInfoViewRealHeight;
    }
    return self;
}

- (void)setTuiwenNumber:(NSString *)tuiwenNumber{
    _tuiwenNumber = tuiwenNumber;
    
    TJKeyValueTextLabel *publicTuiwenView = [TJUICreator createKeyValueTextLabelWithSize:TJAutoSizeMake(70, 20)
                                                                                 textKey:@"推文   "
                                                                               textValue:_tuiwenNumber
                                                                                keyColor:TJColorGrayFontLight
                                                                              valueColor:TJColorBlackFont
                                                                                 keyFont:TJFontWithSize(13)
                                                                               valueFont:TJFontWithSize(14)];
    _publicTuiwenView.attributedText = publicTuiwenView.attributedText;
    _privateTuiwenView.attributedText = publicTuiwenView.attributedText;
    
}

- (void)setFansNumber:(NSString *)fansNumber{
    _fansNumber = fansNumber;
    
    TJKeyValueTextLabel *fansView = [TJUICreator createKeyValueTextLabelWithSize:TJAutoSizeMake(100, 20)
                                                                         textKey:@"关注者   "
                                                                       textValue:_fansNumber
                                                                        keyColor:TJColorGrayFontLight
                                                                      valueColor:TJColorBlackFont
                                                                         keyFont:TJFontWithSize(13)
                                                                       valueFont:TJFontWithSize(14)];
    _fansView.attributedText = fansView.attributedText;
    [_fansView sizeToFit];
    _redPointView.gjcf_left = _fansView.gjcf_right + 2;
    _redPointView.gjcf_top = _fansView.gjcf_top;
}

- (void)setAttentionNumber:(NSString *)attentionNumber{
    _attentionNumber = attentionNumber;
    
    TJKeyValueTextLabel *attentionView = [TJUICreator createKeyValueTextLabelWithSize:TJAutoSizeMake(70, 20)
                                                                              textKey:@"关注   "
                                                                            textValue:_attentionNumber
                                                                             keyColor:TJColorGrayFontLight
                                                                           valueColor:TJColorBlackFont
                                                                              keyFont:TJFontWithSize(13)
                                                                            valueFont:TJFontWithSize(14)];
    _attentionView.attributedText = attentionView.attributedText;
}

#pragma mark - private method
/**
 *  set up all sub views
 */
- (void)setUpAllSubViews
{
    //头像
    UIImageView *iconView = [TJUICreator createImageViewWithSize:TJAutoSizeMake(65, 65)];
    [iconView sd_setImageWithURL:[NSURL URLWithString:TJUserInfoCurrent.uPicture] placeholderImage:[UIImage imageNamed:@"myicon"]];
    
    _iconView = iconView;
    [self addSubview:_iconView];
    
    //昵称
    NSString *uNickname = TJStringIsNull(TJUserInfoCurrent.uNickname) ? @"   " : TJUserInfoCurrent.uNickname;
    UILabel *nickNameView = [TJUICreator createLabelWithSize:TJAutoSizeMake(200, 22)
                                                        text:uNickname
                                                       color:TJColorBlackFont
                                                        font:TJFontWithSize(15)];
    [nickNameView sizeToFit];
    
    _nickNameView = nickNameView;
    [self addSubview:_nickNameView];
    
    //性别
    UIImageView *sexView = [TJUICreator createImageViewWithName:@"man_h" size:TJAutoSizeMake(9, 12)];
    if (TJUserInfoCurrent.uSex == NIMUserGenderFemale) {
        [sexView setImage:[UIImage imageNamed:@"woman_h"]];
    }
    _sexView = sexView;
    [self addSubview:_sexView];
    
    //地区
    TJRegionView *regionView = [TJUICreator createRegionViewWithRegionStr:TJUserInfoCurrent.uCountry
                                                                     font:TJFontWithSize(10)];
    _regionView = regionView;
    [self addSubview:_regionView];
    
    //推己号
    TJKeyValueTextLabel *tuijiView = [TJUICreator createKeyValueTextLabelWithSize:TJAutoSizeMake(226, 20)
                                                                          textKey:@"推己号: "
                                                                        textValue:TJUserInfoCurrent.uUsername
                                                                         keyColor:TJColorGrayFontLight
                                                                       valueColor:TJColorBlackFont
                                                                          keyFont:TJFontWithSize(13)
                                                                        valueFont:TJFontWithSize(14)];
    _tuijiView = tuijiView;
    [self addSubview:_tuijiView];
    
    //个性签名
    NSString *uSignature = TJStringIsNull(TJUserInfoCurrent.uSignature) ? @"   " : TJUserInfoCurrent.uSignature;
    UILabel *signatureView = [TJUICreator createLabelWithSize:TJAutoSizeMake(243, 30)
                                                         text:uSignature
                                                        color:TJColorGrayFontDark
                                                         font:TJFontWithSize(10)];
    [signatureView sizeToFit];
    _signatureView = signatureView;
    [self addSubview:_signatureView];
    
    //编辑个人资料
    UIButton *editUserInfoView = [TJUICreator createButtonWithSize:TJAutoSizeMake(214, 27)
                                                       NormalImage:@"profile_editUserInfo"
                                                  highlightedImage:@"profile_editUserInfo_h"
                                                            target:self
                                                            action:@selector(editUserInfoViewClick:)];
    _editUserInfoView = editUserInfoView;
    [self addSubview:_editUserInfoView];
    
    //是否成为公众人物
    UIButton *isPublicView = [TJUICreator createButtonWithSize:TJAutoSizeMake(29, 28)
                                                   NormalImage:@"profile_isPublic"
                                              highlightedImage:@"profile_isPublic_h"
                                                        target:self
                                                        action:@selector(isPublicViewClick:)];
    _isPublicView = isPublicView;
    [self addSubview:_isPublicView];
    

    //公众推文数
    TJKeyValueTextLabel *publicTuiwenView = [TJUICreator createKeyValueTextLabelWithSize:TJAutoSizeMake(70, 20)
                                                                                 textKey:@"推文   "
                                                                               textValue:@"0"
                                                                                keyColor:TJColorGrayFontLight
                                                                              valueColor:TJColorBlackFont
                                                                                 keyFont:TJFontWithSize(13)
                                                                               valueFont:TJFontWithSize(14)];
    publicTuiwenView.hidden = ![TJUserInfoCurrent.uPublic intValue];
    _publicTuiwenView = publicTuiwenView;
    [self addSubview:_publicTuiwenView];
    
    //个人推文数
    UILabel *privateTuiwenView = [TJUICreator createKeyValueTextLabelWithSize:TJAutoSizeMake(70, 20)
                                                                      textKey:@"推文   "
                                                                    textValue:@"0"
                                                                     keyColor:TJColorGrayFontLight
                                                                   valueColor:TJColorBlackFont
                                                                      keyFont:TJFontWithSize(13)
                                                                    valueFont:TJFontWithSize(14)];
    privateTuiwenView.hidden = [TJUserInfoCurrent.uPublic intValue];
    _privateTuiwenView = privateTuiwenView;
    [self addSubview:_privateTuiwenView];
    
    //关注数
    TJKeyValueTextLabel *attentionView = [TJUICreator createKeyValueTextLabelWithSize:TJAutoSizeMake(70, 20)
                                                                              textKey:@"关注   "
                                                                            textValue:@"0"
                                                                             keyColor:TJColorGrayFontLight
                                                                           valueColor:TJColorBlackFont
                                                                              keyFont:TJFontWithSize(13)
                                                                            valueFont:TJFontWithSize(14)];
    attentionView.hidden = ![TJUserInfoCurrent.uPublic intValue];
    attentionView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *attentionGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(attentionViewClick:)];
    [attentionView addGestureRecognizer:attentionGestureRecognizer];
    
    _attentionView = attentionView;
    [self addSubview:_attentionView];
    
    //关注者
    TJKeyValueTextLabel *fansView = [TJUICreator createKeyValueTextLabelWithSize:TJAutoSizeMake(90, 20)
                                                                         textKey:@"关注者   "
                                                                       textValue:@"0"
                                                                        keyColor:TJColorGrayFontLight
                                                                      valueColor:TJColorBlackFont
                                                                         keyFont:TJFontWithSize(13)
                                                                       valueFont:TJFontWithSize(14)];
    fansView.hidden = ![TJUserInfoCurrent.uPublic intValue];
    fansView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fansViewClick:)];
    [fansView addGestureRecognizer:gestureRecognizer];
    
    _fansView = fansView;
    [self addSubview:_fansView];
    
    //小红点
    UIView *redPointView = [TJUICreator createViewWithSize:CGSizeMake(6, 6)
                                                   bgColor:TJColorRedPoint
                                                    radius:3];
    redPointView.hidden = YES;
    _redPointView = redPointView;
    [self addSubview:_redPointView];
}

- (void)attentionViewClick:(TJKeyValueTextLabel *)sender
{
    if ([self.delegate respondsToSelector:@selector(myInfoView:attentionViewClick:)]) {
        [self.delegate myInfoView:self attentionViewClick:nil];
    }
}

- (void)fansViewClick:(TJKeyValueTextLabel *)sender
{
    if ([self.delegate respondsToSelector:@selector(myInfoView:fansViewClick:)]) {
        [self.delegate myInfoView:self fansViewClick:nil];
    }
}

/**
 *  layout All subViews
 */
- (void)layoutAllSubViews
{
    [TJAutoLayoutor layView:_iconView atTheLeftTopOfTheView:self offset:TJAutoSizeMake(14, 14)];
    [TJAutoLayoutor layView:_nickNameView toTheRightOfTheView:_iconView span:TJSizeWithWidth(14) alignmentType:AlignmentTop];
    [TJAutoLayoutor layView:_sexView toTheRightOfTheView:_nickNameView span:TJAutoSizeMake(10, -1)];
    [TJAutoLayoutor layView:_regionView toTheRightOfTheView:_sexView span:TJSizeWithWidth(14)];
    [TJAutoLayoutor layView:_tuijiView belowTheView:_nickNameView span:TJSizeWithHeight(4) alignmentType:AlignmentLeft];
    [TJAutoLayoutor layView:_signatureView belowTheView:_tuijiView span:TJSizeWithHeight(4) alignmentType:AlignmentLeft];
    [TJAutoLayoutor layView:_editUserInfoView belowTheView:_signatureView span:TJAutoSizeMake(-5, 6) alignmentType:AlignmentLeft];
    [TJAutoLayoutor layView:_isPublicView toTheRightOfTheView:_editUserInfoView span:TJSizeWithWidth(3)];
    [TJAutoLayoutor layView:_attentionView belowTheView:_editUserInfoView span:TJAutoSizeMake(-6, 6)];
    [TJAutoLayoutor layView:_publicTuiwenView toTheLeftOfTheView:_attentionView span:TJSizeWithWidth(29)];
    [TJAutoLayoutor layView:_privateTuiwenView toTheLeftOfTheView:_editUserInfoView span:TJSizeWithWidth(14)];
    [TJAutoLayoutor layView:_fansView toTheRightOfTheView:_attentionView span:TJSizeWithWidth(28)];
}


- (void)editUserInfoViewClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(myInfoView:editUserInfoViewClick:)]) {
        [self.delegate myInfoView:self editUserInfoViewClick:sender];
    }
}

- (void)isPublicViewClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(myInfoView:isPublicViewClick:)]) {
        [self.delegate myInfoView:self isPublicViewClick:sender];
    }
}

- (void)showRedPoint{
    _redPointView.hidden = NO;
}
- (void)hideRedPoint{
    _redPointView.hidden = YES;
}
@end

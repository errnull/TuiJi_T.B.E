//
//  TJFriendInfoView.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/12/7.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJFriendInfoView.h"
#import "TJRegionView.h"
#import "TJKeyValueTextLabel.h"

#import "TJAttention.h"
#import "TJUserInfo.h"

@interface TJFriendInfoView ()

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

@end

@implementation TJFriendInfoView

- (CGFloat)myInfoViewRealHeight{
    if ([_currentFriendInfo.uPublic isEqualToString:@"0"]) {
        _myInfoViewRealHeight = self.editUserInfoView.tjPoint.y + self.editUserInfoView.tjSize.height + 14 + 39;
    }else{
        _myInfoViewRealHeight = self.fansView.tjPoint.y + self.fansView.tjSize.height + 14 + 39;
    }
    
    return _myInfoViewRealHeight;
}

#pragma mark - system method
- (instancetype)initWithUserInfo:(TJUserInfo *)userInfo{
    if (self = [super initWithFrame:CGRectMake(0, 0, TJWidthDevice, 1)]) {
        
        _currentFriendInfo = userInfo;
        
        [self setUpAllSubViews];
        
        [self layoutAllSubViews];
        
        self.height = self.myInfoViewRealHeight;
    }
    return self;
}

- (void)setTuiwenNumber:(NSString *)tuiwenNumber{
    _tuiwenNumber = tuiwenNumber;
    
    TJKeyValueTextLabel *publicTuiwenView = [TJUICreator createKeyValueTextLabelWithSize:TJAutoSizeMake(60, 20)
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
    
    TJKeyValueTextLabel *fansView = [TJUICreator createKeyValueTextLabelWithSize:TJAutoSizeMake(90, 20)
                                                                         textKey:@"关注者   "
                                                                       textValue:_fansNumber
                                                                        keyColor:TJColorGrayFontLight
                                                                      valueColor:TJColorBlackFont
                                                                         keyFont:TJFontWithSize(13)
                                                                       valueFont:TJFontWithSize(14)];
    _fansView.attributedText = fansView.attributedText;
}

- (void)setAttentionNumber:(NSString *)attentionNumber{
    _attentionNumber = attentionNumber;
    
    TJKeyValueTextLabel *attentionView = [TJUICreator createKeyValueTextLabelWithSize:TJAutoSizeMake(60, 20)
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
    [iconView sd_setImageWithURL:[NSURL URLWithString:_currentFriendInfo.uPicture] placeholderImage:[UIImage imageNamed:@"myicon"]];
    
    _iconView = iconView;
    [self addSubview:_iconView];
    
    //昵称
    NSString *uNickname = TJStringIsNull(_currentFriendInfo.uNickname) ? @"   " : _currentFriendInfo.uNickname;
    UILabel *nickNameView = [TJUICreator createLabelWithSize:TJAutoSizeMake(200, 22)
                                                        text:uNickname
                                                       color:TJColorBlackFont
                                                        font:TJFontWithSize(15)];
    [nickNameView sizeToFit];
    
    _nickNameView = nickNameView;
    [self addSubview:_nickNameView];
    
    //性别
    UIImageView *sexView = [TJUICreator createImageViewWithName:@"man_h" size:TJAutoSizeMake(9, 12)];
    if (_currentFriendInfo.uSex == NIMUserGenderFemale) {
        [sexView setImage:[UIImage imageNamed:@"woman_h"]];
    }
    _sexView = sexView;
    [self addSubview:_sexView];
    
    //地区
    TJRegionView *regionView = [TJUICreator createRegionViewWithRegionStr:_currentFriendInfo.uCountry
                                                                     font:TJFontWithSize(10)];
    _regionView = regionView;
    [self addSubview:_regionView];
    
    //推己号
    TJKeyValueTextLabel *tuijiView = [TJUICreator createKeyValueTextLabelWithSize:TJAutoSizeMake(226, 20)
                                                                          textKey:@"推己号: "
                                                                        textValue:_currentFriendInfo.uUsername
                                                                         keyColor:TJColorGrayFontLight
                                                                       valueColor:TJColorBlackFont
                                                                          keyFont:TJFontWithSize(13)
                                                                        valueFont:TJFontWithSize(14)];
    _tuijiView = tuijiView;
    [self addSubview:_tuijiView];
    
    if (![_currentFriendInfo.userId isConnectWithMe]) {
        _tuijiView.hidden = YES;
    }
    
    //个性签名
    NSString *uSignature = TJStringIsNull(_currentFriendInfo.uSignature) ? @"   " : _currentFriendInfo.uSignature;
    UILabel *signatureView = [TJUICreator createLabelWithSize:TJAutoSizeMake(243, 30)
                                                         text:uSignature
                                                        color:TJColorGrayFontDark
                                                         font:TJFontWithSize(10)];
    [signatureView sizeToFit];
    _signatureView = signatureView;
    [self addSubview:_signatureView];
    
    //编辑个人资料
    
    BOOL isMyAttention = [TJAttentionTool isMyAttention:_currentFriendInfo.userId];
    NSString *editUserImageName = @"profile_willAttention";
    NSString *isPublicImageName = @"profile_willAttention_add";
    if (isMyAttention) {
        editUserImageName = @"profile_didAttention";
        isPublicImageName = @"profile_didAttention_add";
    }
    UIButton *editUserInfoView = [TJUICreator createButtonWithSize:TJAutoSizeMake(214, 27)
                                                       NormalImage:editUserImageName
                                                  highlightedImage:[editUserImageName stringByAppendingString:@"_h"]
                                                            target:self
                                                            action:@selector(editUserInfoViewClick:)];
    _editUserInfoView = editUserInfoView;
    [self addSubview:_editUserInfoView];
    
    //是否成为公众人物
    UIButton *isPublicView = [TJUICreator createButtonWithSize:TJAutoSizeMake(29, 28)
                                                   NormalImage:isPublicImageName
                                              highlightedImage:[isPublicImageName stringByAppendingString:@"_h"]
                                                        target:self
                                                        action:@selector(isPublicViewClick:)];
    _isPublicView = isPublicView;
    [self addSubview:_isPublicView];
    
    
    if ([_currentFriendInfo.uPublic isEqualToString:@"0"]) {
        
        _editUserInfoView.hidden = YES;
        _isPublicView.hidden = YES;
        
    }
    
    //公众推文数
    TJKeyValueTextLabel *publicTuiwenView = [TJUICreator createKeyValueTextLabelWithSize:TJAutoSizeMake(60, 20)
                                                                                 textKey:@"推文   "
                                                                               textValue:@"0"
                                                                                keyColor:TJColorGrayFontLight
                                                                              valueColor:TJColorBlackFont
                                                                                 keyFont:TJFontWithSize(13)
                                                                               valueFont:TJFontWithSize(14)];
    publicTuiwenView.hidden = ![_currentFriendInfo.uPublic intValue];
    _publicTuiwenView = publicTuiwenView;
    [self addSubview:_publicTuiwenView];
    
    //个人推文数
    UILabel *privateTuiwenView = [TJUICreator createKeyValueTextLabelWithSize:TJAutoSizeMake(60, 20)
                                                                      textKey:@"推文   "
                                                                    textValue:@"0"
                                                                     keyColor:TJColorGrayFontLight
                                                                   valueColor:TJColorBlackFont
                                                                      keyFont:TJFontWithSize(13)
                                                                    valueFont:TJFontWithSize(14)];
    privateTuiwenView.hidden = [_currentFriendInfo.uPublic intValue];
    _privateTuiwenView = privateTuiwenView;
    [self addSubview:_privateTuiwenView];
    
    //关注数
    TJKeyValueTextLabel *attentionView = [TJUICreator createKeyValueTextLabelWithSize:TJAutoSizeMake(60, 20)
                                                                              textKey:@"关注   "
                                                                            textValue:@"0"
                                                                             keyColor:TJColorGrayFontLight
                                                                           valueColor:TJColorBlackFont
                                                                              keyFont:TJFontWithSize(13)
                                                                            valueFont:TJFontWithSize(14)];
    attentionView.hidden = ![_currentFriendInfo.uPublic intValue];
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
    fansView.hidden = ![_currentFriendInfo.uPublic intValue];
    _fansView = fansView;
    [self addSubview:_fansView];
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
    BOOL isMyAttention = [TJAttentionTool isMyAttention:_currentFriendInfo.userId];
    if (isMyAttention) {
        //取消关注
        [TJAttentionTool unPayAttntionToSB:_currentFriendInfo.userId
                                     where:0
                                   Success:^{
                                       
                                       //如果取消关注成功 手动删除
                                       [TJDataCenter deleteAObjectWithClassName:NSStringFromClass([TJAttention class]) conditions:[NSString stringWithFormat:@"attentionid = '%@'",_currentFriendInfo.userId]];
                                       
                                       //更换背景图片
                                       [_editUserInfoView setImage:[UIImage imageNamed:@"profile_willAttention"] forState:UIControlStateNormal];
                                       [_editUserInfoView setImage:[UIImage imageNamed:@"profile_willAttention_h"] forState:UIControlStateHighlighted];
                                       
                                       [_isPublicView setImage:[UIImage imageNamed:@"profile_willAttention_add"] forState:UIControlStateNormal];
                                       [_isPublicView setImage:[UIImage imageNamed:@"profile_willAttention_add_h"] forState:UIControlStateHighlighted];
                                       
                                   } failure:^(NSError *error) {
                                       [TJRemindTool showError:@"操作失败."];
                                   }];
    }else{
        //设置关注
        [TJAttentionTool payAttntionToSB:_currentFriendInfo.userId
                                   where:0
                                 Success:^{
                                     //如果关注成功 手动插入数据库
                                     TJAttention *currentAttention = [[TJAttention alloc] init];
                                     currentAttention.attentionid = _currentFriendInfo.userId;
                                     currentAttention.userid = TJUserInfoCurrent.userId;
                                     currentAttention.attentionname = _currentFriendInfo.uNickname;
                                     currentAttention.attentionpicture = _currentFriendInfo.uPicture;
                                    
                                     [TJDataCenter addSingleObject:currentAttention];
                                     
                                     //更换背景图片
                                     [_editUserInfoView setImage:[UIImage imageNamed:@"profile_didAttention"] forState:UIControlStateNormal];
                                     [_editUserInfoView setImage:[UIImage imageNamed:@"profile_didAttention_h"] forState:UIControlStateHighlighted];
                                     
                                     [_isPublicView setImage:[UIImage imageNamed:@"profile_didAttention_add"] forState:UIControlStateNormal];
                                     [_isPublicView setImage:[UIImage imageNamed:@"profile_didAttention_add_h"] forState:UIControlStateHighlighted];
                                 } failure:^(NSError *error) {
                                     [TJRemindTool showError:@"关注失败."];
                                 }];
        
        
        
    }
}

- (void)isPublicViewClick:(UIButton *)sender
{

}


@end

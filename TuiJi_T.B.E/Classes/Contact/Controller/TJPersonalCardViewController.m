//
//  TJPersonalCardViewController.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/8/4.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJPersonalCardViewController.h"
#import "TJNewUserInfoCard.h"

#import "TJSendAddFriendRequestVC.h"

#import "TJKeyValueTextLabel.h"
#import "TJRegionView.h"


@interface TJPersonalCardViewController ()

/**
 *  头像
 */
@property (nonatomic, weak) UIImageView *iconView;

/**
 *  昵称
 */
@property (nonatomic, weak) UILabel *nickNameView;

/**
 *  tuij号
 */
@property (nonatomic, weak) TJKeyValueTextLabel *tuijiView;

/**
 *  地区
 */
@property (nonatomic, weak) TJRegionView *regionView;

///**
// *  国旗
// */
//@property (nonatomic, weak) UIImageView *flagView;

/**
 *  个性签名
 */
@property (nonatomic, weak) UILabel *signatureView;

/**
 *  加好友按钮
 */
@property (nonatomic, weak) UIButton *addFriendView;

/**
 *  灰色背景
 */
@property (nonatomic, weak) UIView *bgView;

@end

@implementation TJPersonalCardViewController

#pragma mark - system method

/**
 *  懒加载
 */
- (TJNewUserInfoCard *)userInfo{
    if (!_userInfo) {
        _userInfo = [[TJNewUserInfoCard alloc] init];
    }
    return _userInfo;
}

/**
 *  init set up subViews
 */
- (instancetype)init
{
    if (self = [super init]) {
        self.view.backgroundColor = TJColorGrayBg;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //创建所有子控件
    [self setUpAllSubViews];
    // Layout all sub views
    [self layoutAllSubViews];
    
}

#pragma mark - private method
/**
 *  set up all sub views
 */
- (void)setUpAllSubViews
{
    //头像
    UIImageView *iconView = [TJUICreator createImageViewWithName:@"myicon"
                                                            size:TJAutoSizeMake(67, 67)
                                                          radius:7];
    [iconView sd_setImageWithURL:[NSURL URLWithString:_userInfo.picture] placeholderImage:[UIImage imageNamed:@"myicon"]];
    _iconView = iconView;
    [self.view addSubview:_iconView];

    //昵称
    UILabel *nickNameView = [TJUICreator createLabelWithSize:CGSizeMake(253, 20)
                                                        text:self.userInfo.nickName
                                                       color:TJColorBlackFont
                                                        font:TJFontWithSize(18)];
    _nickNameView = nickNameView;
    [self.view addSubview:_nickNameView];

    //tuij号
    TJKeyValueTextLabel *tuijiView = [TJUICreator createKeyValueTextLabelWithSize:CGSizeMake(235, 20)
                                                                          textKey:@"推己号: "
                                                                        textValue:self.userInfo.username
                                                                         keyColor:TJColorGrayFontLight
                                                                       valueColor:TJColorBlackFont
                                                                          keyFont:TJFontWithSize(13)
                                                                        valueFont:TJFontWithSize(14)];
    _tuijiView = tuijiView;
    [self.view addSubview:_tuijiView];

    TJRegionView *regionView = [TJUICreator createRegionViewWithRegionStr:[self.userInfo.country isEqualToString:@"null"] ? nil : self.userInfo.country
                                                                     font:TJFontWithSize(12)];
    _regionView = regionView;
    [self.view addSubview:_regionView];

    //个性签名
    UILabel *signatureView = [TJUICreator createLabelWithSize:TJAutoSizeMake(328, 40)
                                                         text:self.userInfo.signature                                                        color:TJColorBlackFont
                                                         font:TJFontWithSize(14)];
    _signatureView = signatureView;
    [self.view addSubview:_signatureView];

    //加好友按钮
    UIButton *addFriendView = [TJUICreator createButtonWithSize:TJAutoSizeMake(340, 50)
                                                    NormalImage:@"user_addFriend"
                                                  selectedImage:@"user_addFriend_h"
                                                         target:self
                                                         action:@selector(addFriendBtnClick:)];
    _addFriendView = addFriendView;
    [self.view addSubview:_addFriendView];
    
    //灰色背景
    UIView *bgView = [TJUICreator createViewWithSize:TJAutoSizeMake(375, 213)
                                             bgColor:TJColorWhiteBg
                                              radius:0];
    _bgView = bgView;
    [self.view addSubview:_bgView];
}

/**
 *  layout All subViews
 */
- (void)layoutAllSubViews
{
    [TJAutoLayoutor layView:_iconView atTheLeftTopOfTheView:self.view offset:TJAutoSizeMake(13, 28)];
    [TJAutoLayoutor layView:_nickNameView toTheRightOfTheView:_iconView span:TJAutoSizeMake(13, -5) alignmentType:AlignmentTop];
    [TJAutoLayoutor layView:_tuijiView belowTheView:_nickNameView span:CGSizeZero alignmentType:AlignmentLeft];
    [TJAutoLayoutor layView:_signatureView belowTheView:_iconView span:TJAutoSizeMake(-8, 15) alignmentType:AlignmentLeft];
    [TJAutoLayoutor layView:_regionView belowTheView:_signatureView span:CGSizeZero alignmentType:AlignmentLeft];
//    [TJAutoLayoutor layView:_flagView toTheLeftOfTheView:_regionView span:CGSizeMake(-55, -2)];
    [TJAutoLayoutor layView:_addFriendView atCenterOfTheView:self.view offset:TJSizeWithHeight(28)];
    
    [self.view sendSubviewToBack:_bgView];
}

/**
 *  添加好友按钮监听
 */
- (void)addFriendBtnClick:(UIButton *)sender
{
    TJSendAddFriendRequestVC *sendRequestVC = [[TJSendAddFriendRequestVC alloc] init];
    sendRequestVC.aimUserID = self.userInfo.userId;
    [self.navigationController pushViewController:sendRequestVC animated:YES];
}

@end

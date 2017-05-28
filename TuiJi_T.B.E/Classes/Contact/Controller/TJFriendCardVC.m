//
//  TJFriendCardVC.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/8/24.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJFriendCardVC.h"
#import "TJHomeTVController.h"
#import "TJTabBar.h"


#import "GJGCChatFriendViewController.h"


@interface TJFriendCardVC ()

/**
 *  头像
 */
@property (nonatomic, weak) UIImageView *iconView;

/**
 *  昵称
 */
@property (nonatomic, weak) UILabel *nickView;

/**
 *  备注
 */
@property (nonatomic, weak) UILabel *remarkView;

/**
 *  推己号
 */
@property (nonatomic, weak) UILabel *tuijiView;

/**
 *  查看个人页面
 */
@property (nonatomic, weak) UIButton *personalView;

/**
 *  签名
 */
@property (nonatomic, weak) UILabel *signatureView;

/**
 *  地区
 */
@property (nonatomic, weak) UILabel *regionView;

/**
 *  发消息按钮
 */
@property (nonatomic, weak) UIButton *chattingView;

/**
 *  白色背景
 */
@property (nonatomic, weak) UIView *bgView;

@end

@implementation TJFriendCardVC

#pragma mark - system

/**
 *  setter
 */
- (void)setContact:(TJContact *)contact{
    _contact = contact;
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:contact.headImage] placeholderImage:[UIImage imageNamed:@"myicon"]];
    [_remarkView setText:_contact.remark];
    [_tuijiView setText:[NSString stringWithFormat:@"推己号: %@",_contact.username]];
    [_nickView setText:[NSString stringWithFormat:@"昵称: %@", _contact.nickname]];
    [_signatureView setText:[NSString stringWithFormat:@"签名: %@",_contact.signature]];
    [_regionView setText:@"地区: "];
   
    
    
    
}

- (instancetype)init{
    if (self = [super init]) {
        [self setUpAllSubViews];
        // Layout all sub views
        [self layoutAllSubViews];
        self.view.backgroundColor = TJColorGrayBg;
        
        //初始化导航条
        [self setUpNavgationBar];
    }
    return self;
}

#pragma mark - private method
/**
 *  set up all sub views
 */
- (void)setUpAllSubViews
{

    //头像
    UIImageView *iconView = [TJUICreator createImageViewWithSize:TJAutoSizeMake(66, 66)];
    _iconView = iconView;
    [self.view addSubview:_iconView];

    //备注
    UILabel *remarkView = [TJUICreator createLabelWithSize:TJAutoSizeMake(160, 20)
                                                      text:@""
                                                     color:TJColorBlackFont
                                                      font:TJFontWithSize(17)];
    _remarkView = remarkView;
    [self.view addSubview:_remarkView];
    
    //推己号
    UILabel *tuijiView = [TJUICreator createLabelWithSize:TJAutoSizeMake(160, 20)
                                                     text:@""
                                                    color:TJColorBlackFont
                                                     font:TJFontWithSize(13)];
    _tuijiView = tuijiView;
    [self.view addSubview:_tuijiView];

    //昵称
    UILabel *nickView= [TJUICreator createLabelWithSize:TJAutoSizeMake(160, 20)
                                                   text:@""
                                                  color:TJColorBlackFont
                                                   font:TJFontWithSize(16)];
    _nickView = nickView;
    [self.view addSubview:_nickView];

    //查看个人页面
    UIButton *personalView = [TJUICreator createButtonWithSize:TJAutoSizeMake(86, 26)
                                                   NormalImage:@"contact_personal"
                                              highlightedImage:@"contact_personal_h"
                                                        target:self
                                                        action:@selector(personalViewClick:)];
    _personalView = personalView;
    [self.view addSubview:_personalView];

    //签名
    UILabel *signatureView = [TJUICreator createLabelWithSize:TJAutoSizeMake(328, 40)
                                                         text:@""
                                                        color:TJColorBlackFont
                                                         font:TJFontWithSize(14)];
    _signatureView = signatureView;
    [self.view addSubview:_signatureView];
    
    //地区
    UILabel *regionView = [TJUICreator createLabelWithSize:TJAutoSizeMake(328, 20)
                                                      text:@""
                                                     color:TJColorBlackFont
                                                      font:TJFontWithSize(11)];
    _regionView = regionView;
    [self.view addSubview:_regionView];

    //发消息按钮
    UIButton *chattingView = [TJUICreator createButtonWithSize:TJAutoSizeMake(338, 49)
                                                   NormalImage:@"contact_send"
                                              highlightedImage:@"contact_send_h"
                                                        target:self
                                                        action:@selector(chattingViewClick:)];
    _chattingView = chattingView;
    [self.view addSubview:_chattingView];
    
    //白色背景
    UIView *bgView = [TJUICreator createViewWithSize:TJAutoSizeMake(375, 211)
                                             bgColor:TJColorWhite
                                              radius:0.0];
    [self.view sendSubviewToBack:bgView];
    _bgView = bgView;
    [self.view addSubview:_bgView];
}

/**
 *  layout All subViews
 */
- (void)layoutAllSubViews
{
    [TJAutoLayoutor layView:_iconView atTheLeftTopOfTheView:self.view offset:TJAutoSizeMake(14, 28)];
    [TJAutoLayoutor layView:_remarkView toTheRightOfTheView:_iconView span:TJSizeWithWidth(12) alignmentType:AlignmentTop];
    [TJAutoLayoutor layView:_tuijiView belowTheView:_remarkView span:TJSizeWithHeight(4)];
    [TJAutoLayoutor layView:_nickView belowTheView:_tuijiView span:TJSizeWithHeight(2)];
    [TJAutoLayoutor layView:_personalView toTheRightOfTheView:_tuijiView span:TJAutoSizeMake(13, 4)];
    [TJAutoLayoutor layView:_signatureView belowTheView:_iconView span:TJAutoSizeMake(4, 31) alignmentType:AlignmentLeft];
    [TJAutoLayoutor layView:_regionView belowTheView:_signatureView span:CGSizeZero];
    [TJAutoLayoutor layView:_chattingView atCenterOfTheView:self.view offset:TJSizeWithHeight(4)];
}

- (void)setUpNavgationBar
{
    UIView *titleView = [TJUICreator createTitleViewWithSize:TJAutoSizeMake(100, 23)
                                                        text:@"资料"
                                                 sysFontSize:19];
    self.navigationItem.titleView = titleView;
    
    //好友设置 按钮
    UIBarButtonItem *settingBarBtnItem = [TJUICreator createBarBtnItemWithSize:CGSizeMake(20, 20)
                                                                      Image:@"contact_setting"
                                                                  highImage:@"contact_setting_h"
                                                                     target:self
                                                                     action:@selector(friendSettingItemClick:)
                                                           forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = settingBarBtnItem;

}


- (void)friendSettingItemClick:(UIBarButtonItem *)sender
{
    
}
- (void)personalViewClick:(UIButton *)sender
{
    
}
- (void)chattingViewClick:(UIButton *)sender
{
//    NIMSession *session = [NIMSession session:_contact.deputyuserid type:NIMSessionTypeP2P];
//    TJChatViewController *chatVC = [[TJChatViewController alloc] initWithSession:session];
//    
//    [self.navigationController pushViewController:chatVC animated:YES];
    UIViewController *contact = self.navigationController.childViewControllers[0];
    TJHomeTVController *home = self.tabBarController.childViewControllers[0].childViewControllers[0];
    [self.navigationController popViewControllerAnimated:NO];
    
    for (UIView *view in contact.tabBarController.tabBar.subviews) {
        if ([view isKindOfClass:[TJTabBar class]]) {
            TJTabBar *tabbar = (TJTabBar*)view;
            [tabbar btnClick:tabbar.buttons[0]];
            break;
        }
    }
    
    NIMSession *session = [NIMSession session:_contact.userId type:NIMSessionTypeP2P];
//    TJChatViewController *chatVC = [[TJChatViewController alloc] initWithSession:session
//                                                                         contact:_contact];
//    
////    GJGCChatFriendTalkModel *talk = [[GJGCChatFriendTalkModel alloc]init];
////    talk.talkType = GJGCChatFriendTalkTypePrivate;
////    //    talk.toId = contenModel.toId;
////    //    talk.toUserName = contenModel.name.string;
////    
////    GJGCChatFriendViewController *privateChat = [[GJGCChatFriendViewController alloc]initWithTalkInfo:talk];
//    
//    chatVC.hidesBottomBarWhenPushed = YES;


    //    [self.navigationController pushViewController:chat animated:YES];
    GJGCChatFriendTalkModel *talk = [[GJGCChatFriendTalkModel alloc]init];
    talk.talkType = GJGCChatFriendTalkTypePrivate;
    talk.toId = @"0";
    talk.contact = _contact;
    talk.session = session;
    talk.toUserName = _contact.remark;
    
    GJGCChatFriendViewController *privateChat = [[GJGCChatFriendViewController alloc]initWithTalkInfo:talk];
    //    GJGCChatFriendViewController *privateChat = [[GJGCChatFriendViewController alloc] initWithSession:message.session
    //                                                                                              contact:message.contact];
    privateChat.hidesBottomBarWhenPushed = YES;
    [home.navigationController pushViewController:privateChat animated:NO];
}
@end

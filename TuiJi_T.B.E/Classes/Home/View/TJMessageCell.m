//
//  TJMessageCell.m
//  TuiJi_T.B.E
//
//  Created by zhanZhan on 16/7/15.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJMessageCell.h"

#import "TJbadgeValue.h"
#import "TJContact.h"

@interface TJMessageCell ()

/**
 *  头像
 */
@property (nonatomic, weak) UIImageView *iconView;

/**
 *  昵称
 */
@property (nonatomic, weak) UILabel *nameView;

/**
 *  消息一瞥
 */
@property (nonatomic, weak) UILabel *messageView;

/**
 *  时间
 */
@property (nonatomic, weak) UILabel *timeView;

/**
 *  小红点
 */
@property (nonatomic, weak) TJbadgeValue *badgeView;

/**
 *  消息免打扰
 */
@property (nonatomic, weak) UIImageView *unNoticeView;

@end

@implementation TJMessageCell

#pragma mark - system method

- (void)setSessionUnreadCount:(NSInteger)sessionUnreadCount{
    
    NSString *unreadCountStr = @(sessionUnreadCount).stringValue;
    
    
    if (sessionUnreadCount > 0 && !(self.message.contact.notifyForNewMsg || self.message.team.notifyForNewMsg)) {
        unreadCountStr = TJShowRedPoint;
    }
    
    if (sessionUnreadCount >= 100) {
        unreadCountStr = TJShowRedPoint;
    }

    self.badgeView.badgeValue = unreadCountStr;
}

/**
 *  init
 */
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //创建所有子控件
        [self setUpAllSubViews];
        //自动布局
        [self layoutAllSubViews];
        self.backgroundColor = TJColorWhite;
    }
    return self;
}

- (void)setMessage:(TJMessage *)message{
    _message = message;
    
    NSString *imgName = @"myicon";
    if (!_message.contact) imgName = [imgName stringByAppendingString:@"_team"];
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:_message.icon] placeholderImage:[UIImage imageNamed:imgName]];
    
    [_nameView setText:_message.name];
    [_timeView setText:_message.time];
    [_messageView setText:_message.messageText];

    self.sessionUnreadCount = _message.recentSession.unreadCount;

    if (_message.session.sessionType == NIMSessionTypeP2P) {
        TJContact *contact = _message.contact;
        if (!contact.notifyForNewMsg) {
//            _unNoticeView.hidden = ;
        }
        
        
    }else if (_message.session.sessionType == NIMSessionTypeTeam){
        NIMTeam *team = _message.team;
        _unNoticeView.hidden = NO;
        
        if (team.notifyForNewMsg) {
            [_unNoticeView setImage:[UIImage imageNamed:@"chat_team_noti"]];
        }else{
            [_unNoticeView setImage:[UIImage imageNamed:@"chat_team_unNoti"]];
        }
        
    }
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    //下分割线
    CGContextSetStrokeColorWithColor(context, TJColorlightGray.CGColor);
    CGContextStrokeRect(context, CGRectMake(_messageView.tjPoint.x, rect.size.height, rect.size.width - 10, 1));

}
#pragma mark - private method
/**
 *  set up all sub views
 */
- (void)setUpAllSubViews
{

    //头像
    UIImageView *iconView = [TJUICreator createImageViewWithName:@"placeTaker"
                                                            size:CGSizeMake(57, 57)
                                                          radius:18];

    _iconView = iconView;
    [self addSubview:_iconView];
    
    //昵称
    UILabel *nameView = [TJUICreator createLabelWithSize:TJAutoSizeMake(223, 20)
                                                    text:@""
                                                   color:TJColorBlackFont
                                                    font:TJFontWithSize(17)];

    _nameView = nameView;
    [self addSubview:_nameView];
    
    //消息
    UILabel *messageView = [TJUICreator createLabelWithSize:TJAutoSizeMake(223, 20)
                                                       text:@""
                                                      color:TJColorGray
                                                       font:TJFontWithSize(15)];

    _messageView = messageView;
    [self addSubview:_messageView];
    
    //时间
    UILabel *timeView = [TJUICreator createLabelWithSize:TJAutoSizeMake(66, 20)
                                                    text:@""
                                                   color:TJColorGray
                                                    font:TJFontWithSize(11)];
    
    _timeView = timeView;
    [self addSubview:_timeView];

    //小红点
    TJbadgeValue *badgeView = [[TJbadgeValue alloc] init];
    _badgeView = badgeView;
    [self addSubview:_badgeView];
    
    //免打扰
    UIImageView *unNotivceView = [TJUICreator createImageViewWithName:@"chat_unNotice" size:CGSizeMake(17, 17)];
    unNotivceView.hidden = YES;
    _unNoticeView = unNotivceView;
    [self addSubview:_unNoticeView];
}

/**
 *  layout All subViews
 */
- (void)layoutAllSubViews
{
    [TJAutoLayoutor layView:_iconView atTheLeftMiddleOfTheView:self offset:TJSizeWithWidth(5)];
    [TJAutoLayoutor layView:_timeView atTheRightTopOfTheView:self offset:CGSizeMake(0, 16)];
    [TJAutoLayoutor layView:_nameView toTheLeftOfTheView:_timeView span:CGSizeMake(0, -2)];
    [TJAutoLayoutor layView:_messageView belowTheView:_nameView span:CGSizeMake(0, 4)];
    [TJAutoLayoutor layView:_badgeView toTheRightOfTheView:_iconView span:CGSizeMake(-10, 6) alignmentType:AlignmentTop];
    [TJAutoLayoutor layView:_unNoticeView belowTheView:_timeView span:CGSizeMake(12, 6) alignmentType:AlignmentRight];
}

@end

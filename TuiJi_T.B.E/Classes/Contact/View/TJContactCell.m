//
//  TJContactCell.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/7/25.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJContactCell.h"
#import "TJContact.h"

#import "TJbadgeValue.h"
#import "TJGroupContactMenber.h"

@interface TJContactCell ()

/**
 *  头像
 */
@property (nonatomic, weak) UIImageView *iconView;

/**
 *  昵称
 */
@property (nonatomic, weak) UILabel *nameView;

/**
 *  小红点
 */
@property (nonatomic, weak) TJbadgeValue *badgeView;
@end

@implementation TJContactCell

#pragma mark - system method

/**
 *  init
 */
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //创建所有子控件
        [self setUpAllSubViews];
        //自动布局
        [self layoutAllSubViews];
        self.backgroundColor = TJColorWhiteBg;
    }
    return self;
}

- (void)setSessionUnreadCount:(NSInteger)sessionUnreadCount{
    
    NSString *unreadCountStr = @(sessionUnreadCount).stringValue;

    if (sessionUnreadCount >= 100) {
        unreadCountStr = TJShowRedPoint;
    }
    
    self.badgeView.badgeValue = unreadCountStr;
    [self setNeedsDisplay];
}

- (void)setContact:(TJContact *)contact{
    _contact = contact;
    
    [_nameView setText:_contact.remark];

    //判断deputyuserpictrue 是否url
    if([contact.headImage rangeOfString:@"http"].location !=NSNotFound)
    {
        [_iconView sd_setImageWithURL:[NSURL URLWithString:_contact.headImage] placeholderImage:[UIImage imageNamed:@"myicon"]];
        
    }else{
        [_iconView setImage:[UIImage imageNamed:_contact.headImage]];
        
        _nameView.font = TJFontWithSize(16);
        _nameView.textColor = TJColorBlackFont;
    }
    
}

- (void)setMember:(TJGroupContactMenber *)member{
    _member = member;
    
    [_nameView setText:_member.nickname];
    [_iconView sd_setImageWithURL:[NSURL URLWithString:_member.headImage] placeholderImage:[UIImage imageNamed:@"myicon"]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {}

/**
 *  绘制分割线
 */
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    //下分割线
    CGContextSetStrokeColorWithColor(context, TJColor(240, 240, 240).CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height, rect.size.width, 1));
}

#pragma mark - private method
/**
 *  set up all sub views
 */
- (void)setUpAllSubViews
{
    
    //头像
    UIImageView *iconView = [TJUICreator createImageViewWithName:@"placeTaker"
                                                            size:CGSizeMake(36, 36)
                                                          radius:13];
    
    _iconView = iconView;
    [self addSubview:_iconView];
    
    //昵称
    UILabel *nameView = [TJUICreator createLabelWithSize:TJAutoSizeMake(250, 20)
                                                    text:@""
                                                   color:TJColorGrayFontDark
                                                    font:TJFontWithSize(15)];
    
    _nameView = nameView;
    [self addSubview:_nameView];
    
    //小红点
    TJbadgeValue *badgeView = [[TJbadgeValue alloc] init];
    badgeView.badgeValue = nil;
    _badgeView = badgeView;
    [self addSubview:_badgeView];
    
 }

/**
 *  layout All subViews
 */
- (void)layoutAllSubViews
{
    [TJAutoLayoutor layView:_iconView atTheLeftMiddleOfTheView:self offset:TJSizeWithWidth(10)];
    [TJAutoLayoutor layView:_nameView toTheRightOfTheView:_iconView span:TJAutoSizeMake(10, 2)];
    
    [TJAutoLayoutor layView:_badgeView atTheRightMiddleOfTheView:self offset:TJSizeWithWidth(16)];
}


@end

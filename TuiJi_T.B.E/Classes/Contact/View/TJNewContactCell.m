//
//  TJNewContactCell.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/8/10.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJNewContactCell.h"

#import "TJNewContactRequest.h"

@interface TJNewContactCell ()

@end

@implementation TJNewContactCell

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

- (void)setAddNewContact:(TJNewContactRequest *)addNewContact{
    _addNewContact = addNewContact;

    [_nameView setText:_addNewContact.deputyusername];
    [_detailView setText:_addNewContact.message];
    
    //判断deputyuserpictrue 是否url
    if([addNewContact.deputyuserpictrue rangeOfString:@"img.tuiji.net"].location !=NSNotFound)
    {
        [_iconView sd_setImageWithURL:[NSURL URLWithString:_addNewContact.deputyuserpictrue] placeholderImage:[UIImage imageNamed:@"myicon"]];
    }else{
        [_iconView setImage:[UIImage imageNamed:_addNewContact.deputyuserpictrue]];
    }
    
    self.cellType = _addNewContact.addNewFriendCellType;
}

- (void)setCellType:(TJNewFriendCellType)cellType{
    _cellType = cellType;
    
    if (_cellType == TJNewFriendCellTypeNewFriend) {
        [_rightView setImage:[UIImage imageNamed:@"contact_btn_add"] forState:UIControlStateNormal];
        [_rightView setImage:[UIImage imageNamed:@"contact_btn_add_h"] forState:UIControlStateHighlighted];
    }else if (_cellType == TJNewFriendCellTypeWillAdd){
        [_rightView setImage:[UIImage imageNamed:@"contact_btn_agree"] forState:UIControlStateNormal];
        [_rightView setImage:[UIImage imageNamed:@"contact_btn_agree_h"] forState:UIControlStateHighlighted];
    }else if (_cellType == TJNewFriendCellTypeDidAdd){
        [_rightView setImage:[UIImage imageNamed:@"contact_btn_didAdd"] forState:UIControlStateNormal];
        _rightView.userInteractionEnabled = NO;
    }
}

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
    //标题专用
    UILabel *titleView = [TJUICreator createLabelWithSize:TJAutoSizeMake(225, 20)
                                                     text:@""
                                                    color:TJColorBlackFont
                                                     font:TJFontWithSize(16)];
    
    _titleView = titleView;
    _titleView.hidden = YES;
    [self addSubview:_titleView];
    
    //头像
    UIImageView *iconView = [TJUICreator createImageViewWithName:@"placeTaker"
                                                            size:TJAutoSizeMake(36, 36)
                                                          radius:5];
    
    _iconView = iconView;
    [self addSubview:_iconView];
    
    //昵称
    UILabel *nameView = [TJUICreator createLabelWithSize:TJAutoSizeMake(225, 20)
                                                    text:@""
                                                   color:TJColorBlackFont
                                                    font:TJFontWithSize(17)];
    
    _nameView = nameView;
    [self addSubview:_nameView];
    
    //详情
    UILabel *detailView = [TJUICreator createLabelWithSize:TJAutoSizeMake(225, 20)
                                                      text:@""
                                                     color:TJColorGrayFontLight
                                                      font:TJFontWithSize(12)];
    _detailView = detailView;
    [self addSubview:_detailView];
    
    UIButton *rightView = [TJUICreator createButtonWithSize:CGSizeMake(55, 25)
                                                NormalImage:@""
                                              selectedImage:@""
                                                     target:self
                                                     action:@selector(agreeViewClick:)];
    _rightView = rightView;
    self.accessoryView = rightView;
}

/**
 *  layout All subViews
 */
- (void)layoutAllSubViews
{
    [TJAutoLayoutor layView:_titleView atTheLeftMiddleOfTheView:self offset:TJSizeWithWidth(10)];
    [TJAutoLayoutor layView:_iconView atTheLeftMiddleOfTheView:self offset:TJSizeWithWidth(10)];
    [TJAutoLayoutor layView:_nameView toTheRightOfTheView:_iconView span:CGSizeMake(16, 2) alignmentType:AlignmentTop];
    [TJAutoLayoutor layView:_detailView toTheRightOfTheView:_iconView span:CGSizeMake(16, -2) alignmentType:AlignmentBottom];
    
    [TJAutoLayoutor layView:_rightView atTheRightMiddleOfTheView:self offset:TJSizeWithWidth(10)];
    
}

- (void)agreeViewClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(tableViewCell:agreeViewClick:)]) {
        [self.delegate tableViewCell:self agreeViewClick:sender];
    }
    
}

@end

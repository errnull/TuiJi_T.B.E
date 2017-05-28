//
//  GWYAlertSelectViewController.m
//  自定义AlertView
//
//  Created by 李国良 on 2016/9/23.
//============================================================================
//  欢迎各位提宝贵的意见给我  185226139 感谢大家的支持
// https://github.com/liguoliangiOS/GWYAlertSelectView.git
//=============================================================================


#import "GWYAlertSelectViewController.h"
#import "TJTransmitToContactCell.h"

#import "TJAccount.h"
#import "TJContact.h"

#define GWYCELLBorderW 10

@interface GWYAlertSelectViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) UIView * titltView;
@property (nonatomic, weak) UILabel * titleLabel;
@property (nonatomic, weak) UIButton * addContactBtn;
@property (nonatomic, weak) UIButton * toTimeLineBtn;
@property (nonatomic, weak) UIButton *cancelBtn;

@property (nonatomic, weak) UICollectionView *collectionView;


@property (nonatomic, strong) NSMutableArray *recentContactList;
@end

@implementation GWYAlertSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self setUpTitltView];
    [self setUpCollectionView];
    [self setUpCancelView];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([TJTransmitToContactCell class]) bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:NSStringFromClass([TJTransmitToContactCell class])];
    
    [self loadRecentChatList];
}

- (void)setUpTitltView {
    UIView *titleView = [TJUICreator createViewWithSize:CGSizeMake(TJWidthDevice, 53)
                                                bgColor:TJColorWhiteBg
                                                 radius:0];
    _titltView = titleView;
    
    //标题
    UILabel *titleLabel = [TJUICreator createLabelWithSize:CGSizeMake(100, 100)
                                                      text:@"发给"
                                                     color:TJColorBlackFont
                                                      font:TJFontWithSize(17)];
    [titleLabel sizeToFit];
    _titleLabel = titleLabel;
    [TJAutoLayoutor layView:_titleLabel atCenterOfTheView:self.titltView offset:CGSizeZero];
    
    //左边 添加转发好友 按钮
    UIButton *addContactBtn = [TJUICreator createButtonWithSize:CGSizeMake(29, 29)
                                                    NormalImage:@"timeLine_addContact"
                                               highlightedImage:@"timeLine_addContact_h"
                                                         target:self
                                                         action:@selector(addContactBtnClick:)];
    addContactBtn.imageEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
    _addContactBtn = addContactBtn;
    [TJAutoLayoutor layView:_addContactBtn atTheLeftMiddleOfTheView:self.titltView offset:CGSizeMake(13, 0)];
    
    //右边 转发到推己圈 按钮
    UIButton *toTimeLineBtn = [TJUICreator createButtonWithSize:CGSizeMake(29, 29)
                                                    NormalImage:@"timeLine_toTimeline"
                                               highlightedImage:@"timeLine_toTimeline_h"
                                                         target:self
                                                         action:@selector(toTimeLineBtnClick:)];
    toTimeLineBtn.imageEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
    _toTimeLineBtn = toTimeLineBtn;
    [TJAutoLayoutor layView:_toTimeLineBtn atTheRightMiddleOfTheView:self.titltView offset:CGSizeMake(13, 0)];
    
    //下划线
    UIView *bottomLine = [TJUICreator createLineWithSize:CGSizeMake(TJWidthDevice, 0.5) bgColor:TJColorLine];
    [TJAutoLayoutor layView:bottomLine atTheBottomMiddleOfTheView:self.titltView offset:CGSizeZero];

    [self.view addSubview:self.titltView];
}

- (void)addContactBtnClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(alertSelectView:clickAddBtn:)]) {
        [self.delegate alertSelectView:self clickAddBtn:sender];
    }
}

- (void)toTimeLineBtnClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(alertSelectView:clickToTimeLineBtn:)]) {
        [self.delegate alertSelectView:self clickToTimeLineBtn:sender];
    }
}

- (void)setUpCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    CGFloat itemW = 58;
    CGFloat itemH = 82;
    
    
    flowLayout.itemSize = CGSizeMake(itemW, itemH);
//    flowLayout.minimumInteritemSpacing =itemMargin ;
    flowLayout.minimumLineSpacing = 20;
    
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 0);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:TJRectFromSize(CGSizeMake(TJWidthDevice, 133)) collectionViewLayout:flowLayout];
    collectionView.backgroundColor = TJColorWhiteBg;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsHorizontalScrollIndicator = NO;
    
    collectionView.gjcf_top = self.titltView.gjcf_bottom;
    
    _collectionView = collectionView;
    
    [self.view addSubview:_collectionView];
    
    
}

- (void)setUpCancelView
{
    UIButton *cancelBtn = [TJUICreator createButtonWithTitle:@"取消"
                                                        size:CGSizeMake(TJWidthDevice, 53)
                                                  titleColor:TJColorBlackFont
                                                        font:TJFontWithSize(20)
                                                      target:self
                                                      action:@selector(cancelClick:)];
    cancelBtn.backgroundColor = TJColorWhiteBg;
    cancelBtn.gjcf_top = self.collectionView.gjcf_bottom;
    
    _cancelBtn = cancelBtn;
    [self.view addSubview:_cancelBtn];
    
    //上划线
    UIView *topLine = [TJUICreator createLineWithSize:CGSizeMake(TJWidthDevice, 0.5) bgColor:TJColorLine];
    
    topLine.gjcf_bottom = _cancelBtn.gjcf_top;
    [self.view addSubview:topLine];
}

- (void)cancelClick:(UIButton *)cancelButton {
    if ([self.delegate respondsToSelector:@selector(alertSelectView:clickCancelBtn:)]) {
        [self.delegate alertSelectView:self clickCancelBtn:cancelButton];
    }
}

- (void)loadRecentChatList
{
    NSMutableArray *recentSessions = [[NIMSDK sharedSDK].conversationManager.allRecentSessions mutableCopy];
    if (!recentSessions.count) {
        recentSessions = [NSMutableArray array];
    }
    self.recentContactList = [NSMutableArray array];
    
    for (NIMRecentSession *recentSession in recentSessions) {
        
        if (recentSession.session.sessionId.length == TJAccountCurrent.userId.length) {
            TJContact *contact = [TJContact contactWithUserId:recentSession.session.sessionId];
            if (!contact) continue;
            
            [self.recentContactList addObject:contact];
        }
    }
    [self.collectionView reloadData];
    
}

#pragma mark - UICollectionView Delegate Datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.recentContactList.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TJContact *contact = self.recentContactList[indexPath.row];
    
    TJTransmitToContactCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TJTransmitToContactCell class]) forIndexPath:indexPath];
    
    cell.recentContact = contact;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TJContact *contact = self.recentContactList[indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(alertSelectView:finishSelected:)]) {
        [self.delegate alertSelectView:self finishSelected:contact];
    }
}

#pragma mark ==== Block ======

- (void)alertSelectViewEditBlock:(EditBlock)block {
    self.editBlock = block;
}

- (void)alertSelectViewSelectedBlock:(SelectedBlock)block {
    self.selectedBlock = block;
}


@end

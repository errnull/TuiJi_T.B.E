//
//  TJTimeLineCommentVC.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/15.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJTimeLineCommentVC.h"
#import "TJTimeLineCommentCell.h"

#import "TJTimeLine.h"
#import "TJCommentModel.h"

#import "KeyboardToolBar.h"

#import "TJCommentParam.h"

#import "TJAccount.h"
#import "TJURLList.h"

@interface TJTimeLineCommentVC ()<UITextFieldDelegate>

/**
 *  评论数组
 */
@property (nonatomic, strong) NSMutableArray *timeLineCommentList;

@property (nonatomic, weak) UITextField *commentTextField;

@end

@implementation TJTimeLineCommentVC
{
    TJTimeLineCommentCell *_currentCommentCell;
    UIButton *_commentBtn;
}

/**
 *  懒加载
 */
- (NSMutableArray *)timeLineCommentList{
    if (!_timeLineCommentList) {
        _timeLineCommentList = [NSMutableArray array];
    }
    return _timeLineCommentList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = TJColorGrayBg;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self loadTimeLineComment];
    
    [self setUpNavgationBar];
    
    [self setUpTextField];
    
    [KeyboardToolBar registerKeyboardToolBar:self.commentTextField];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self setUpCommentBtn];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [_commentBtn removeFromSuperview];
}

#pragma mark - private method
/**
 *  初始化评论按钮
 */
- (void)setUpCommentBtn
{
    UIButton *commentBtn = [TJUICreator createButtonWithSize:CGSizeMake(50, 50)
                                                 NormalImage:@"timeLine_commentIcon_h"
                                            highlightedImage:@"timeLine_commentIcon"
                                                      target:self
                                                      action:@selector(commentBtnClick:)];
    commentBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [self.navigationController.view insertSubview:commentBtn aboveSubview:self.navigationController.navigationBar];
    
    commentBtn.gjcf_right = self.navigationController.navigationBar.gjcf_right - 14;
    commentBtn.gjcf_bottom = TJHeightDevice - 14;
    
    _commentBtn = commentBtn;
}

- (void)commentBtnClick:(UIButton *)sender
{
    [self.commentTextField becomeFirstResponder];
}

/**
 *  设置输入框
 */
- (void)setUpTextField
{
    UITextField *textField = [TJUICreator createTextFieldWithSize:CGSizeZero placeholder:@" 添加评论..." delegate:self];
    textField.hidden = YES;
    
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.returnKeyType = UIReturnKeyDone;
    
    _commentTextField = textField;
    
    [self.view addSubview:_commentTextField];
}

/**
 *  设置导航条内容
 */
- (void)setUpNavgationBar
{
    //titleView
    UIView *titleView = [TJUICreator createTitleViewWithSize:CGSizeMake(100, 23)
                                                        text:@"评论"
                                                   textColor:TJColorBlackFont
                                                 sysFontSize:20];
    
    self.navigationItem.titleView = titleView;
    
}

- (void)loadTimeLineComment
{
    [TJRemindTool showMessage:@""];
    [TJTimeLineTool loadTimeLineCommentWithTuiID:_currentTimeLine.tId
                                         success:^(NSArray *timeLineCommentList) {
                                             [TJRemindTool hideHUD];
                                             
                                             self.timeLineCommentList = [NSMutableArray arrayWithArray:timeLineCommentList];
                                             
                                             if (self.timeLineCommentList.count) {
                                                 [self.tableView reloadData];
                                             }else{
                                                 [_commentTextField becomeFirstResponder];
                                             }
                                             
                                         } failure:^(NSError *error) {}];
    
    
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TJCommentModel *commentModel = self.timeLineCommentList[indexPath.row];
    
    CGSize commentSize = [commentModel.realComments.string sizeWithFont:TJFontWithSize(12) maxSize:CGSizeMake(TJWidthDevice - 85, MAXFLOAT)];
    
    return (36 + commentSize.height);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
    return self.timeLineCommentList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TJCommentModel *commentModel = self.timeLineCommentList[indexPath.row];
    
    TJTimeLineCommentCell *cell = [TJTimeLineCommentCell cellWithTableView:tableView];
    
    cell.commentModel = commentModel;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     [_commentTextField resignFirstResponder];
    
    TJTimeLineCommentCell *cell = (TJTimeLineCommentCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    _currentCommentCell = cell;
    
    NSString *showStr = [@"回复: " stringByAppendingString:_currentCommentCell.commentModel.hostFriendsInfo.remark];
    
    [self.commentTextField setPlaceholder:showStr];
    
    [self.commentTextField becomeFirstResponder];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_commentTextField resignFirstResponder];
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_commentTextField resignFirstResponder];
    
    NSString *URLStr = [TJUrlList.commentATimeLine stringByAppendingString:TJAccountCurrent.jsessionid];
    
    TJCommentParam *param = [[TJCommentParam alloc] init];
    
    if (_currentCommentCell) {
        
        //评论某条评论
        param.refCommId = _currentCommentCell.commentModel.commId;
        param.refCommUId = _currentCommentCell.commentModel.commUId;
    }
    
    param.comments = self.commentTextField.text;
    param.commUId =  TJAccountCurrent.userId;
    param.tId = _currentTimeLine.tId;
    
    [TJHttpTool GET:URLStr
         parameters:param.mj_keyValues
            success:^(id responseObject) {
               
                _commentTextField.text = @"";
                
//                @property (nonatomic, strong) TJCommentUserInfo *hostFriendsInfo;
//                
//                /**
//                 *  被评人信息
//                 */
//                @property (nonatomic, strong) TJCommentUserInfo *refFriendsInfo;
                TJCommentModel *model = [TJCommentModel mj_objectWithKeyValues:responseObject[@"data"]];
                
        
                TJCommentUserInfo *hostFriendsInfo = [[TJCommentUserInfo alloc] init];
                hostFriendsInfo.userId = TJAccountCurrent.userId;
                hostFriendsInfo.nickname = TJUserInfoCurrent.uNickname;
                hostFriendsInfo.headImage = TJUserInfoCurrent.uPicture;
                
                model.hostFriendsInfo = hostFriendsInfo;
            
                if (_currentCommentCell) {
                    model.refFriendsInfo = _currentCommentCell.commentModel.hostFriendsInfo;
                }

                [self.timeLineCommentList insertObject:model atIndex:0];
                [self.tableView reloadData];

                [TJRemindTool showSuccess:@"评论成功.."];
                
            } failure:^(NSError *error) {
                
            }];
    
    
    return YES;
    
}

@end

//
//  TJCommentTVC.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/9.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJCommentTVC.h"

#import "KeyboardToolBar.h"

#import "TJSquareNewsTool.h"
#import "TJSquareNews.h"

#import "TJURLList.h"
#import "TJAccount.h"

#import "TJSquareCommentParam.h"
#import "TJSquareCommentModel.h"
#import "TJTimeLineCommentCell.h"

@interface TJCommentTVC ()<UITextFieldDelegate>

/**
 *  评论数组
 */
@property (nonatomic, strong) NSMutableArray *squareCommentList;

@property (nonatomic, weak) UITextField *commentTextField;

@end

@implementation TJCommentTVC{
    TJTimeLineCommentCell *_currentCommentCell;
    UIButton *_commentBtn;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setUpCommentBtn];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [_commentBtn removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = TJColorGrayBg;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [self loadSquareComment];
    
    [self setUpNavigationBar];
    
    [self setUpTextField];
    
    [KeyboardToolBar registerKeyboardToolBar:self.commentTextField];
}
- (void)setUpNavigationBar
{
    UIView *titleView = [TJUICreator createTitleViewWithSize:CGSizeMake(100, 23)
                                                        text:@"评论"
                                                   textColor:TJColorBlackFont
                                                 sysFontSize:18];
    self.navigationItem.titleView = titleView;
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

- (void)loadSquareComment
{
    [TJRemindTool showMessage:@""];
    [TJSquareNewsTool loadSquareCommentWithID:_currentSquareNews.squareNewsID
                                         type:_currentSquareNews.squareNewsType
                                      success:^(NSArray *squareCommentList) {
                                          [TJRemindTool hideHUD];
                                          
                                          self.squareCommentList = [NSMutableArray arrayWithArray:squareCommentList];
                                          
                                          if (self.squareCommentList.count) {
                                              [self.tableView reloadData];
                                          }else{
                                              [_commentTextField becomeFirstResponder];
                                          }
                                          
                                          
                                      } failure:^(NSError *error) {}];
    
}


#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TJSquareCommentModel *squareCommentModel = self.squareCommentList[indexPath.row];
    
    CGSize commentSize = [squareCommentModel.realComments.string sizeWithFont:TJFontWithSize(12) maxSize:CGSizeMake(TJWidthDevice - 85, MAXFLOAT)];
    
    return (36 + commentSize.height);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return self.squareCommentList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    TJSquareCommentModel *model = self.squareCommentList[indexPath.row];
    
    TJTimeLineCommentCell *cell = [TJTimeLineCommentCell cellWithTableView:tableView];
    cell.squareCommentModel = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_commentTextField resignFirstResponder];
    
    TJTimeLineCommentCell *cell = (TJTimeLineCommentCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    _currentCommentCell = cell;
    
    NSString *showStr = [@"回复: " stringByAppendingString:_currentCommentCell.squareCommentModel.lnterlocutorname];
    
    [self.commentTextField setPlaceholder:showStr];
    
    [self.commentTextField becomeFirstResponder];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_commentTextField resignFirstResponder];
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_commentTextField resignFirstResponder];
    
    NSString *URLStr = [TJUrlList.commentASquareNews stringByAppendingString:TJAccountCurrent.jsessionid];
    
    TJSquareCommentParam *param = [[TJSquareCommentParam alloc] init];
    
    if (_currentCommentCell) {
        param.CommentID = _currentCommentCell.squareCommentModel.commentId;
    }
    param.userID = TJAccountCurrent.userId;
    param.user2ID = _currentSquareNews.userid;
    param.context = self.commentTextField.text;
    param.ID = _currentSquareNews.squareNewsID;
    param.type = _currentSquareNews.squareNewsType;
    
    [TJHttpTool POST:URLStr
          parameters:param.mj_keyValues
             success:^(id responseObject) {
                 
                 _commentTextField.text = @"";
                 
                 TJSquareCommentModel *commentModel = [TJSquareCommentModel mj_objectWithKeyValues:responseObject[@"data"]];
                 
                 if (commentModel) {
                     [self.squareCommentList insertObject:commentModel atIndex:0];
                     [self.tableView reloadData];
                 }

                 [TJRemindTool showSuccess:@"评论成功.."];
                 
             } failure:^(NSError *error) {
                 
             }];
    
    return YES;
    
}


@end

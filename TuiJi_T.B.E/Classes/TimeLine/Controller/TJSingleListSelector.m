//
//  TJSingleListSelector.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/17.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJSingleListSelector.h"

#import "TJContact.h"

#import "TJSearchController.h"
#import "TJContactSearchResultController.h"

#import "TJRecentChatCell.h"

@interface TJSingleListSelector ()<UISearchBarDelegate>

@property (nonatomic, strong) TJSearchController *searchController;

@property (nonatomic, strong) NSMutableArray *sectionArray;

@property (nonatomic, strong) NSMutableArray *sectionTitlesArray;

@property (nonatomic, strong) NSMutableArray *contactsList;

@property (nonatomic, strong) NSMutableArray *titleSettingArray;

@property (nonatomic, strong) NSMutableArray *selectedContactList;

@end

@implementation TJSingleListSelector
#pragma mark - system method
/**
 *  懒加载
 */
- (NSMutableArray *)selectedContactList{
    if (!_selectedContactList) {
        _selectedContactList = [NSMutableArray array];
    }
    return _selectedContactList;
}

- (NSMutableArray *)titleSettingArray{
    if (!_titleSettingArray) {
        _titleSettingArray = [NSMutableArray array];
    }
    return _titleSettingArray;
}

- (NSMutableArray *)contactsList{
    if (_dataList) {
        return _dataList;
    }
    return [NSMutableArray array];
}

- (instancetype)initWithDataList:(NSMutableArray *)dataList{
    if (self = [super init]) {
        _dataList = dataList;
        
        //取消分割线
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.tableView.backgroundColor = TJColorGrayBg;
        
        [self setUpNavgationBar];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setUpTableSection];
    
    [self.tableView reloadData];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    for (UIView *view in self.tableView.subviews) {
        
        if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
            
            UITableViewHeaderFooterView *footView = (UITableViewHeaderFooterView*)view;
            
            footView.tintColor = TJColorGrayBg;
            footView.textLabel.font = TJFontWithSize(14);
            footView.textLabel.textColor = TJColorGrayFontLight;
            
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpAllSubViews];
    
    for (UIView *view in self.tableView.subviews) {
        
        if ([view isKindOfClass:[UIView class]] && view.width == TJWidthDevice && ![view isKindOfClass:[UITableViewHeaderFooterView class]]) {
            
            view.backgroundColor = TJColorGrayBg;
            
            break;
            
        }
    }
}

#pragma mark - private method
/**
 *  设置导航条内容
 */
- (void)setUpNavgationBar
{
    //titleView
    UIView *titleView = [TJUICreator createTitleViewWithSize:CGSizeMake(100, 23)
                                                        text:@"选择好友"
                                                   textColor:TJColorBlackFont
                                                 sysFontSize:20];
    
    self.navigationItem.titleView = titleView;
}


- (void)setUpAllSubViews
{
    TJContactSearchResultController *searchResultController = [[TJContactSearchResultController alloc] init];
    self.searchController = [[TJSearchController alloc] initWithSearchResultsController:searchResultController];
    self.searchController.view.backgroundColor = TJColorGrayBg;
    
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    
    
    UISearchBar *bar = self.searchController.searchBar;
    
    bar.showsCancelButton = NO;
    
    bar.barStyle = UIBarStyleDefault;
    bar.translucent = YES;
    bar.barTintColor = TJColor(235, 235, 235);
    bar.tintColor = TJColorBlackFont;
    
    bar.showsBookmarkButton = YES;
    
    [bar setImage:[UIImage imageNamed:@"VoiceSearchStartBtn"] forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateNormal];
    bar.delegate = self;
    
    CGRect rect = bar.frame;
    rect.size.height = 44;
    bar.frame = rect;
    
    for (UIView *view in bar.subviews) {
        // for later iOS7.0(include)
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
    
    self.tableView.tableHeaderView = bar;
    self.tableView.sectionIndexColor = TJColorlightGray;
    self.tableView.sectionIndexBackgroundColor = TJColorClear;
}


- (void)setUpTableSection
{
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    //create a temp sectionArray
    NSUInteger numberOfSections = [[collation sectionTitles] count];
    NSMutableArray *newSectionArray =  [[NSMutableArray alloc]init];
    for (NSUInteger index = 0; index<numberOfSections; index++) {
        [newSectionArray addObject:[[NSMutableArray alloc]init]];
    }
    
    // insert Persons info into newSectionArray
    for (TJContact *model in self.contactsList) {
        
        NSUInteger sectionIndex = [collation sectionForObject:model collationStringSelector:@selector(remark)];
        [newSectionArray[sectionIndex] addObject:model];
    }
    
    //sort the person of each section
    for (NSUInteger index=0; index<numberOfSections; index++) {
        NSMutableArray *personsForSection = newSectionArray[index];
        NSArray *sortedPersonsForSection = [collation sortedArrayFromArray:personsForSection collationStringSelector:@selector(remark)];
        newSectionArray[index] = sortedPersonsForSection;
    }
    
    
    NSMutableArray *temp = [NSMutableArray new];
    self.sectionTitlesArray = [NSMutableArray new];
    
    [newSectionArray enumerateObjectsUsingBlock:^(NSArray *arr, NSUInteger idx, BOOL *stop) {
        if (arr.count == 0) {
            [temp addObject:arr];
        } else {
            [self.sectionTitlesArray addObject:[collation sectionTitles][idx]];
        }
    }];
    
    [newSectionArray removeObjectsInArray:temp];
    
    self.sectionArray = newSectionArray;
    
}


#pragma mark - tableView delegate
/**
 *  设置cell高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55.0;
}

/**
 *  多少组
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionTitlesArray.count;
}

/**
 * 每一组各多少行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.sectionArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    TJContact *contact = self.sectionArray[section][row];
    
    TJRecentChatCell *cell = [TJRecentChatCell cellWithTableView:tableView];
    
    cell.contact = contact;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.navigationController popViewControllerAnimated:YES];
    
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    TJContact *contact = self.sectionArray[section][row];
    
    if ([self.delegate respondsToSelector:@selector(singleListSelector:didFinishSelect:)]) {
        [self.delegate singleListSelector:self didFinishSelect:contact];
    }
}

//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 25;
    }
    
    return 25;//section头部高度
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSMutableArray *arr = (NSMutableArray *)self.tableView.subviews;
    [arr removeObjectsInArray:self.titleSettingArray];
    for (UIView *view in arr) {
        if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
            
            UITableViewHeaderFooterView *footView = (UITableViewHeaderFooterView*)view;
            
            footView.tintColor = TJColorGrayBg;
            footView.textLabel.font = TJFontWithSize(14);
            footView.textLabel.textColor = TJColorGrayFontLight;
            
            [self.titleSettingArray addObject:footView];
        }
    }
    
    return [self.sectionTitlesArray objectAtIndex:section];
}

/**
 *  首字母导航条
 */
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.sectionTitlesArray;
    
}

#pragma mark - UISearchBarDelegate

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar
{
    
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    self.navigationController.navigationBarHidden = YES;
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    self.navigationController.navigationBarHidden = NO;
    
}



@end

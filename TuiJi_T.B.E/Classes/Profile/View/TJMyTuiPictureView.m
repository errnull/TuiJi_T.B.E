//
//  TJMyTuiPictureView.m
//  TuiJi_T.B.E
//
//  Created by TUIJI on 2016/9/29.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJMyTuiPictureView.h"

@interface TJMyTuiPictureView ()

@end

@implementation TJMyTuiPictureView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        CGFloat itemMargin = 1;
        CGFloat itemW = (TJWidthDevice-2*itemMargin)/3;
        
        
        flowLayout.itemSize = CGSizeMake(itemW, itemW);
        flowLayout.minimumInteritemSpacing =itemMargin ;
        flowLayout.minimumLineSpacing = itemMargin;
        
        UICollectionView *tableView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
//        tableView.dataSource = self;
//        tableView.delegate = self;
        _tableview = tableView;
        _tableview.frame = CGRectMake(0, 0, TJWidthDevice, frame.size.height);
        [self addSubview:_tableview];
    }
    return self;
}
//
//#pragma mark tableViewDelegate
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 20;
//}
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    static NSString *ID = @"MoreViewCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
//        cell.textLabel.text = @"MoreView";
//        cell.backgroundColor = TJColorWithAlpha(252, 252, 252, 1);
//    }
//    
//    return cell;
//}
//
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 300;
//}


@end

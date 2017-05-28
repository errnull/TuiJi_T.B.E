//
//  TJDropDownMenu.m
//  自定制下拉菜单
//
//  Created by hezhijingwei on 16/6/28.
//  Copyright © 2016年 秦传龙. All rights reserved.
//

#import "TJDropDownMenu.h"

#import "TJDropDownMenuCell.h"

#import "TJDropDownCellModel.h"

CGFloat _cellHeight = 44;
@interface TJDropDownMenu ()<UITableViewDelegate,UITableViewDataSource> {
    
    NSArray *_titleList;
    
}

/**
 *  背景视图暗色的
 */
@property (nonatomic ,strong) UIView *bgView;

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic, assign) CGRect BtnPressedFrame;

@property (nonatomic, copy) indexPressedBlock block;

@property (nonatomic ,strong) UIImageView *bgImageView;


@end


@implementation TJDropDownMenu



-(instancetype)initWithBtnPressedByWindowFrame:(CGRect)frame Pressed:(indexPressedBlock)indexPressed{
    
    self = [super initWithFrame:TJRectFullScreen];
    
    if (self) {
        self.block = indexPressed;
        self.BtnPressedFrame = frame;
        self.direction = TJDirectionTypeBottom;
        [self createWindowBySelf];
        [self addTapGesture];
        
        self.alpha = 1;
    }
    
    return self;
}


- (UIImageView *)bgImageView {
    
    if (nil == _bgImageView) {
        
        UIImage *image = [UIImage imageNamed:@"navigationBarPlusBtnBg"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        image  = [image resizableImageWithCapInsets:UIEdgeInsetsMake(30 ,30 ,30 ,30) resizingMode:UIImageResizingModeStretch];
        imageView.frame = CGRectZero;
        _bgImageView = imageView;
        [self addSubview:imageView];
        _bgImageView.userInteractionEnabled = YES;
    }
    return _bgImageView;
    
}



- (UITableView *)tableView {
    
    if (nil == _tableView) {
        
        
        _tableView = [[UITableView alloc] initWithFrame:self.bgImageView.frame style:UITableViewStylePlain];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIImage *image = [UIImage imageNamed:@"bg"];
        _tableView.backgroundColor = [UIColor colorWithPatternImage:image];
        _tableView.bounces = NO;
        _tableView.backgroundColor = TJColorClear;
        
        
    }
    
    return _tableView;
    
}

- (NSArray *)titleList {
    
    return _titleList;
    
}


- (void)setDropDownMenuModel:(NSArray *)dropDownMenuModel{
    _dropDownMenuModel = dropDownMenuModel;
    
    NSMutableArray *titleArr = [NSMutableArray array];
    
    for (TJDropDownCellModel *model in _dropDownMenuModel) {
        [titleArr addObject:model.text];
    }
    
    _titleList = titleArr;
    [self.bgImageView addSubview:self.tableView];
    
    [self show];
    
    
    
    [self.tableView reloadData];
    
}


- (void)show {
    CGFloat btnX = self.BtnPressedFrame.origin.x;
    CGFloat btnY = self.BtnPressedFrame.origin.y;
    CGFloat btnW = self.BtnPressedFrame.size.width;
    CGFloat btnH = self.BtnPressedFrame.size.height;
   
    switch (self.direction) {
        case TJDirectionTypeTop:
        {
            
            CGRect tableStartFrame = CGRectMake(0, 0, 1, 1);
            CGRect tableEndFrame   = CGRectMake(0, 0, 120.0, self.titleList.count*_cellHeight);
            CGRect bgStartFrame    = CGRectMake(btnX, btnY - 8, 1, 1);
            CGRect bgEndFrame      = CGRectMake(btnX, btnY -self.titleList.count*_cellHeight - 18 , 120.0, self.titleList.count*_cellHeight+10);
            [self allVerShowWithImageName:@"top" initTabelViewStartFrame:tableStartFrame TabelViewEndFrame:tableEndFrame bgStartFrame:bgStartFrame bgEndFrame:bgEndFrame flag:1];
            
            
        }
            
            break;
        case TJDirectionTypeBottom:
        {
            
            CGRect tableStartFrame = CGRectMake(0, 8, 1, 1);
            CGRect tableEndFrame   = CGRectMake(0, 8, 130, self.titleList.count*_cellHeight);
            CGRect bgStartFrame    = CGRectMake(btnX + btnW, btnY + btnH + 38, 1, 1);
            CGRect bgEndFrame      = CGRectMake(btnW + btnX - 120.0 - 6, btnY + btnH + 38, 120.0 + 10, self.titleList.count*_cellHeight+10);
            
            [self allVerShowWithImageName:@"navigationBarPlusBtnBg" initTabelViewStartFrame:tableStartFrame TabelViewEndFrame:tableEndFrame bgStartFrame:bgStartFrame bgEndFrame:bgEndFrame flag:0];
        }
            
            break;
            
        case TJDirectionTypeLeft:
        {
            CGRect startFrame = CGRectMake(btnX - 8 , btnY, 1, 1);
            CGRect endFrame   = CGRectMake(btnX - 120.0 - 8, btnY , 120.0, self.titleList.count*_cellHeight);
            [self allHevShowWithImageName:@"left" initFrame:startFrame EndFrame:endFrame];
        }
            
            break;
            
        case TJDirectionTypeRight:
        {
            CGRect startFrame = CGRectMake(btnX + btnW + 8 , btnY, 1, 1);
            CGRect endFrame   = CGRectMake(btnX + btnW + 8 , btnY , 120.0, self.titleList.count*_cellHeight);
            
            [self allHevShowWithImageName:@"right" initFrame:startFrame EndFrame:endFrame];
        
        }
            
            break;
            
        default:
            break;
    }
    
    
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self close];
}
- (void)allHevShowWithImageName:(NSString *)imageName initFrame:(CGRect)frame EndFrame:(CGRect)endFrame {
    
    self.bgImageView.image = [UIImage imageNamed:imageName];
    
    self.bgImageView.frame = frame;
    
    if (self.titleList.count > 5) {
        
        [UIView animateWithDuration:0.15 animations:^{

            
            self.bgImageView.frame = CGRectMake(endFrame.origin.x, endFrame.origin.y, endFrame.size.width, 5*_cellHeight);
            
            self.bgImageView.alpha = 1;
            self.tableView.frame = CGRectMake(0, 0, 120.0 - 10, self.bgImageView.frame.size.height);
        }];
    } else {
        
        [UIView animateWithDuration:0.15 animations:^{
            
            self.bgImageView.frame = endFrame;
            self.tableView.frame = CGRectMake(0, 0, 120.0 - 10, self.bgImageView.frame.size.height);
            self.bgImageView.alpha = 1;
        }];
        
        
    }

    
    
}


- (void)allVerShowWithImageName:(NSString *)imageName initTabelViewStartFrame:(CGRect)frame TabelViewEndFrame:(CGRect)endFrame bgStartFrame:(CGRect)bgStartFrame bgEndFrame:(CGRect)bgEndFrame flag:(NSInteger)flag{
    
    self.bgImageView.image = [UIImage imageNamed:imageName];
    
    self.bgImageView.frame = bgStartFrame;
    
    self.tableView.frame = frame;
    if (self.titleList.count > 5) {
        
        [UIView animateWithDuration:0.15 animations:^{
            
            flag == 1 ?(self.bgImageView.frame = CGRectMake(bgEndFrame.origin.x, self.BtnPressedFrame.origin.y - _cellHeight*5 - 18, bgEndFrame.size.width, _cellHeight*5+10)):(self.bgImageView.frame = CGRectMake(bgEndFrame.origin.x, bgEndFrame.origin.y, bgEndFrame.size.width, _cellHeight*5+10));
            
            self.tableView.frame = CGRectMake(0, endFrame.origin.y, 120.0, self.bgImageView.frame.size.height - 10 );
            self.bgImageView.alpha = 1;
        }];
    } else {
        
        [UIView animateWithDuration:0.15 animations:^{
            
            self.bgImageView.frame = bgEndFrame;
            self.tableView.frame = CGRectMake(0, endFrame.origin.y, 120.0, self.bgImageView.frame.size.height - 10);
            self.bgImageView.alpha = 1;
        }];
        
        
    }
    
    
    
    

    
}



- (void)addTapGesture {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    [self.bgView addGestureRecognizer:tap];
    
}

- (void)close {
    
    
    CGFloat btnX = self.BtnPressedFrame.origin.x;
    CGFloat btnY = self.BtnPressedFrame.origin.y;
    CGFloat btnW = self.BtnPressedFrame.size.width;
    CGFloat btnH = self.BtnPressedFrame.size.height;
    
    
    switch (self.direction) {
        case TJDirectionTypeTop:
        {
            
            [self allcloseWithFrame:CGRectMake(btnX , btnY - 8, 1, 1)];
            break;
        }
        
        case TJDirectionTypeBottom:
        {
            
            [self allcloseWithFrame:CGRectMake(btnX + btnW, btnY + btnH + 8, 1, 1)];
            break;
        }
            
            
            
       
        case TJDirectionTypeLeft:
        {
        
            [self allcloseWithFrame:CGRectMake(btnX - 8 , btnY, 1, 1)];
             break;
        }
            
           
            
        
        case TJDirectionTypeRight:
        {
            
            [self allcloseWithFrame:CGRectMake(btnX + btnW + 8 , btnY, 1, 1)];
            break;
        }
            
            
        default:
            break;
    }

}




- (void)allcloseWithFrame:(CGRect)frame {

    if (_bgView) {
        
        [UIView animateWithDuration:0.15 animations:^{
            
            self.bgImageView.frame = frame;
            self.tableView.frame = CGRectMake(0, 0, 1, 1);
            
            self.alpha = 0;
            
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
        
        
    }
    
    
}



- (void)createWindowBySelf {

    UIView *view = [[UIView alloc] initWithFrame:TJRectFullScreen];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.1;
    self.bgView = view;
    
    [self addSubview:view];
    
    
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_block) {
        _block(indexPath.row);
    }
    
    
    [self close];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.titleList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TJDropDownCellModel *model = self.dropDownMenuModel[indexPath.row];
    
    TJDropDownMenuCell *cell = [TJDropDownMenuCell cellWithTableView:tableView];
    
    cell.dropDownModel = model;
    
    
    return cell;
}



@end

//
//  TJTeamCardVC.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/11.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJTeamCardVC.h"

#import "HMScannerController.h"

#import "TJAccount.h"

@interface TJTeamCardVC ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameView;
@property (weak, nonatomic) IBOutlet UIImageView *QRimageView;

@end

@implementation TJTeamCardVC

- (void)setTeam:(NIMTeam *)team{
    _team = team;
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSString* key = [manager cacheKeyForURL:[NSURL URLWithString:_team.avatarUrl]];
    SDImageCache* cache = [SDImageCache sharedImageCache];
    //此方法会先从memory中取。
    UIImage *image = [cache imageFromDiskCacheForKey:key];
    
    if (!image) {
        image = [UIImage imageNamed:@"myicon_team"];
    }
    
    [HMScannerController cardImageWithCardName:[NSString stringWithFormat:@"tuijiteam:%@:%@",TJAccountCurrent.userId, _team.teamId]
                                        avatar:image
                                         scale:0.2
                                    completion:^(UIImage *image) {
                                        
                                        _iconView.layer.cornerRadius = 8;
                                        _iconView.layer.masksToBounds = YES;
                                        
                                        [_iconView sd_setImageWithURL:[NSURL URLWithString:_team.avatarUrl] placeholderImage:[UIImage imageNamed:@"myicon_team"]];
                                        [_nickNameView setText:_team.teamName];
                                        [_QRimageView setImage:image];
                                    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = TJColorGrayBg;
    self.iconView.layer.cornerRadius = 7;
    
    [self setUpNavgationBar];
}

+(instancetype)teamCardVC
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TJChat" bundle:nil];
    
    TJTeamCardVC *teamCardVC = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([TJTeamCardVC class])];
    
    return teamCardVC;
}

/**
 *  设置导航条内容
 */
- (void)setUpNavgationBar
{
    UIView *titleView = [TJUICreator createTitleViewWithSize:CGSizeMake(100, 23)
                                                        text:@"群二维码"
                                                   textColor:TJColorBlackFont
                                                 sysFontSize:18];
    self.navigationItem.titleView = titleView;
}


@end

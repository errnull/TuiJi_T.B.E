//
//  TJSquarePreviewVC.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/2.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJSquarePreviewVC.h"

#import "STPopup.h"

#import "TJSquareNews.h"

#import "BLImageSize.h"

@interface TJSquarePreviewVC ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation TJSquarePreviewVC

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    
    return self;
}

- (void)setSquareNews:(TJSquareNews *)squareNews{
    _squareNews = squareNews;
    
    CGFloat viewW = TJWidthDevice - 28;
    
    CGSize imageSize = [BLImageSize downloadImageSizeWithURL:_squareNews.imageUrl];
    
    CGFloat viewH = viewW * (imageSize.height / imageSize.width) + 52;
    
    self.contentSizeInPopup = CGSizeMake(viewW, viewH);
    
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.popupController.navigationBarHidden = YES;
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:_squareNews.userIcon]];
    
    [_nameView setText:_squareNews.username];
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_squareNews.imageUrl]];
    
    _iconView.layer.cornerRadius = 6;
    _iconView.layer.masksToBounds = YES;
}


@end

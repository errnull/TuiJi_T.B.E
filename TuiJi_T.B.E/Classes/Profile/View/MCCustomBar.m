//
//  MCCustomBar.m
//  简书userCenter
//
//  Created by 周陆洲 on 16/4/19.
//  Copyright © 2016年 MuChen. All rights reserved.
//

#import "MCCustomBar.h"
#define ItemNorTintColor TJColorWithAlpha(160, 160, 160, 1)

@implementation MCCustomBar{
    NSString *_imageName;
    NSString *_selectedImageName;
    
}

- (instancetype) initWithCount:(NSString *)count size:(CGSize)size andImageName :(NSString *)imageName selectedImageName:(NSString *)selectedImageName;{
    self = [super init];
    if (self) {
        _imageName = imageName;
        _selectedImageName = selectedImageName;
        [self createControlWithCount:count size:size andImageName:imageName selectedImageName:selectedImageName];
    }
    return self;
}

- (void)setSelected:(BOOL)selected{
    if (selected) {
        [_imageView setImage:[UIImage imageNamed:_selectedImageName]];
    }else{
        [_imageView setImage:[UIImage imageNamed:_imageName]];
    }
}


//创建item
- (void)createControlWithCount:(NSString *)count size:(CGSize)size andImageName :(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    
    [self setSize:size];
    
//    //数量
//    _countLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, 15)];
//    _countLabel.textAlignment = NSTextAlignmentCenter;
//    _countLabel.adjustsFontSizeToFitWidth = YES;
//    _countLabel.font = [UIFont systemFontOfSize:14];
//    //    [countLabel sizeToFit];
//    _countLabel.text = count;
//    [self addSubview:_countLabel];
    
//    //标题
//    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
//    _nameLabel.textAlignment = NSTextAlignmentCenter;
//    _nameLabel.text = name;
//    _nameLabel.font = [UIFont systemFontOfSize:16];
//    
////    _countLabel.textColor = ItemNorTintColor;
//    _nameLabel.textColor = ItemNorTintColor;
//    
//    [self addSubview:_nameLabel];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:TJRectFromSize(TJAutoSizeMake(self.height*0.6, self.height*0.6))];
    
    imageView.image = [UIImage imageNamed:imageName];
    
    _imageView = imageView;
    
    [TJAutoLayoutor layView:_imageView atCenterOfTheView:self offset:CGSizeZero];
    
}




@end

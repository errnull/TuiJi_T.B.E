//
//  TJPublicTextTuiJiVC.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/9/11.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJPublicTextTuiJiVC : UIViewController

+ (instancetype)PublicTextVCWithShowImage:(UIImage *)showImage;


/**
 *  当前位置
 */
@property (nonatomic ,copy) NSString *currentLocationName;

/**
 *  推文图片集合
 */
@property (nonatomic ,strong) NSMutableArray *timeLineImageList;

/**
 *  推文视频
 */
@property (nonatomic, strong) NSData *videoData;

/**
 *  展示图片
 */
@property (nonatomic ,strong) UIImage *showImage;

@property (nonatomic, strong) NSMutableArray *aitFriendList;
@property (nonatomic, strong) NSMutableArray *readLimitList;
@end

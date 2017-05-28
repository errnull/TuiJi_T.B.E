//
//  GJGCChatFriendContentTypeLocationCell.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/24.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "GJGCChatFriendBaseCell.h"

@interface GJGCChatFriendContentTypeLocationCell : GJGCChatFriendBaseCell


@property (nonatomic,copy)NSString *imgUrl;

@property (nonatomic,strong)UIImageView *contentImageView;

@property (nonatomic,strong)UIImageView *blankImageView;

@property (nonatomic,strong)GJCUProgressView *progressView;

@property (nonatomic,assign)CGFloat downloadProgress;

- (void)resetState;

- (void)resetStateWithPrepareSize:(CGSize)pSize;

- (void)removePrepareState;

- (void)faildState;

- (void)successDownloadWithImageData:(NSData *)imageData;

@end

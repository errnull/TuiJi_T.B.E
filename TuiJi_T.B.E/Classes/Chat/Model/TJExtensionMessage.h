//
//  TJExtensionMessage.h
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/11/18.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TJExtensionMessageDefine.h"

typedef NS_ENUM(NSInteger, TJExtensionMessageValue) {
    TJExtensionMessageValueGuess          = 1,//--
    TJExtensionMessageValueSnapChat       = 2,//--
    TJExtensionMessageValueSticker        = 3,//--
    TJExtensionMessageValueRTS            = 4,//--
    TJExtensionMessageValueCard           = 5,//转名片
    TJExtensionMessageValueTweet          = 6,//转推文
};

@interface TJExtensionMessage : NSObject<NIMCustomAttachment>

@property (nonatomic,strong) NSDictionary *value;
@property (nonatomic ,assign) NSInteger type;

@end

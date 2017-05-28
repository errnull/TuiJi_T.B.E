//
//  NIMSessionMsgDatasource.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/8/26.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIMKitMessageProvider.h"
#import "NIMSessionConfig.h"

@protocol NIMSessionMsgDatasourceDelegate <NSObject>

- (void)messageDataIsReady;

@end

@interface NIMSessionMsgDatasource : NSObject

@property (nonatomic, strong) NSMutableArray      *modelArray;
@property (nonatomic, readonly) NSInteger         messageLimit;                //每页消息显示条数
@property (nonatomic, readonly) NSInteger         showTimeInterval;            //两条消息相隔多久显示一条时间戳
@property (nonatomic, weak) id<NIMSessionMsgDatasourceDelegate> delegate;
@property (nonatomic, weak) id<NIMSessionConfig> sessionConfig;


@property (nonatomic, strong, readonly) NIMSession *session;

- (instancetype)initWithSession:(NIMSession*)session
                   dataProvider:(id<NIMKitMessageProvider>)dataProvider
               showTimeInterval:(NSTimeInterval)timeInterval
                          limit:(NSInteger)limit;

//复位消息
- (void)resetMessages:(void(^)(NSError *error)) handler;

//清理缓存数据
- (void)cleanCache;

- (NSString *)sessionTitle;
@end

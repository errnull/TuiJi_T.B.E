//
//  TJURLList.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/7/27.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJURLList : NSObject

/**
 *  初始化APP数据
 */
@property (nonatomic ,copy) NSString *loadBaseUserInfo;

/**
 *  获取短信验证码 接口
 */
@property (nonatomic ,copy) NSString *getMessageCode;

/**
 *  注册接口
 */
@property (nonatomic ,copy) NSString *signUp;

/**
 *  登陆接口
 */
@property (nonatomic ,copy) NSString *signIn;

/**
 *  修改用户信息
 */
@property (nonatomic ,copy) NSString *modifyUserInfo;

/**
 *  上传用户资源
 */
@property (nonatomic ,copy) NSString *resourceUpLoad;

/**
 *  通过用户手机或者推己号获取个人资料
 */
@property (nonatomic ,copy) NSString *getUserInfoWithNumber;

/**
 *  发送好友请求
 */
@property (nonatomic ,copy) NSString *sendAddFriendRequest;

/**
 *  获取用户所有好友列表
 */
@property (nonatomic ,copy) NSString *loadAllContactOfUser;

/**
 *  获取用户所有群聊列表
 */
@property (nonatomic ,copy) NSString *loadAllGroupContactOfUser;

/**
 *  获取所有好友请求列表
 */
@property (nonatomic ,copy) NSString *getAllNewContactRequest;

/**
 *  回复好友请求
 */
@property (nonatomic ,copy) NSString *reciveNewContactRequest;

/**
 *  初始化全球数据
 */
@property (nonatomic ,copy) NSString *loadGlobalNews;

/**
 *  加载更多新数据(下拉刷新)
 */
@property (nonatomic ,copy) NSString *loadMoreGlobalNews;

/**
 *  加载更旧的数据(上拉刷新)
 */
@property (nonatomic ,copy) NSString *loadOldGlobalNews;

/**
 *  查询最新12条推文
 */
@property (nonatomic ,copy) NSString *loadSquareNews;

/**
 *  查询某推文前面12条数据
 */
@property (nonatomic ,copy) NSString *loadNewSquareNews;

/**
 *  查询某推文后面12条数据
 */
@property (nonatomic ,copy) NSString *loadOldSquareNews;

/**
 *  加载推己圈数据
 */
@property (nonatomic ,copy) NSString *loadNewTimeLine;

/**
 *  发布推己圈
 */
@property (nonatomic ,copy) NSString *publicTimeLine;

/**
 *  点赞或者取消
 */
@property (nonatomic ,copy) NSString *userLikeTimeLine;

/**
 *  加载全球详细新闻页面
 */
@property (nonatomic ,copy) NSString *loadGlobalDetail;

/**
 *  收藏广场
 */
@property (nonatomic ,copy) NSString *collectSquareNews;

/**
 *  收藏推文
 */
@property (nonatomic ,copy) NSString *collectTuiTimeLine;

/**
 *  获取七牛上传凭证接口
 */
@property (nonatomic ,copy) NSString *getUploadToken;

/**
 *  修改用户扩展字段
 */
@property (nonatomic ,copy) NSString *setUserEXT;

/**
 *  获取用户扩展字段
 */
@property (nonatomic ,copy) NSString *getUserEXT;

/**
 *  修改好友备注
 */
@property (nonatomic ,copy) NSString *setFriendRemark;

/**
 *  删除好友
 */
@property (nonatomic ,copy) NSString *deleteAFriend;

/**
 *  获取推文评论
 */
@property (nonatomic ,copy) NSString *loadTimeLineComment;

/**
 *  评论推己圈
 */
@property (nonatomic ,copy) NSString *commentATimeLine;

/**
 *  获取广场评论
 */
@property (nonatomic ,copy) NSString *loadSquareComment;

/**
 *  评论广场
 */
@property (nonatomic ,copy) NSString *commentASquareNews;

/**
 *  转发到推己圈
 */
@property (nonatomic ,copy) NSString *transmitToTimeLine;

/**
 *  通过推文id查询推文内容
 */
@property (nonatomic ,copy) NSString *getSquareNewsWithID;

/**
 *  加载用户收藏
 */
@property (nonatomic ,copy) NSString *loadUserCollectionList;

/**
 *  删除推己圈
 */
@property (nonatomic ,copy) NSString *deleteATimeLine;

/**
 *  加载最新的带图推文
 */
@property (nonatomic ,copy) NSString *loadNewImageTimeLine;

/**
 *  获取关注列表
 */
@property (nonatomic ,copy) NSString *loadAllMyAttention;

/**
 *  关注某个人
 */
@property (nonatomic ,copy) NSString *payAttentionTo;

/**
 *  取消关注某个人
 */
@property (nonatomic ,copy) NSString *unPayAttentionTo;

/**
 *  获取用户所有粉丝
 */
@property (nonatomic ,copy) NSString *loadAllMyFans;
@end

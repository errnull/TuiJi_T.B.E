//
//  GJGCChatInputExpandMenuPanelDataSource.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 14-10-28.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJGCChatInputExpandMenuPanelDataSource.h"


/**
 *  重要提示
 *
 *  新增扩展面板功能的时候在GJGCChatInputConst.h增加一个新的动作类型
 *  然后在这里创建一个Item绑定新增加的动作类型
 */

@implementation GJGCChatInputExpandMenuPanelDataSource

+ (NSArray *)menuItemDataSourceWithConfigModel:(GJGCChatInputExpandMenuPanelConfigModel *)configModel
{
    return [GJGCChatInputExpandMenuPanelDataSource menuPanelDataSource];
}

+ (NSArray *)postPanelDataSource
{
    NSMutableArray *dataSource = [NSMutableArray array];
    
//    [dataSource addObject:[GJGCChatInputExpandMenuPanelDataSource cameraMenuPanelItem]];
//    
//    [dataSource addObject:[GJGCChatInputExpandMenuPanelDataSource photoLibraryMenuPanelItem]];
//    
//    [dataSource addObject:[GJGCChatInputExpandMenuPanelDataSource myFavoritePostMenuPanelItem]];
    
    return dataSource;
}

+ (NSArray *)groupPanelDataSource
{
    NSMutableArray *dataSource = [NSMutableArray array];
    
//    [dataSource addObject:[GJGCChatInputExpandMenuPanelDataSource cameraMenuPanelItem]];
//    
//    [dataSource addObject:[GJGCChatInputExpandMenuPanelDataSource photoLibraryMenuPanelItem]];
    
    return dataSource;
}

+ (NSArray *)menuPanelDataSource
{
    NSMutableArray *dataSource = [NSMutableArray array];
    
    [dataSource addObject:[GJGCChatInputExpandMenuPanelDataSource PhotoLibraryMenuPanelItem]];
    
    [dataSource addObject:[GJGCChatInputExpandMenuPanelDataSource CameraMenuPanelItem]];
    
    [dataSource addObject:[GJGCChatInputExpandMenuPanelDataSource SmallVideoMenuPanelItem]];
    
    [dataSource addObject:[GJGCChatInputExpandMenuPanelDataSource ChatVideoMenuPanelItem]];
    
//    [dataSource addObject:[GJGCChatInputExpandMenuPanelDataSource GhostMenuPanelItem]];
    
    [dataSource addObject:[GJGCChatInputExpandMenuPanelDataSource PersonalCardMenuPanelItem]];

    [dataSource addObject:[GJGCChatInputExpandMenuPanelDataSource LocationMenuPanelItem]];

    [dataSource addObject:[GJGCChatInputExpandMenuPanelDataSource CollectionMenuPanelItem]];

    return dataSource;
}

+ (NSDictionary *)PhotoLibraryMenuPanelItem
{
    return @{
             GJGCChatInputExpandMenuPanelDataSourceTitleKey:@"照片",
             
             GJGCChatInputExpandMenuPanelDataSourceIconNormalKey:@"chat_photoLibrary",
             
             GJGCChatInputExpandMenuPanelDataSourceIconHighlightKey:@"chat_photoLibrary_h",

             GJGCChatInputExpandMenuPanelDataSourceActionTypeKey:@(GJGCChatInputMenuPanelActionTypePhotoLibrary)
             
             };
}

+ (NSDictionary *)CameraMenuPanelItem
{
    return @{
             
             GJGCChatInputExpandMenuPanelDataSourceTitleKey:@"拍摄",
             
             GJGCChatInputExpandMenuPanelDataSourceIconNormalKey:@"chat_camera",
             
             GJGCChatInputExpandMenuPanelDataSourceIconHighlightKey:@"chat_camera_h",
             
             GJGCChatInputExpandMenuPanelDataSourceActionTypeKey:@(GJGCChatInputMenuPanelActionTypeCamera)
             
             };
}

+ (NSDictionary *)SmallVideoMenuPanelItem
{
    return @{
             
             GJGCChatInputExpandMenuPanelDataSourceTitleKey:@"小视频",
             
             GJGCChatInputExpandMenuPanelDataSourceIconNormalKey:@"chat_smallVideo",
             
             GJGCChatInputExpandMenuPanelDataSourceIconHighlightKey:@"chat_smallVideo_h",
             
             GJGCChatInputExpandMenuPanelDataSourceActionTypeKey:@(GJGCChatInputMenuPanelActionTypeSmallVideo)
             
             };
}

+ (NSDictionary *)ChatVideoMenuPanelItem
{
    return @{
             
             GJGCChatInputExpandMenuPanelDataSourceTitleKey:@"视频聊天",
             
             GJGCChatInputExpandMenuPanelDataSourceIconNormalKey:@"chat_chatVideo",
             
             GJGCChatInputExpandMenuPanelDataSourceIconHighlightKey:@"chat_chatVideo",
             
             GJGCChatInputExpandMenuPanelDataSourceActionTypeKey:@(GJGCChatInputMenuPanelActionTypeChatVideo)
             
             };
}

+ (NSDictionary *)GhostMenuPanelItem
{
    return @{
             
             GJGCChatInputExpandMenuPanelDataSourceTitleKey:@"幽灵",
             
             GJGCChatInputExpandMenuPanelDataSourceIconNormalKey:@"chat_ghost",
             
             GJGCChatInputExpandMenuPanelDataSourceIconHighlightKey:@"chat_ghost_h",
             
             GJGCChatInputExpandMenuPanelDataSourceActionTypeKey:@(GJGCChatInputMenuPanelActionTypeGhost)
             
             };
}

+ (NSDictionary *)PersonalCardMenuPanelItem
{
    return @{
             
             GJGCChatInputExpandMenuPanelDataSourceTitleKey:@"个人名片",
             
             GJGCChatInputExpandMenuPanelDataSourceIconNormalKey:@"chat_personalCard",
             
             GJGCChatInputExpandMenuPanelDataSourceIconHighlightKey:@"chat_personalCard_h",
             
             GJGCChatInputExpandMenuPanelDataSourceActionTypeKey:@(GJGCChatInputMenuPanelActionTypePersonalCard)
             
             };
}

+ (NSDictionary *)LocationMenuPanelItem
{
    return @{
             
             GJGCChatInputExpandMenuPanelDataSourceTitleKey:@"定位",
             
             GJGCChatInputExpandMenuPanelDataSourceIconNormalKey:@"chat_location",
             
             GJGCChatInputExpandMenuPanelDataSourceIconHighlightKey:@"chat_location_h",
             
             GJGCChatInputExpandMenuPanelDataSourceActionTypeKey:@(GJGCChatInputMenuPanelActionTypeLocation)
             
             };
}

+ (NSDictionary *)CollectionMenuPanelItem
{
    return @{
             
             GJGCChatInputExpandMenuPanelDataSourceTitleKey:@"收藏",
             
             GJGCChatInputExpandMenuPanelDataSourceIconNormalKey:@"chat_collectionchat",
             
             GJGCChatInputExpandMenuPanelDataSourceIconHighlightKey:@"chat_collectionchat_h",
             
             GJGCChatInputExpandMenuPanelDataSourceActionTypeKey:@(GJGCChatInputMenuPanelActionTypeCollection)
             
             };
}



@end

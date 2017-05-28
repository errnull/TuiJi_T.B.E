//
//  GJGCChatInputConst.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 14-10-28.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJGCChatInputConst.h"

NSString *const GJGCChatInputTextViewRecordSoundMeterNoti = @"GJGCChatInputTextViewRecordSoundMeterNoti";

NSString *const GJGCChatInputTextViewRecordTooShortNoti = @"GJGCChatInputTextViewRecordTooShortNoti";

NSString *const GJGCChatInputTextViewRecordTooLongNoti = @"GJGCChatInputTextViewRecordTooLongNoti";

NSString *const GJGCChatInputExpandEmojiPanelChooseEmojiNoti = @"GJGCChatInputExpandEmojiPanelChooseEmojiNoti";

NSString *const GJGCChatInputExpandEmojiPanelChooseDeleteNoti = @"GJGcChatInputExpandEmojiPanelChooseDeleteNoti";

NSString *const GJGCChatInputExpandEmojiPanelChooseSendNoti = @"GJGcChatInputExpandEmojiPanelChooseSendNoti";

NSString *const GJGCChatInputSetLastMessageDraftNoti = @"GJGCChatInputSetLastMessageDraftNoti";

NSString *const GJGCChatInputPanelBeginRecordNoti = @"GJGCChatInputPanelBeginRecordNoti";

NSString *const GJGCChatInputPanelNeedAppendTextNoti = @"GJGCChatInputPanelNeedAppendTextNoti";

NSString *const GJGCChatInputExpandEmojiPanelChooseGIFEmojiNoti = @"GJGCChatInputExpandEmojiPanelChooseGIFEmojiNoti";

@implementation GJGCChatInputConst

+ (NSString *)panelNoti:(NSString *)notiName formateWithIdentifier:(NSString *)identifier
{
    if (TJStringIsNull(notiName)) {
        return nil;
    }
    
    if (TJStringIsNull(identifier)) {
        return nil;
    }
    
    return [NSString stringWithFormat:@"%@_%@",notiName,identifier];
}

@end

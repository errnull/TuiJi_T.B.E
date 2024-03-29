//
//  GJGCChatFirendCellStyle.m
//  ZYChat
//
//  Created by ZYVincent on 14-11-10.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJGCChatFriendCellStyle.h"
#import "GJGCChatContentEmojiParser.h"

@implementation GJGCChatFriendCellStyle

+ (NSString *)imageTag
{
    return @"imageTag";
}

+ (NSDictionary *)formateSimpleTextMessage:(NSString *)messageText
{
    if (TJStringIsNull(messageText)) {
        return nil;
    }
    
    return [GJGCChatContentEmojiParser parseContent:messageText];
}

+ (NSAttributedString *)formateAudioDuration:(NSString *)duration
{
    if (TJStringIsNull(duration)) {
        return nil;
    }
    
    NSString *durationFormate = [NSString stringWithFormat:@"%@\"",duration];
    
    GJCFCoreTextAttributedStringStyle *stringStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
    stringStyle.foregroundColor = [GJGCCommonFontColorStyle baseAndTitleAssociateTextColor];
    stringStyle.font = [GJGCCommonFontColorStyle listTitleAndDetailTextFont];
    
    return [[NSAttributedString alloc]initWithString:durationFormate attributes:[stringStyle attributedDictionary]];
}

/* 灰度消息提醒 */
+ (NSAttributedString *)formateMinMessage:(NSString *)msg
{
    if (TJStringIsNull(msg)) {
        return nil;
    }
    GJCFCoreTextAttributedStringStyle *stringStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
    stringStyle.foregroundColor = GJCFQuickHexColor(@"999999");
    stringStyle.font = [GJGCCommonFontColorStyle baseAndTitleAssociateTextFont];
    
    GJCFCoreTextParagraphStyle *paragraphStyle = [[GJCFCoreTextParagraphStyle alloc]init];
    paragraphStyle.alignment = kCTTextAlignmentCenter;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:msg attributes:[stringStyle attributedDictionary]];
    
    [attributedString addAttributes:[paragraphStyle paragraphAttributedDictionary] range:NSMakeRange(0, msg.length)];
    
    return attributedString;
}

+ (NSAttributedString *)formateGroupChatSenderName:(NSString *)senderName
{
    if (TJStringIsNull(senderName)) {
        return nil;
    }
    GJCFCoreTextAttributedStringStyle *stringStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
    stringStyle.foregroundColor = [GJGCCommonFontColorStyle baseAndTitleAssociateTextColor];
    stringStyle.font = [GJGCCommonFontColorStyle baseAndTitleAssociateTextFont];

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:senderName attributes:[stringStyle attributedDictionary]];

    return attributedString;
}

+ (NSAttributedString *)formatePostTitle:(NSString *)postTitle
{
    if (TJStringIsNull(postTitle)) {
        return nil;
    }
    GJCFCoreTextAttributedStringStyle *stringStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
    stringStyle.foregroundColor = [GJGCCommonFontColorStyle detailBigTitleColor];
    stringStyle.font = [GJGCCommonFontColorStyle detailBigTitleFont];
    
    GJCFCoreTextParagraphStyle *paragraphStyle = [[GJCFCoreTextParagraphStyle alloc]init];
    paragraphStyle.maxLineSpace = 4;
    paragraphStyle.minLineSpace = 4;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:postTitle attributes:[stringStyle attributedDictionary]];
    
    [attributedString addAttributes:[paragraphStyle paragraphAttributedDictionary] range:NSMakeRange(0, postTitle.length)];

    return attributedString;
}

//新人欢迎card 样式

+ (NSAttributedString *)formateTitleString:(NSString *)title
{
    if (TJStringIsNull(title)) {
        return nil;
    }
    NSDictionary *stringAttributedDict = [[GJGCChatFriendCellStyle nameLabelStyle] attributedDictionary];

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:title attributes:stringAttributedDict];

    return attributedString;
}

/* 名字标签风格 */
+ (NSAttributedString *)formateYoungWomenNameString:(NSString *)name
{
    if (TJStringIsNull(name)) {
        return nil;
    }
    
    GJCFCoreTextAttributedStringStyle *stringStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
    stringStyle.font = [GJGCCommonFontColorStyle detailBigTitleFont];
    stringStyle.foregroundColor = [UIColor whiteColor];
    
    NSDictionary *stringAttributedDict = [stringStyle attributedDictionary];
    NSDictionary *paragraphDict = [[GJGCChatFriendCellStyle nameLabelParagraphStyle] paragraphAttributedDictionary];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:name attributes:stringAttributedDict];
    [attributedString addAttributes:paragraphDict range:NSMakeRange(0, name.length)];
    
    return attributedString;
}

+ (NSAttributedString *)formateNameString:(NSString *)name
{
    if (TJStringIsNull(name)) {
        return nil;
    }
    
    GJCFCoreTextAttributedStringStyle *stringStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
    stringStyle.font = [GJGCCommonFontColorStyle detailBigTitleFont];
    stringStyle.foregroundColor = [GJGCCommonFontColorStyle detailBigTitleColor];
    
    NSDictionary *stringAttributedDict = [stringStyle attributedDictionary];
    NSDictionary *paragraphDict = [[GJGCChatFriendCellStyle nameLabelParagraphStyle] paragraphAttributedDictionary];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:name attributes:stringAttributedDict];
    [attributedString addAttributes:paragraphDict range:NSMakeRange(0, name.length)];
    
    return attributedString;
}

/* 男年龄标签 */
+ (NSAttributedString *)formateManAge:(NSString *)manAge
{
    if (TJStringIsNull(manAge)) {
        return nil;
    }
    NSDictionary *attributedDict = [[GJGCChatFriendCellStyle roleManAgeLabelStyle] attributedDictionary];
    return [[NSAttributedString alloc]initWithString:manAge attributes:attributedDict];
}

/* 女年龄标签 */
+ (NSAttributedString *)formateWomenAge:(NSString *)womenAge
{
    if (TJStringIsNull(womenAge)) {
        return nil;
    }
    NSDictionary *attributedDict = [[GJGCChatFriendCellStyle roleWomenAgeLabelStyle] attributedDictionary];
    return [[NSAttributedString alloc]initWithString:womenAge attributes:attributedDict];
}

/* 星座标签 */
+ (NSAttributedString *)formateStarName:(NSString *)starName
{
    if (TJStringIsNull(starName)) {
        return nil;
    }
    NSDictionary *attributedDict = [[GJGCChatFriendCellStyle roleStarNameLabelStyle] attributedDictionary];
    return [[NSAttributedString alloc]initWithString:starName attributes:attributedDict];
}

/* 名字标签风格 */
+ (GJCFCoreTextAttributedStringStyle *)nameLabelStyle
{
    GJCFCoreTextAttributedStringStyle *stringStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
    stringStyle.font = [GJGCCommonFontColorStyle detailBigTitleFont];
    stringStyle.foregroundColor = [GJGCCommonFontColorStyle detailBigTitleColor];
    
    
    return stringStyle;
}

/* 名字标签换行属性 */
+ (GJCFCoreTextParagraphStyle *)nameLabelParagraphStyle
{
    GJCFCoreTextParagraphStyle *paragraphStyle = [[GJCFCoreTextParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = kCTLineBreakByTruncatingTail;
    
    return paragraphStyle;
}

/* 男年龄标签 */
+ (GJCFCoreTextAttributedStringStyle *)roleManAgeLabelStyle
{
    GJCFCoreTextAttributedStringStyle *stringStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
    stringStyle.foregroundColor = GJCFQuickHexColor(@"7ecef4");
    stringStyle.font = [GJGCCommonFontColorStyle listTitleAndDetailTextFont];
    
    return stringStyle;
}

/* 女年龄标签 */
+ (GJCFCoreTextAttributedStringStyle *)roleWomenAgeLabelStyle
{
    GJCFCoreTextAttributedStringStyle *stringStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
    stringStyle.foregroundColor = GJCFQuickHexColor(@"ffa9c5");
    stringStyle.font = [GJGCCommonFontColorStyle listTitleAndDetailTextFont];
    
    return stringStyle;
}

/* 星座标签 */
+ (GJCFCoreTextAttributedStringStyle *)roleStarNameLabelStyle
{
    GJCFCoreTextAttributedStringStyle *stringStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
    stringStyle.foregroundColor = [GJGCCommonFontColorStyle baseAndTitleAssociateTextColor];
    stringStyle.font = [GJGCCommonFontColorStyle listTitleAndDetailTextFont];
    
    return stringStyle;
}

/* 群主召唤card样式 */

+ (NSAttributedString *)formateGroupCallTitle:(NSString *)title
{
    GJCFCoreTextAttributedStringStyle *stringStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
    stringStyle.font = [GJGCCommonFontColorStyle detailBigTitleFont];
    stringStyle.foregroundColor = [UIColor whiteColor];

    return [[NSAttributedString alloc]initWithString:title attributes:[stringStyle attributedDictionary]];
}

+ (NSAttributedString *)formateGroupCallContent:(NSString *)content
{
    GJCFCoreTextAttributedStringStyle *stringStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
    stringStyle.font = [GJGCCommonFontColorStyle detailBigTitleFont];
    stringStyle.foregroundColor = [GJGCCommonFontColorStyle detailBigTitleColor];
    
    GJCFCoreTextParagraphStyle *paragraphStyle = [[GJCFCoreTextParagraphStyle alloc]init];
    paragraphStyle.maxLineSpace = 3.f;
    paragraphStyle.minLineSpace = 3.f;
    
    NSMutableAttributedString *string =  [[NSMutableAttributedString alloc]initWithString:content attributes:[stringStyle attributedDictionary]];
    
    [string addAttributes:[paragraphStyle paragraphAttributedDictionary] range:TJStringRange(content)];
    
    return string;
}

/* 接受群主召唤card样式 */

+ (NSAttributedString *)formateAcceptGroupCallContent:(NSString *)content
{
    GJCFCoreTextAttributedStringStyle *stringStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
    stringStyle.font = [GJGCCommonFontColorStyle detailBigTitleFont];
    stringStyle.foregroundColor = [UIColor whiteColor];
    
    return [[NSAttributedString alloc]initWithString:content attributes:[stringStyle attributedDictionary]];
}

+ (NSAttributedString *)formateDriftBottleContent:(NSString *)content;
{
    GJCFCoreTextAttributedStringStyle *stringStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
    stringStyle.foregroundColor = [GJGCCommonFontColorStyle detailBigTitleColor];
    stringStyle.font = [UIFont systemFontOfSize:14];
    
    GJCFCoreTextParagraphStyle *paragrpahStyle = [[GJCFCoreTextParagraphStyle alloc]init];
    paragrpahStyle.lineBreakMode = kCTLineBreakByCharWrapping;
    paragrpahStyle.maxLineSpace = 5.f;
    paragrpahStyle.minLineSpace = 5.f;
    
    NSMutableAttributedString *contentAttributedString = [[NSMutableAttributedString alloc]initWithString:content attributes:[stringStyle attributedDictionary]];
    [contentAttributedString addAttributes:[paragrpahStyle paragraphAttributedDictionary] range:NSMakeRange(0, content.length)];
    
    return contentAttributedString;
}

@end

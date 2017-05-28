//
//  TJStringMacrocDefine.h
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-10-16.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

/**
 *  文件描述
 * 
 *  这个工具宏封装了大部分字符串常用的便捷方法
 */

#import "GJCFStringUitil.h"

/**
 *  字符串是否为空
 */
#define TJStringIsNull(string) [GJCFStringUitil stringIsNull:string]

/**
 *  字符串是否全为空格
 */
#define TJStringIsAllWhiteSpace(string) [GJCFStringUitil stringIsAllWhiteSpace:string]

/**
 *  字符串转NSInteger
 */
#define TJStringToInt(string) [GJCFStringUitil stringToInt:string]

/**
 *  字符串转CGFloat
 */
#define TJStringToFloat(string) [GJCFStringUitil stringToFloat:string]

/**
 *  字符串转double
 */
#define TJStringToDouble(string) [GJCFStringUitil stringToDouble:string]

/**
 *  字符串转Bool
 */
#define TJStringToBool(string) [GJCFStringUitil stringToBool:string]

/**
 *  int转字符串
 */
#define TJStringFromInt(int) [GJCFStringUitil intToString:int]

/**
 *  float转字符串
 */
#define TJStringFromFloat(float) [GJCFStringUitil floatToString:float]

/**
 *  double转字符串
 */
#define TJStringFromDouble(double) [GJCFStringUitil doubleToString:double]

/**
 *  bool转字符串
 */
#define TJStringFromBool(bool) [GJCFStringUitil boolToString:bool]

/**
 *  字符串是否合法邮箱
 */
#define TJStringIsEmail(string) [GJCFStringUitil stringIsValidateEmailAddress:string]

/**
 *  字符串是否合法手机号码
 */
#define TJStringIsMobilePhone(string) [GJCFStringUitil stringISValidateMobilePhone:string]

/**
 *  字符串是否合法url
 */
#define TJStringIsUrl(string) [GJCFStringUitil stringIsValidateUrl:string]

/**
 *  字符串是否合法座机
 */
#define TJStringIsPhone(string) [GJCFStringUitil stringIsValidatePhone:string]

/**
 *  字符串是否合法邮政编码
 */
#define TJStringIsMailCode(string) [GJCFStringUitil stringIsValidateMailCode:string]

/**
 *  字符串是否合法身份证号
 */
#define TJStringIsPersonCardNumber(string) [GJCFStringUitil stringISValidatePersonCardNumber:string]

/**
 *  字符串是否合法车牌号
 */
#define TJStringIsCarNumber(string) [GJCFStringUitil stringISValidateCarNumber:string]

/**
 *  字符串是否只有中文字符
 */
#define TJStringChineseOnly(string) [GJCFStringUitil stringIsAllChineseWord:string]

/**
 *  字符串是否只有英文字符
 */
#define TJStringCharNumOnly(string) [GJCFStringUitil stringJustHasNumberAndCharacter:string]

/**
 *  字符串是否只包含字符，中文，数字
 */
#define TJStringCharNumChineseOnly(string) [GJCFStringUitil stringChineseNumberCharacterOnly:string]

/**
 *  字符串是否纯数字
 */
#define TJStringNumOnly(string) [GJCFStringUitil stringJustHasNumber:string]

/**
 *  从文件中读取出字符串
 */
#define TJStringFromFile(path) [GJCFStringUitil stringFromFile:path]

/**
 *  从归档路径读取出字符串
 */
#define TJStringUnArchieve(path) [GJCFStringUitil unarchieveFromPath:path]

/**
 *  获取一个当前时间戳字符串
 */
#define TJStringCurrentTimeStamp [GJCFStringUitil currentTimeStampString]

/**
 *  将字符串转为MD5字符串
 */
#define TJStringToMD5(string) [GJCFStringUitil MD5:string]

/**
 *  返回去除字符串首的空格的字符串
 */
#define TJStringClearLeadingWhiteSpace(string) [GJCFStringUitil stringByTrimingLeadingWhiteSpace:string]

/**
 *  返回去除字符串结尾的空格的字符串
 */
#define TJStringClearTailingWhiteSpace(string) [GJCFStringUitil stringByTrimingTailingWhiteSpace:string]

/**
 *  返回去除字符串中所有的空格的字符串
 */
#define TJStringClearAllWhiteSpace(string) [GJCFStringUitil stringByTrimingWhiteSpace:string]

/**
 *  Url编码对象,通常是字符串,返回编码后的字符串
 */
#define TJStringEncodeString(string) [GJCFStringUitil urlEncode:string]

/**
 *  Url编码一个字典,键值对用@链接,返回编码后的字符串
 */
#define TJStringEncodeDict(aDict) [GJCFStringUitil encodeStringFromDict:aDict]

/**
 *  返回字符串范围
 */
#define TJStringRange(string) [GJCFStringUitil stringRange:string]




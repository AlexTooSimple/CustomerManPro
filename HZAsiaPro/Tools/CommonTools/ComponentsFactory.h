//
//  ComponentsFactory.h
//  IOSCodeTest
//
//  Created by wuhui on 14-10-20.
//  Copyright (c) 2014年 wuhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ComponentsFactory : NSObject

//自定义RCB 颜色
+ (UIColor*) createColorByHex:(NSString *)hexColor;
/**
 *得到本机现在用的语言
 * en:英文  zh-Hans:简体中文   zh-Hant:繁体中文    ja:日本  ......
 */
+ (NSString*)getPreferredLanguage;
//校验正则表达式
+ (BOOL)RegexCheck:(NSString*)matchStr
          regexStr:(NSString*)regexStr;
//获取设备的MAC 地址
+(NSString *)MacAddress;
//格式化money 格式为###,##0.00
+(NSString *)moneyFormat:(NSString*)moneyString;
//去除空格
+(NSString *)filterSpace:(NSString*) aFilterString;

//时间操作
+(NSString *)getCurrentDateWithFormate:(NSString *)formate;
+(NSString *)getDateString:(NSString *)sourceDate fromSourceFormate:(NSString *)source toDestFormate:(NSString *)dest;
@end

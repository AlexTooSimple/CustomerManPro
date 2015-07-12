//
//  ComponentsFactory.m
//  IOSCodeTest
//
//  Created by wuhui on 14-10-20.
//  Copyright (c) 2014年 wuhui. All rights reserved.
//

#import "ComponentsFactory.h"
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@implementation ComponentsFactory


//自定义RCB 颜色
+ (UIColor*) createColorByHex:(NSString *)hexColor
{
    if (hexColor == nil) {
        return nil;
    }
    
    unsigned int red, green, blue;
    NSRange range;
    range.length = 2;
    
    range.location = 1;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    range.location = 3;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    range.location = 5;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:1.0f];
}

//去除空格
+(NSString*)filterSpace:(NSString*) aFilterString
{
	if (nil != aFilterString) {
		NSMutableString* resultString = [[[NSMutableString alloc] initWithString:aFilterString] autorelease];
		NSUInteger length = [resultString length];
		[resultString replaceOccurrencesOfString:@" "
									  withString:@""
										 options:NSBackwardsSearch
										   range:NSMakeRange(0, length)];
		return resultString;
	}
	
	return nil;
}

//格式化money 格式为###,##0.00
+(NSString*)moneyFormat:(NSString*)moneyString
{
    if(nil != moneyString && moneyString.length > 0){
        NSString* moneyDoubleString = [NSString stringWithString:moneyString];
        double monetDouble = [moneyDoubleString doubleValue];
        
        NSNumberFormatter* numberFormat = [[NSNumberFormatter alloc] init];
        [numberFormat setPositiveFormat:@"###,##0.00"];
        [numberFormat setNegativeFormat:@"###,##0.00"];
        NSNumber* numberDouble = [NSNumber numberWithDouble:monetDouble];
        NSString* moneyFormatterString = [numberFormat stringFromNumber:numberDouble];
        [numberFormat release];
        
        return moneyFormatterString;
    }else{
        return moneyString;
    }
}


/**
 *得到本机现在用的语言
 * en:英文  zh-Hans:简体中文   zh-Hant:繁体中文    ja:日本  ......
 */
+ (NSString*)getPreferredLanguage
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    NSLog(@"Preferred Language:%@", preferredLang);
    return preferredLang;
}

//校验正则表达式
+ (BOOL)RegexCheck:(NSString*)matchStr regexStr:(NSString*)regexStr
{
    if(!matchStr||!regexStr)
        return NO;
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *matches = [regex matchesInString:matchStr
                                      options:0
                                        range:NSMakeRange(0, [matchStr length])];
    return matches && [matches count]>0;
}



//获取设备的MAC 地址
+(NSString *)MacAddress
{
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        if (buf != NULL) {
            free(buf);
        }
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

+(NSString*)getCurrentDateWithFormate:(NSString *)formate
{
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:formate];
    
    NSString *currentDateString = [df stringFromDate:[NSDate date]];
    return currentDateString;
}

+(NSString*)getDateString:(NSString *)sourceDate fromSourceFormate:(NSString *)source toDestFormate:(NSString *)dest
{
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:source];
    NSDate *date = [df dateFromString:sourceDate];
    
    [df setDateFormat:dest];
    NSString *destDate = [df stringFromDate:date];
    
    return destDate;
}

@end

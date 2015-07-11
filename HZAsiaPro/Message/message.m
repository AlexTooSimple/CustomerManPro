//
//  message.m
//  HZAsiaPro
//
//  Created by wuhui on 15-3-12.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "message.h"
#import "XmlMessage.h"
#import "JsonMessage.h"
#import <CommonCrypto/CommonDigest.h>

@implementation message

@synthesize rspCode;
@synthesize rspDesc;
@synthesize rspInfo;
@synthesize requestInfo;
@synthesize isXML;

- (void)dealloc
{
    [rspCode release];
    [rspDesc release];
    [requestInfo release];
    [rspInfo release];
    
    [super dealloc];
}

- (void)parseResponse:(NSString *)responseMessage
{
    
}


- (NSString *)getResponse:(NSData *)responseData
{
    NSString *responseMsg;
#ifdef STATIC_XML
    responseMsg = [[[NSString alloc] initWithData:responseData
                                         encoding:NSUTF8StringEncoding] autorelease];
#else
    //如果需要解密，可以在这里统一解密
    responseMsg = [[[NSString alloc] initWithData:responseData
                                         encoding:NSUTF8StringEncoding] autorelease];;
    //responseStr = [message hexStringDes:responseMessage withEncrypt:NO];
#endif
    
    return responseMsg;
}

#pragma mark
#pragma mark - 解析返回的报文
+(NSString*)getRespondDescription:(NSString*)resCode
{
    NSDictionary* codeAndDes = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"正确",					@"0000",
                                @"用户名不存在",			@"0001",
                                @"密码错误",				@"0002",
                                @"无权限",				@"0003",
                                @"版本过低",				@"0004",
                                @"手机挂失",				@"0005",
                                @"服务器内部错误",			@"0006",
                                @"访问异常",				@"0007",
                                @"业务不存在",		    @"0008",
                                @"SessionID过期",		@"0009",
                                @"数据错误",				@"0010",
                                @"未知错误",				@"9999",
                                @"网络连接错误",			@"8888",
                                @"网络连接超时",			@"5555",
                                @"服务器报文异常",			@"6666",
                                @"可选升级",             @"7777",
                                @"检测版本异常",          @"4444",
                                nil];
    
    NSArray* keys = [codeAndDes allKeys];
    for (NSString* key in keys) {
        if ([key isEqualToString:resCode]) {
            NSString* desc = [NSString stringWithString:[codeAndDes objectForKey:key]];
            return desc;
        }
    }
    
    NSString* desc = [NSString stringWithString:[codeAndDes objectForKey:@"9999"]];
    return desc;
}

+(NSString*)getNetLinkErrorCode{
    return @"8888";
}


+(NSString*)getTimeOutErrorCode{
    return @"5555";
}

- (NSString*)getRspcode
{
    if (isXML) {
        XmlMessage *xmlMessage = (XmlMessage *)self;
        return [xmlMessage getRspcode];
    }else{
        JsonMessage *jsonMessage = (JsonMessage *)self;
        return [jsonMessage getRspcode];
    }
}

- (NSString*)getMSG
{
    if (isXML) {
        XmlMessage *xmlMessage = (XmlMessage *)self;
        return [xmlMessage getMSG];
    }else{
        JsonMessage *jsonMessage = (JsonMessage *)self;
        return [jsonMessage getMSG];
    }
}

#pragma mark
#pragma mark - 加密方法
+(NSString*)md5Encode:(NSString*)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    NSString *string = [NSString stringWithFormat:
                        @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                        result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
                        result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
                        ];
    return [string lowercaseString];
}



@end

//
//  LoginJsonMessage.m
//  HZAsiaPro
//
//  Created by wuhui on 15-3-18.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "LoginJsonMessage.h"
#import <UIKit/UIKit.h>

@implementation LoginJsonMessage

- (NSString*)getRequest
{
    NSDictionary *headerData = [[NSDictionary alloc] initWithObjectsAndKeys:LOGIN_BIZCODE,@"bizCode",nil];
    
    UIDevice* iDevice = [UIDevice currentDevice];
    NSString* model = [iDevice model];
    NSString* udid = [[iDevice identifierForVendor] UUIDString];
    
    
    NSString *sysName = [iDevice systemName];
    NSString *sysVerion = [iDevice systemVersion];
    NSString *sysOS = [[NSString alloc] initWithFormat:@"%@%@",sysName,sysVerion];
    
    NSString* BundleVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    // svc      手机号
    // usercode 登陆账号
    // pwd      密码
    // imsi     imsi号
    // imei     imei号
    // version  客户端版本
    // brand    手机品牌
    // model    手机型号
    // os       手机操作系统
    
    NSString *userName = [requestInfo objectForKey:@"UserName"];
    NSString *pwd = [requestInfo objectForKey:@"PassWd"];
    
    NSString *requestClass = [[NSString alloc] initWithFormat:JSON_BODY_REUEST,[LOGIN_BIZCODE uppercaseString]];
    
    NSDictionary *bodyData = [[NSDictionary alloc] initWithObjectsAndKeys:
                              requestClass,@"@class",
                              USER_SVC,@"svc",
                              userName,@"userName",
                              [message md5Encode:pwd],@"passWd",
                              USER_IMSI,@"imsi",
                              udid,@"imei",
                              BundleVersion,@"clientVersion",
                              USER_BRAND,@"hardwareBrand",
                              sysOS,@"os",
                              model,@"hardwareModel",
                              @"iPhone",@"from",nil];
    [requestClass release];
    [sysOS release];
    
    NSString *requestStr = [self getRequestJSONFromHeader:headerData
                                                 withBody:bodyData];
    [headerData release];
    [bodyData release];
    
    NSLog(@"登录报文:%@",requestStr);
    
    return requestStr;
}


-(void)parseOther
{
    [super parseOther];
    [self parseMessage];
}

- (void)parseResponse:(NSString *)responseMessage
{
    [self parse:responseMessage];
}

-(void)dealloc
{
    [super dealloc];
}

+ (NSString*)getBizCode
{
    return LOGIN_BIZCODE;
}

- (NSString*)getBusinessCode
{
    return LOGIN_BIZCODE;
}

-(void)parseMessage
{
    //需要解析在此处解析
    NSArray *keyArray = [[NSArray alloc] initWithObjects:@"areaId",
                         @"sessionId",
                         @"addressList",nil];
    if (self.rspInfo != nil && [self.rspInfo isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *rInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
        NSInteger cnt = [keyArray count];
        for (int i=0; i<cnt; i++) {
            NSString *keyStr = [keyArray objectAtIndex:i];
            NSString *valueStr = [rspInfo objectForKey:keyStr];
            if (valueStr) {
                [rInfo setObject:valueStr forKey:keyStr];
            }
        }
        if ([rInfo count] > 0) {
            self.rspInfo = rInfo;
        }
        [rInfo release];
    }
    [keyArray release];
    
}

@end

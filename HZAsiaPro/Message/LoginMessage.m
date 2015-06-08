//
//  LoginMessage.m
//  HZAsiaPro
//
//  Created by wuhui on 15-3-13.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "LoginMessage.h"
#import <UIKit/UIKit.h>

@implementation LoginMessage
- (NSString*)getRequest {
    NSString* requestStr = nil;
    
    NSDictionary* headData = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_BIZCODE,@"BizCode",nil];
    
    UIDevice* iDevice = [UIDevice currentDevice];
    NSString* iHardwareModel = [iDevice localizedModel];
    NSString* iUser_udid = [[iDevice identifierForVendor] UUIDString];
    
    NSString* userName = [requestInfo objectForKey:@"UserName"];
    NSString* userPassWd  = [requestInfo objectForKey:@"PassWd"];
    
    NSString* BundleVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    
    NSDictionary *body = nil;
    if (userName != nil
        && ![userName isEqualToString:@""]
        && userPassWd != nil
        && ![userPassWd isEqualToString:@""])
    {
        body  = [[NSDictionary alloc] initWithObjectsAndKeys:
                 userName,@"UserName",
                 [LoginMessage md5Encode:userPassWd],@"PassWd",
                 USER_IMSI,@"IMSI",
                 iUser_udid,@"IMEI",
                 BundleVersion,@"ClientVersion",
                 HARDWAREBRAND,@"HardwareBrand",
                 iHardwareModel,@"HardwareModel",
                 PHONE_OS,@"OS",
                 MAPP_PHONE,@"From",nil];
    }
    
    requestStr = [self getRequestXMLWithString:headData withBody:body];
    
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
    
}

@end

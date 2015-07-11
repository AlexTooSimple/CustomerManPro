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
    
    NSString *userName = [requestInfo objectForKey:@"UserName"];
    NSString *pwd = [requestInfo objectForKey:@"PassWd"];
    
    NSString *requestClass = [[NSString alloc] initWithFormat:JSON_BODY_REUEST,[LOGIN_BIZCODE uppercaseString]];
    
    NSDictionary *bodyData = [[NSDictionary alloc] initWithObjectsAndKeys:
                              userName,@"name",
                              pwd,@"pwd",nil];
    [requestClass release];
    
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
    
}

@end

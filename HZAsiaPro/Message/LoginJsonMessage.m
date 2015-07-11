//
//  LoginJsonMessage.m
//  HZAsiaPro
//
//  Created by wuhui on 15-3-18.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "LoginJsonMessage.h"

@implementation LoginJsonMessage

- (NSString*)getRequest
{
    NSString *userName = [requestInfo objectForKey:@"UserName"];
    NSString *pwd = [requestInfo objectForKey:@"PassWd"];
    
    NSDictionary *bodyData = [[NSDictionary alloc] initWithObjectsAndKeys:
                              userName,@"name",
                              pwd,@"pwd",nil];
    NSString *requestStr = [self getRequestJSONFromHeader:nil
                                                 withBody:bodyData];
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

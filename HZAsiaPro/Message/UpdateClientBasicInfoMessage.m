//
//  UpdateClientBasicInfoMessage.m
//  HZAsiaPro
//
//  Created by wuhui on 15/7/12.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//  更新用户信息

#import "UpdateClientBasicInfoMessage.h"

@implementation UpdateClientBasicInfoMessage
- (NSString*)getRequest
{
    NSString *requestStr = [self getRequestJSONFromHeader:nil
                                                 withBody:self.requestInfo];
    
    NSLog(@"更新客户基本信息报文:%@",requestStr);
    
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
    return UPDATE_CLIENT_BASIC_INFO_BIZCODE;
}

- (NSString*)getBusinessCode
{
    return UPDATE_CLIENT_BASIC_INFO_BIZCODE;
}

-(void)parseMessage
{
    
}


@end

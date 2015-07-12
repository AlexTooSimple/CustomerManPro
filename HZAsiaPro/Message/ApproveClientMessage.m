//
//  ApproveClientMessage.m
//  HZAsiaPro
//
//  Created by wuhui on 15/7/12.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//
//  审批客户

#import "ApproveClientMessage.h"

@implementation ApproveClientMessage
- (NSString*)getRequest
{
    NSString *requestStr = [self getRequestJSONFromHeader:nil
                                                 withBody:self.requestInfo];
    
    NSLog(@"审批客户报文:%@",requestStr);
    
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
    return APPROVE_CLIENT_BIZCODE;
}

- (NSString*)getBusinessCode
{
    return APPROVE_CLIENT_BIZCODE;
}

-(void)parseMessage
{
    
}


@end

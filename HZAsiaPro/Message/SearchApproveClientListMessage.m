//
//  SearchApproveClientListMessage.m
//  HZAsiaPro
//
//  Created by wuhui on 15/7/12.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//


#import "SearchApproveClientListMessage.h"

@implementation SearchApproveClientListMessage
- (NSString*)getRequest
{
    NSString *requestStr = [self getRequestJSONFromHeader:nil
                                                 withBody:self.requestInfo];
    
    NSLog(@"获取审批客户列表报文:%@",requestStr);
    
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
    return SEARCH_APPROVE_CLIENT_LIST_BIZCODE;
}

- (NSString*)getBusinessCode
{
    return SEARCH_APPROVE_CLIENT_LIST_BIZCODE;
}

-(void)parseMessage
{
    
}

@end

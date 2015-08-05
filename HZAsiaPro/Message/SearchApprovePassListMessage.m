//
//  SearchApprovePassListMessage.m
//  HZAsiaPro
//
//  Created by wuhui on 15/8/4.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "SearchApprovePassListMessage.h"

@implementation SearchApprovePassListMessage
- (NSString*)getRequest
{
    NSString *requestStr = @"";
    NSLog(@"下载业务员下面审核通过的客户列表报文:%@",requestStr);
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
    return SEARCH_APPROVE_PASS_LIST_BIZCODE;
}

- (NSString*)getBusinessCode
{
    return SEARCH_APPROVE_PASS_LIST_BIZCODE;
}

-(void)parseMessage
{
    
}

@end

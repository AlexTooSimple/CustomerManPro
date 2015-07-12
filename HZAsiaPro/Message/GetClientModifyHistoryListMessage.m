//
//  GetClientModifyHistoryListMessage.m
//  HZAsiaPro
//
//  Created by wuhui on 15/7/12.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "GetClientModifyHistoryListMessage.h"

@implementation GetClientModifyHistoryListMessage
- (NSString*)getRequest
{
    NSString *clientCode = [requestInfo objectForKey:@"clientCode"];
    
    NSDictionary *bodyData = [[NSDictionary alloc] initWithObjectsAndKeys:
                              clientCode,@"clientCode",nil];
    
    NSString *requestStr = [self getRequestJSONFromHeader:nil
                                                 withBody:bodyData];
    [bodyData release];
    
    NSLog(@"获取历史修改记录报文:%@",requestStr);
    
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
    return GET_CLIENT_MODIFY_HISTORY_BIZCODE;
}

- (NSString*)getBusinessCode
{
    return GET_CLIENT_MODIFY_HISTORY_BIZCODE;
}

-(void)parseMessage
{
    
}
@end

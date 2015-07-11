//
//  GetVisitHistoryListMessage.m
//  HZAsiaPro
//
//  Created by wuhui on 15/7/10.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "GetVisitHistoryListMessage.h"

@implementation GetVisitHistoryListMessage
- (NSString*)getRequest
{
    NSString *requestStr = [self getRequestJSONFromHeader:nil
                                                 withBody:self.requestInfo];
    
    NSLog(@"获取访问记录报文:%@",requestStr);
    
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
    return GET_VISIT_HISTORY_BIZCODE;
}

- (NSString*)getBusinessCode
{
    return GET_VISIT_HISTORY_BIZCODE;
}

-(void)parseMessage
{
    
}

@end

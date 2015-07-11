//
//  AddVisitHistoryMessage.m
//  HZAsiaPro
//
//  Created by wuhui on 15/7/10.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "AddVisitHistoryMessage.h"

@implementation AddVisitHistoryMessage
- (NSString*)getRequest
{
    NSString *requestStr = [self getRequestJSONFromHeader:nil
                                                 withBody:self.requestInfo];
    
    NSLog(@"增加访问记录报文:%@",requestStr);
    
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
    return ADD_VISIT_HISTORY_BIZCODE;
}

- (NSString*)getBusinessCode
{
    return ADD_VISIT_HISTORY_BIZCODE;
}

-(void)parseMessage
{
    
}

@end

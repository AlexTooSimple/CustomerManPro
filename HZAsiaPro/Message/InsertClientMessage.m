//
//  InsertClientMessage.m
//  HZAsiaPro
//
//  Created by wuhui on 15/7/12.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//  新增客户

#import "InsertClientMessage.h"

@implementation InsertClientMessage
- (NSString*)getRequest
{
    NSString *requestStr = [self getRequestJSONFromHeader:nil
                                                 withBody:self.requestInfo];
    
    NSLog(@"新增客户报文:%@",requestStr);
    
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
    return INSERT_CUSTOMER_BIZCODE;
}

- (NSString*)getBusinessCode
{
    return INSERT_CUSTOMER_BIZCODE;
}

-(void)parseMessage
{
    
}

@end

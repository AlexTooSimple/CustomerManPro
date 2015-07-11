//
//  SearchCustomerWithConditionMessage.m
//  HZAsiaPro
//
//  Created by wuhui on 15/7/9.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "SearchCustomerWithConditionMessage.h"

@implementation SearchCustomerWithConditionMessage
- (NSString*)getRequest
{
    NSString *requestStr = [self getRequestJSONFromHeader:nil
                                                 withBody:self.requestInfo];
    
    NSLog(@"匹配条件搜索客户列表报文:%@",requestStr);
    
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
    return SEARCH_CUSTOMER_CODITION_BIZCODE;
}

- (NSString*)getBusinessCode
{
    return SEARCH_CUSTOMER_CODITION_BIZCODE;
}

-(void)parseMessage
{
    
}
@end

//
//  DeleteClientMessage.m
//  HZAsiaPro
//
//  Created by wuhui on 15/7/11.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "DeleteClientMessage.h"

@implementation DeleteClientMessage
- (NSString*)getRequest
{
    NSString *requestStr = [self getRequestJSONFromHeader:nil
                                                 withBody:self.requestInfo];
    
    NSLog(@"删除客户报文:%@",requestStr);
    
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
    return DELETE_CUSTOMER_BIZCODE;
}

- (NSString*)getBusinessCode
{
    return DELETE_CUSTOMER_BIZCODE;
}

-(void)parseMessage
{
    
}


@end

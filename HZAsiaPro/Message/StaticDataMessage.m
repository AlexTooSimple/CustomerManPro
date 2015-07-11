//
//  StaticDataMessage.m
//  HZAsiaPro
//
//  Created by wuhui on 15/7/9.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "StaticDataMessage.h"

@implementation StaticDataMessage
- (NSString*)getRequest
{
    NSString *requestStr = @"";
    NSLog(@"静态数据报文:%@",requestStr);
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
    return STATIC_DATA_BIZCODE;
}

- (NSString*)getBusinessCode
{
    return STATIC_DATA_BIZCODE;
}

-(void)parseMessage
{
    
}
@end

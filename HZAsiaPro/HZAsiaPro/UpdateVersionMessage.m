//
//  UpdateVersionMessage.m
//  HZAsiaPro
//
//  Created by wuhui on 15/8/4.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "UpdateVersionMessage.h"

@implementation UpdateVersionMessage
- (NSString*)getRequest
{
    NSString *requestStr = @"";
    NSLog(@"更新报文:%@",requestStr);
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
    return UPDATE_VERSION_BIZCODE;
}

- (NSString*)getBusinessCode
{
    return UPDATE_VERSION_BIZCODE;
}

-(void)parseMessage
{
    
}

@end

//
//  UpdateUserMessage.m
//  HZAsiaPro
//
//  Created by 颜梁坚 on 15/7/12.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "UpdateUserMessage.h"

@implementation UpdateUserMessage

- (NSString*)getRequest
{
    NSString *requestStr = [self getRequestJSONFromHeader:nil
                                                 withBody:self.requestInfo];
    
    NSLog(@"更新用户基本信息报文:%@",requestStr);
    
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
    return UPDATE_USER_BASIC_INFO_BIZCODE;
}

- (NSString*)getBusinessCode
{
    return UPDATE_USER_BASIC_INFO_BIZCODE;
}

-(void)parseMessage
{
    
}


@end

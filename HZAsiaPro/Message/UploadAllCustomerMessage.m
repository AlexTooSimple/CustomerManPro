//
//  UploadAllCustomerMessage.m
//  HZAsiaPro
//
//  Created by wuhui on 15/7/10.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "UploadAllCustomerMessage.h"


@implementation UploadAllCustomerMessage
- (NSString*)getRequest
{
    NSString *requestStr = @"";
    NSLog(@"下载业务员下面的全部客户列表报文:%@",requestStr);
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
    return UPLOAD_ALL_CUSTOMER_BIZCODE;
}

- (NSString*)getBusinessCode
{
    return UPLOAD_ALL_CUSTOMER_BIZCODE;
}

-(void)parseMessage
{
    
}
@end

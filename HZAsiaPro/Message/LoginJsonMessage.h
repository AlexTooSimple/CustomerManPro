//
//  LoginJsonMessage.h
//  HZAsiaPro
//
//  Created by wuhui on 15-3-18.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "JsonMessage.h"
#define LOGIN_BIZCODE    @"login.do?"

@interface LoginJsonMessage : JsonMessage
{
}
+ (NSString*)getBizCode;
@end

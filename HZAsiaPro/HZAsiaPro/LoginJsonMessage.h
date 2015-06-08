//
//  LoginJsonMessage.h
//  HZAsiaPro
//
//  Created by wuhui on 15-3-18.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "JsonMessage.h"
#define LOGIN_BIZCODE    @"hw0005"

#define USER_IMSI		@""
#define USER_BRAND      @"APPLE"
#define USER_SVC        @""
#define USER_OS         @"IOS"

@interface LoginJsonMessage : JsonMessage
{
}
+ (NSString*)getBizCode;
@end

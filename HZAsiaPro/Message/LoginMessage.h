//
//  LoginMessage.h
//  HZAsiaPro
//
//  Created by wuhui on 15-3-13.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "XmlMessage.h"

#define LOGIN_BIZCODE   @"HW0005"

#define MAPP_PHONE      @"iphone"
#define USER_IMSI		@""
#define HARDWAREBRAND	@"Apple"
#define PHONE_OS		@"IOS"

@interface LoginMessage : XmlMessage
{
}
+ (NSString*)getBizCode;
@end

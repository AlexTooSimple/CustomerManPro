//
//  CheckClientMessage.h
//  HZAsiaPro
//
//  Created by wuhui on 15/7/12.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "JsonMessage.h"

#define CHECK_CUSTOMER_BIZCODE        @"checkTrueClient.do?"
@interface CheckClientMessage : JsonMessage
{
    
}
+ (NSString*)getBizCode;
@end

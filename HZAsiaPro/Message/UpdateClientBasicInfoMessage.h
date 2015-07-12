//
//  UpdateClientBasicInfoMessage.h
//  HZAsiaPro
//
//  Created by wuhui on 15/7/12.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "JsonMessage.h"

#define UPDATE_CLIENT_BASIC_INFO_BIZCODE        @"update.do?"
@interface UpdateClientBasicInfoMessage : JsonMessage
{
    
}
+ (NSString*)getBizCode;
@end

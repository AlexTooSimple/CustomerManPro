//
//  UpdateVersionMessage.h
//  HZAsiaPro
//
//  Created by wuhui on 15/8/4.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "JsonMessage.h"

#define UPDATE_VERSION_BIZCODE    @"version.do"
@interface UpdateVersionMessage : JsonMessage
{
}
+ (NSString*)getBizCode;
@end

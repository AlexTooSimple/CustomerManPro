//
//  UpdateUserMessage.h
//  HZAsiaPro
//
//  Created by 颜梁坚 on 15/7/12.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "JsonMessage.h"

#define UPDATE_USER_BASIC_INFO_BIZCODE        @"updateUser.do?"
@interface UpdateUserMessage : JsonMessage

+ (NSString*)getBizCode;

@end

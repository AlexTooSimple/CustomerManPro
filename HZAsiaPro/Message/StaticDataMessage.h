//
//  StaticDataMessage.h
//  HZAsiaPro
//
//  Created by wuhui on 15/7/9.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "JsonMessage.h"

#define STATIC_DATA_BIZCODE    @"queryAllDict.do"

@interface StaticDataMessage : JsonMessage
{
}
+ (NSString*)getBizCode;
@end

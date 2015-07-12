//
//  InsertClientMessage.h
//  HZAsiaPro
//
//  Created by wuhui on 15/7/12.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "JsonMessage.h"

#define INSERT_CUSTOMER_BIZCODE        @"insert.do?"
@interface InsertClientMessage : JsonMessage
{
    
}
+ (NSString*)getBizCode;
@end

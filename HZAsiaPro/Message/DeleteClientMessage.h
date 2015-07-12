//
//  DeleteClientMessage.h
//  HZAsiaPro
//
//  Created by wuhui on 15/7/11.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "JsonMessage.h"
#define DELETE_CUSTOMER_BIZCODE        @"deleteTrueClient.do?"
@interface DeleteClientMessage : JsonMessage
{
    
}
+ (NSString*)getBizCode;
@end

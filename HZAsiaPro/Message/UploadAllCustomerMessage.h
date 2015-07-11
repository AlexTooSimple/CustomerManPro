//
//  UploadAllCustomerMessage.h
//  HZAsiaPro
//
//  Created by wuhui on 15/7/10.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//
//  获取未联系的客户
#import "JsonMessage.h"
#define UPLOAD_ALL_CUSTOMER_BIZCODE    @"fetchAlert.do"

@interface UploadAllCustomerMessage : JsonMessage
{
}
+ (NSString*)getBizCode;
@end

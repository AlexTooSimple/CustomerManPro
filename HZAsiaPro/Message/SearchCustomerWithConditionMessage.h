//
//  SearchCustomerWithConditionMessage.h
//  HZAsiaPro
//
//  Created by wuhui on 15/7/9.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//
//  搜索客户
#import "JsonMessage.h"
#define SEARCH_CUSTOMER_CODITION_BIZCODE        @"queryTrueClient.do?"

@interface SearchCustomerWithConditionMessage : JsonMessage
{

}
+ (NSString*)getBizCode;
@end

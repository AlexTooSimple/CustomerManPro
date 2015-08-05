//
//  SearchApprovePassListMessage.h
//  HZAsiaPro
//
//  Created by wuhui on 15/8/4.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "JsonMessage.h"

#define SEARCH_APPROVE_PASS_LIST_BIZCODE    @"queryAuditedClient.do"
@interface SearchApprovePassListMessage : JsonMessage
{
}
+ (NSString*)getBizCode;
@end

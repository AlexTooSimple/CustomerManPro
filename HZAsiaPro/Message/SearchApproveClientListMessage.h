//
//  SearchApproveClientListMessage.h
//  HZAsiaPro
//
//  Created by wuhui on 15/7/12.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "JsonMessage.h"
#define SEARCH_APPROVE_CLIENT_LIST_BIZCODE        @"queryPreClient.do?"
@interface SearchApproveClientListMessage : JsonMessage
{
    
}
+ (NSString*)getBizCode;
@end

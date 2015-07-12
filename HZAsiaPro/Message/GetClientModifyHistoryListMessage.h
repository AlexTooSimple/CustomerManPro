//
//  GetClientModifyHistoryListMessage.h
//  HZAsiaPro
//
//  Created by wuhui on 15/7/12.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//
//	查询修改记录接口。参数：clientCode


#import "JsonMessage.h"
#define GET_CLIENT_MODIFY_HISTORY_BIZCODE    @"queryLog.do?"
@interface GetClientModifyHistoryListMessage : JsonMessage
{
}
+ (NSString*)getBizCode;
@end

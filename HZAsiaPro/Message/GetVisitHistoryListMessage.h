//
//  GetVisitHistoryListMessage.h
//  HZAsiaPro
//
//  Created by wuhui on 15/7/10.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "JsonMessage.h"
#define GET_VISIT_HISTORY_BIZCODE        @"queryLxs.do?"
@interface GetVisitHistoryListMessage : JsonMessage
{
    
}
+ (NSString*)getBizCode;
@end

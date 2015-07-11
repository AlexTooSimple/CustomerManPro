//
//  AddVisitHistoryMessage.h
//  HZAsiaPro
//
//  Created by wuhui on 15/7/10.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "JsonMessage.h"
#define ADD_VISIT_HISTORY_BIZCODE        @"addLxs.do?"
@interface AddVisitHistoryMessage : JsonMessage
{
    
}
+ (NSString*)getBizCode;
@end

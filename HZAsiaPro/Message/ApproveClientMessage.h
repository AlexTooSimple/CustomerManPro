//
//  ApproveClientMessage.h
//  HZAsiaPro
//
//  Created by wuhui on 15/7/12.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "JsonMessage.h"
#define APPROVE_CLIENT_BIZCODE    @"audit.do?"
@interface ApproveClientMessage : JsonMessage
{
    
}
+ (NSString*)getBizCode;
@end

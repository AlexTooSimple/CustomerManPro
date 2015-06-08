//
//  message.h
//  HZAsiaPro
//
//  Created by wuhui on 15-3-12.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageDelegate.h"

@interface message : NSObject<MessageDelegate>
{
    NSString* rspCode;
    NSString* rspDesc;
    
    //返回包体解析存储字典及发送包体字典
    NSDictionary *rspInfo;
    NSDictionary *requestInfo;
    
    NSString* bizCode;
    BOOL isXML;
}
@property(nonatomic, assign)BOOL isXML;
@property(nonatomic, retain)NSString* rspCode;
@property(nonatomic, retain)NSString* rspDesc;
@property(nonatomic, retain)NSDictionary *rspInfo;
@property(nonatomic, retain)NSDictionary *requestInfo;
@property(nonatomic, retain)NSString* bizCode;

- (void)parseResponse:(NSString *)responseMessage;
+ (NSString *)getBizCode;
+ (NSString *)getNetLinkErrorCode;
+ (NSString *)getTimeOutErrorCode;
+ (NSString *)getRespondDescription:(NSString *)resCode;
- (NSString *)getRspcode;
- (NSString *)getMSG;
#pragma mark
#pragma mark - 加密方法
+ (NSString *)md5Encode:(NSString *)str;
@end

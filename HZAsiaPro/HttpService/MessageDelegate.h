//
//  MessageDelegate.h
//  IOSCodeTest
//
//  Created by wuhui on 15-2-2.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//


#import <Foundation/Foundation.h>

@protocol MessageDelegate <NSObject>

@optional
- (NSString *)getBusinessCode;
- (NSString *)getRequest;
- (NSString *)getResponse:(NSData *)responseData;
- (void)parseResponse:(NSString *)responseMessage;
@end

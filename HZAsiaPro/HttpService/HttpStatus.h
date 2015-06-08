//
//  HttpStatus.h
//  IOSCodeTest
//
//  Created by wuhui on 15-2-2.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageDelegate.h"

@protocol HttpStatus <NSObject>

@optional
- (void)requestWillBeSent;
- (void)requestDidFinished:(id <MessageDelegate>)message;
//errorInfo: key:MESSAGE_OBJECT is id,key:STATUS_CODE is  string
- (void)requestFailed:(NSDictionary*)errorInfo;
@end

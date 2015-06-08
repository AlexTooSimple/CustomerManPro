//
//  HttpConnector.h
//  IOSCodeTest
//
//  Created by wuhui on 15-2-2.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking/AFNetworking.h"
#import "MessageDelegate.h"
#import "HttpStatus.h"

@interface HttpConnector : NSObject
@property (nonatomic ,assign)id statusDelegate;
@property (nonatomic ,retain)NSString *serviceURL;
@property (nonatomic ,assign)NSTimeInterval timeOut;
@property (nonatomic ,assign)BOOL isPostXML;
- (void)sendMessage:(id<MessageDelegate>) message;
+ (HttpConnector*)sharedHttpConnector;
+ (void)releaseHttpConnector;
@end

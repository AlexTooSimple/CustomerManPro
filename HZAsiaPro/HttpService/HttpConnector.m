//
//  HttpConnector.m
//  IOSCodeTest
//
//  Created by wuhui on 15-2-2.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "HttpConnector.h"

static HttpConnector *sharedHttpConnector = nil;

@implementation HttpConnector

@synthesize serviceURL;
@synthesize timeOut;
@synthesize isPostXML;
@synthesize statusDelegate;

+(HttpConnector*)sharedHttpConnector
{
    @synchronized ([HttpConnector class]) {
        if (sharedHttpConnector == nil) {
            sharedHttpConnector = [[HttpConnector alloc] init];
            return sharedHttpConnector;
        }
    }
    
    return sharedHttpConnector;
}

- (id)init
{
    if (self == [super init]) {
        serviceURL = nil;
        timeOut = 10;
    }
    return self;
}

+ (void)releaseHttpConnector
{
    if(nil != sharedHttpConnector){
        [sharedHttpConnector release];
        sharedHttpConnector = nil;
    }
}

- (void)dealloc
{
    [serviceURL release];
    [super dealloc];
}

// AFNetworking 只支持异步请求
- (void)sendMessage:(id<MessageDelegate>) message
{
    AFHTTPRequestOperationManager *httpManager = [AFHTTPRequestOperationManager manager];
    
    //设置Http Header
    AFHTTPRequestSerializer *requestHttpHeader = [AFHTTPRequestSerializer serializer];
    requestHttpHeader.timeoutInterval = self.timeOut;
    [requestHttpHeader setValue:@"application/x-www-form-urlencoded"
             forHTTPHeaderField:@"Content-Type"];
    httpManager.requestSerializer = requestHttpHeader;
    
    httpManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    httpManager.responseSerializer.acceptableContentTypes = [httpManager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    //设置Http 实体
    NSDictionary *requestPostValue = nil;
    NSString *requestMessage = [message getRequest];
    if (isPostXML) {
        requestPostValue = [[NSDictionary alloc] initWithObjectsAndKeys:
                            requestMessage,@"xmlmsg", nil];
    }else{
        requestPostValue = [[NSDictionary alloc] initWithObjectsAndKeys:
                            requestMessage,@"msg", nil];
    }
    
    if (nil != statusDelegate && [statusDelegate respondsToSelector:@selector(requestWillBeSent)]) {
        [statusDelegate performSelectorOnMainThread:@selector(requestWillBeSent)
                                         withObject:nil
                                      waitUntilDone:[NSThread isMainThread]];
    }
    
    [httpManager POST:self.serviceURL
           parameters:requestPostValue
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  if (operation.response.statusCode == 200) {
                      //返回成功
                      if (message != nil) {
                          NSString *responseMsg = [message getResponse:responseObject];
                          [message parseResponse:responseMsg];
                          if (statusDelegate != nil && [statusDelegate respondsToSelector:@selector(requestDidFinished:)]) {
                              [statusDelegate performSelectorOnMainThread:@selector(requestDidFinished:)
                                                               withObject:message
                                                            waitUntilDone:[NSThread isMainThread]];
                              
                          }
                      }
                  }else{
                      //返回失败
                      if (statusDelegate != nil && [statusDelegate respondsToSelector:@selector(requestDidFinished:)]) {
                          NSMutableDictionary* errorInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
                          [errorInfo setObject:message forKey:@"MESSAGE_OBJECT"];
                          [errorInfo setObject:@"8888" forKey:@"STATUS_CODE"];
                          
                          [statusDelegate performSelectorOnMainThread:@selector(requestFailed:)
                                                           withObject:errorInfo
                                                        waitUntilDone:[NSThread isMainThread]];
                          
                          [errorInfo release];
                      }
                  }

              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  //返回失败
                  if (nil != statusDelegate && YES == [statusDelegate respondsToSelector:@selector(requestFailed:)]) {
                      NSString* errorCode = @"9999";
                      if (error.code == -1001) {//网络连接失败
                          errorCode = @"8888";
                      } else if (error.code == -1004) {//网络连接超时
                          errorCode = @"5555";
                      }
                      NSMutableDictionary* errorInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
                      [errorInfo setObject:message forKey:@"MESSAGE_OBJECT"];
                      [errorInfo setObject:errorCode forKey:@"STATUS_CODE"];
                      
                      [statusDelegate performSelectorOnMainThread:@selector(requestFailed:)
                                                       withObject:errorInfo
                                                    waitUntilDone:[NSThread isMainThread]];
                      
                      [errorInfo release];
                  }
              }];
    [requestPostValue release];
}

@end

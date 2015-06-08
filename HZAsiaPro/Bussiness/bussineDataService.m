//
//  bussineDataService.m
// 
//
//  Created by Wu YouJian on 8/6/11.
//  Copyright 2011 asiainfo-linkage. All rights reserved.
//

#import "bussineDataService.h"
#import "SVProgressHUD.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"


//单实例模式
static bussineDataService *sharedBussineDataService = nil;

@interface bussineDataService(Private)
- (void)sendMessage:(id <MessageDelegate>)msg synchronously:(BOOL)isSynchronous;
-(NSDictionary*)handleRspInfo:(message*) msg;
-(void)noticeUI:(NSDictionary*)rspDic;
- (void)readySendMessage:(NSString*)messageClaseName
                   param:(NSDictionary*)parameters
                 funName:(NSString*)funName
           synchronously:(BOOL)synchronously;
@end

@implementation bussineDataService

@synthesize target;
@synthesize sendMessageSelector;
@synthesize receiveString;
@synthesize sendDataDic;
@synthesize sendString;
@synthesize lastDate;
@synthesize currentDate;

@synthesize updateUrl;

#pragma mark -
#pragma mark bussineDataService inferface
+(bussineDataService*)sharedDataService {
    
    @synchronized ([bussineDataService class]) {
        if (sharedBussineDataService == nil) {
			sharedBussineDataService = [[bussineDataService alloc] init];
            return sharedBussineDataService;
        }
    }
    
    return sharedBussineDataService;
}

+(void)releaseBussineDataService
{
    if(nil != sharedBussineDataService){
        [sharedBussineDataService release];
        sharedBussineDataService = nil;
    }
}

-(id)init
{
	if (self = [super init]) {
		
    }
	
	return self;
}

-(void)dealloc
{
    
    [receiveString release];
    [sendDataDic release];
    [sendString release];
    [lastDate release];
    [currentDate release];
    [updateUrl release];
    
    
    [HttpConnector releaseHttpConnector];
    [super dealloc];
}


- (void)sendMessage:(id <MessageDelegate>)msg synchronously:(BOOL)isSynchronous
{
    [MBProgressHUD showHUDAddedTo:((AppDelegate *)[UIApplication sharedApplication].delegate).window animated:YES];
    HttpConnector* httpConnector = [HttpConnector sharedHttpConnector];
#ifdef STATIC_XML
    
#else
    httpConnector.serviceURL = service_url;
    NSLog(@"请求的地址：%@",httpConnector.serviceURL);
    [httpConnector sendMessage:msg];
#endif
}

-(NSDictionary *)handleRspInfo:(message*)msg
{
    
    NSString* rspCode = [msg getRspcode];
    NSString* bussineCode = msg.bizCode;
    NSString* rspDesc = [msg getMSG];
    
    //key: bussineCode value :; Key:errorCode, value: key:MSG, value:
    NSMutableDictionary* rspDic = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];
    [rspDic setObject:rspCode forKey:@"errorCode"];
    [rspDic setObject:bussineCode forKey:@"bussineCode"];
    if (rspDesc != nil) {
        [rspDic setObject:rspDesc forKey:@"MSG"];
    }
    
    if ([rspCode isEqualToString:@"5000"]) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Sale_Note_String", nil)
                                                            message:NSLocalizedString(@"Sale_Login_Session_Invalid", nil)
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"Sale_Confirm_String", nil)
                                                  otherButtonTitles:nil];
        alertView.tag = kSessionTimeOutTag;
        [alertView show];
        [alertView release];
        return nil;
    }
    
    return rspDic;
}

-(void)noticeUI:(NSDictionary*)rspDic
{
    if (rspDic == nil) {
        return;
    }
    
    NSString* rspCode = [rspDic objectForKey:@"errorCode"];
    
    if([rspCode isEqualToString:@"0000"]){
        if (nil != self.target && [self.target respondsToSelector:@selector(requestDidFinished:)]) {
			[self.target performSelector:@selector(requestDidFinished:) withObject:rspDic];
		}
        
	} else {
		if (nil != self.target && [self.target respondsToSelector:@selector(requestFailed:)]) {
			[self.target performSelector:@selector(requestFailed:) withObject:rspDic];
		}
	}
}

- (void)readySendMessage:(NSString*)messageClaseName
                   param:(NSDictionary*)parameters
                 funName:(NSString*)funName
           synchronously:(BOOL)synchronously
{
    Class class =  NSClassFromString(messageClaseName);
    message* messageObject = (message*)[[class alloc] init];
    messageObject.requestInfo = parameters;
    SEL selector = NSSelectorFromString(funName);
    [self setSendMessageSelector:selector];
    self.sendDataDic = parameters;
	[self sendMessage:messageObject synchronously:synchronously];
    [messageObject release];
}

#pragma mark -
#pragma mark 数据服务器接口

#pragma mark
#pragma mark - 登录
- (void)login:(NSDictionary*)parameters
{
    [self readySendMessage:@"LoginJsonMessage"
                     param:parameters
                   funName:@"login:"
             synchronously:NO];
}

- (void)loginFinished:(id <MessageDelegate>)loginResponse
{
    LoginJsonMessage* Msg = loginResponse;
    NSDictionary* rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([rspCode isEqualToString:@"0000"]){
//        NSMutableDictionary* uInfo = [[NSMutableDictionary alloc] initWithCapacity:1];
//        [uInfo addEntriesFromDictionary:Msg.requestInfo];
//        [uInfo addEntriesFromDictionary:Msg.rspInfo];
//        
//        self.userInfo = uInfo;
//        [uInfo release];
    }
    [self noticeUI:rspDic];
}


#pragma mark -
#pragma mark http 回调接口
- (void)requestDidFinished:(id<MessageDelegate>)msg
{
   [MBProgressHUD hideHUDForView:((AppDelegate *)[UIApplication sharedApplication].delegate).window animated:YES];
    
    if (YES == [[msg getBusinessCode] isEqualToString:LOGIN_BIZCODE]) {
        [self loginFinished:msg];
    }
}


- (void)requestFailed:(NSDictionary*)errorInfo
{
    [MBProgressHUD hideHUDForView:((AppDelegate *)[UIApplication sharedApplication].delegate).window animated:YES];
	id<MessageDelegate> msg = [errorInfo objectForKey:@"MESSAGE_OBJECT"];
    
	NSString* errorCode = [errorInfo objectForKey:@"STATUS_CODE"];
    NSString* bussineCode = [msg getBusinessCode];
    NSString* rspDesc = [message getRespondDescription:errorCode];

    NSMutableDictionary* rspDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [rspDic setObject:errorCode forKey:@"errorCode"];
    [rspDic setObject:bussineCode forKey:@"bussineCode"];
    if (rspDesc != nil) {
        [rspDic setObject:rspDesc forKey:@"MSG"];
    }
    
    if ([[message getNetLinkErrorCode] isEqualToString:errorCode]) {
        
        AlertShowView *alertView = [[AlertShowView alloc] initWithAlertViewTitle:nil
                                                                         message:rspDesc
                                                                        delegate:self
                                                                             tag:kLinkErrorTag
                                                               cancelButtonTitle:@"取消"
                                                               otherButtonTitles:@"重试",nil];
       
        [alertView show];
        [alertView release];
        
        [rspDic release];
        return;        
    }
    
    if ([[message getTimeOutErrorCode] isEqualToString:errorCode]) {
        AlertShowView *alertView = [[AlertShowView alloc] initWithAlertViewTitle:nil
                                                                         message:rspDesc
                                                                        delegate:self
                                                                             tag:kTimeOutErrorTag
                                                               cancelButtonTitle:@"取消"
                                                               otherButtonTitles:@"重试",nil];
        [alertView show];
        [alertView release];
        [rspDic release];
        
        return;
    }
    

    if (nil != self.target && [self.target respondsToSelector:@selector(requestFailed:)]) {
        [self.target performSelector:@selector(requestFailed:) withObject:rspDic];
    }
    
    [rspDic release];	
}


#pragma mark
#pragma mark -  AlertShowViewDelegate
- (void)alertShowView:(AlertShowView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (kForceUpdateTag == alertView.index) {
        // 强制升级
        if (1 == buttonIndex)
        {
            NSLog(@"updateUrl:%@",self.updateUrl);
            NSURL* url = [NSURL URLWithString:self.updateUrl];
            if([[UIApplication sharedApplication] canOpenURL:url]){
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }
    
    if (kLinkErrorTag == alertView.index || kTimeOutErrorTag == alertView.index) {
        //超时或者连接错误，重试
        if (buttonIndex == 1) {
            if ([self respondsToSelector:sendMessageSelector]) {
                [self performSelector:sendMessageSelector withObject:sendDataDic];
            }
        }
        
        if (buttonIndex == 0) {
            if (nil != self.target && [self.target respondsToSelector:@selector(cancelTimeOutAndLinkError)]) {
                [self.target cancelTimeOutAndLinkError];
            }
        }
    }
    
    if (kSessionTimeOutTag == alertView.index) {
        //回到登陆页
//        [(AppDelegate*)[UIApplication sharedApplication].delegate relogin];
    }

}



@end

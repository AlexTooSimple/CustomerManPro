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
    httpConnector.statusDelegate = self;
    httpConnector.isPostXML = NO;
    
#ifdef STATIC_XML
    
#else
    NSString *serviceURL = [[NSString alloc] initWithFormat:@"%@%@",service_url,[msg getBusinessCode]];
    httpConnector.serviceURL = serviceURL;
    [serviceURL release];
    
    NSLog(@"请求的地址：%@",httpConnector.serviceURL);
    [httpConnector sendMessage:msg];
    
#endif
}

-(NSDictionary *)handleRspInfo:(message*)msg
{
    
    NSString* rspCode = [msg getRspcode];
    NSString* bussineCode = [msg getBusinessCode];
    NSString* rspDesc = [msg getMSG];
    
    //key: bussineCode value :; Key:errorCode, value: key:MSG, value:
    NSMutableDictionary* rspDic = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];
    [rspDic setObject:rspCode forKey:@"errorCode"];
    [rspDic setObject:bussineCode forKey:@"bussineCode"];
    [rspDic setObject:msg forKey:@"message"];

    if (rspDesc != nil) {
        [rspDic setObject:rspDesc forKey:@"MSG"];
    }
    
    return rspDic;
}

-(void)noticeUI:(NSDictionary*)rspDic
{
    if (rspDic == nil) {
        return;
    }
    NSString* rspCode = [rspDic objectForKey:@"errorCode"];
    NSString* rspDesc = [rspDic objectForKey:@"MSG"];
    if ([rspCode isEqualToString:RESPONE_RESULT_FALSE] &&
        [rspDesc isEqualToString:@"未登录"]) {
        //重新登录
        AlertShowView *alterView = [[AlertShowView alloc] initWithAlertViewTitle:@"提示"
                                                                         message:@"登录超时,请重新登录！"
                                                                        delegate:self
                                                                             tag:kSessionTimeOutTag
                                                               cancelButtonTitle:@"确定"
                                                               otherButtonTitles:nil];
        [alterView show];
        [alterView release];
        
        return;
    }
    
    if([rspCode isEqualToString:RESPONE_RESULT_TRUE]){
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
    if([[rspCode lowercaseString] isEqualToString:RESPONE_RESULT_TRUE]){
        
    }
    [self noticeUI:rspDic];
}


#pragma mark
#pragma mark - 获取静态数据
- (void)getStaticData:(NSDictionary *)paramters
{
    [self readySendMessage:@"StaticDataMessage"
                     param:paramters
                   funName:@"getStaticData:"
             synchronously:NO];
}

- (void)getStaticDataFinished:(id <MessageDelegate>)staticResponse
{
    StaticDataMessage* Msg = staticResponse;
    NSDictionary* rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([[rspCode lowercaseString] isEqualToString:RESPONE_RESULT_TRUE]){
        
    }
    [self noticeUI:rspDic];
}

#pragma mark
#pragma mark - 通过匹配条件获取客户列表
- (void)searchCustomerListWithCondition:(NSDictionary *)paramters
{
    [self readySendMessage:@"SearchCustomerWithConditionMessage"
                     param:paramters
                   funName:@"searchCustomerListWithCondition:"
             synchronously:NO];
}

- (void)searchCustomerListWithConditionFinished:(id <MessageDelegate>)searchResponse
{
    SearchCustomerWithConditionMessage* Msg = searchResponse;
    NSDictionary* rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([[rspCode lowercaseString] isEqualToString:RESPONE_RESULT_TRUE]){
        
    }
    [self noticeUI:rspDic];
}

#pragma mark
#pragma mark - 下载所有客户
- (void)uploadAllCustomer:(NSDictionary *)paramters
{
    [self readySendMessage:@"UploadAllCustomerMessage"
                     param:paramters
                   funName:@"uploadAllCustomer:"
             synchronously:NO];
}

- (void)uploadAllCustomerFinished:(id <MessageDelegate>)searchResponse
{
    UploadAllCustomerMessage* Msg = searchResponse;
    NSDictionary* rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([[rspCode lowercaseString] isEqualToString:RESPONE_RESULT_TRUE]){
        
    }
    [self noticeUI:rspDic];
}


#pragma mark
#pragma mark - 获取访问记录列表
- (void)getVisitHistoryList:(NSDictionary *)paramters
{
    [self readySendMessage:@"GetVisitHistoryListMessage"
                     param:paramters
                   funName:@"getVisitHistoryList:"
             synchronously:NO];
}

- (void)getVisitHistoryListFinished:(id <MessageDelegate>)searchResponse
{
    GetVisitHistoryListMessage* Msg = searchResponse;
    NSDictionary* rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([[rspCode lowercaseString] isEqualToString:RESPONE_RESULT_TRUE]){
        
    }
    [self noticeUI:rspDic];
}

#pragma mark
#pragma mark - 新增访问记录
- (void)addVisitHistory:(NSDictionary *)paramters
{
    [self readySendMessage:@"AddVisitHistoryMessage"
                     param:paramters
                   funName:@"addVisitHistory:"
             synchronously:NO];
}

- (void)addVisitHistoryFinished:(id <MessageDelegate>)searchResponse
{
    AddVisitHistoryMessage* Msg = searchResponse;
    NSDictionary* rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([[rspCode lowercaseString] isEqualToString:RESPONE_RESULT_TRUE]){
        
    }
    [self noticeUI:rspDic];
}

#pragma mark
#pragma mark - 删除客户
- (void)deleteCustomer:(NSDictionary *)paramters
{
    [self readySendMessage:@"DeleteClientMessage"
                     param:paramters
                   funName:@"deleteCustomer:"
             synchronously:NO];
}

- (void)deleteCustomerFinished:(id <MessageDelegate>)searchResponse
{
    DeleteClientMessage* Msg = searchResponse;
    NSDictionary* rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([[rspCode lowercaseString] isEqualToString:RESPONE_RESULT_TRUE]){
        
    }
    [self noticeUI:rspDic];
}


#pragma mark
#pragma mark - 检查客户是否存在
- (void)checkCustomer:(NSDictionary *)paramters
{
    [self readySendMessage:@"CheckClientMessage"
                     param:paramters
                   funName:@"checkCustomer:"
             synchronously:NO];
}

- (void)checkCustomerFinished:(id <MessageDelegate>)searchResponse
{
    CheckClientMessage* Msg = searchResponse;
    NSDictionary* rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([[rspCode lowercaseString] isEqualToString:RESPONE_RESULT_TRUE]){
        
    }
    [self noticeUI:rspDic];
}


#pragma mark
#pragma mark - 新增客户
- (void)insertCustomer:(NSDictionary *)paramters
{
    [self readySendMessage:@"InsertClientMessage"
                     param:paramters
                   funName:@"insertCustomer:"
             synchronously:NO];
}

- (void)insertCustomerFinished:(id <MessageDelegate>)searchResponse
{
    InsertClientMessage* Msg = searchResponse;
    NSDictionary* rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([[rspCode lowercaseString] isEqualToString:RESPONE_RESULT_TRUE]){
        
    }
    [self noticeUI:rspDic];
}



#pragma mark
#pragma mark - 更新客户基本信息
- (void)updateCustomer:(NSDictionary *)paramters
{
    [self readySendMessage:@"UpdateClientBasicInfoMessage"
                     param:paramters
                   funName:@"updateCustomer:"
             synchronously:NO];
}

- (void)updateCustomerFinished:(id <MessageDelegate>)searchResponse
{
    UpdateClientBasicInfoMessage* Msg = searchResponse;
    NSDictionary* rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([[rspCode lowercaseString] isEqualToString:RESPONE_RESULT_TRUE]){
        
    }
    [self noticeUI:rspDic];
}

#pragma mark
#pragma mark - 更新用户基本信息
- (void)updateUser:(NSDictionary *)paramters
{
    [self readySendMessage:@"UpdateUserMessage"
                     param:paramters
                   funName:@"updateUser:"
             synchronously:NO];
}

- (void)updateUserFinished:(id <MessageDelegate>)searchResponse
{
    UpdateUserMessage* Msg = searchResponse;
    NSDictionary* rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([[rspCode lowercaseString] isEqualToString:RESPONE_RESULT_TRUE]){
        
    }
    [self noticeUI:rspDic];
}

#pragma mark
#pragma mark - 审批客户
- (void)approveClient:(NSDictionary *)paramters
{
    [self readySendMessage:@"ApproveClientMessage"
                     param:paramters
                   funName:@"approveClient:"
             synchronously:NO];
}

- (void)approveClientFinished:(id <MessageDelegate>)searchResponse
{
    ApproveClientMessage* Msg = searchResponse;
    NSDictionary* rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([[rspCode lowercaseString] isEqualToString:RESPONE_RESULT_TRUE]){
        
    }
    [self noticeUI:rspDic];
}

#pragma mark
#pragma mark - 搜索审批客户
- (void)searchApproveClientList:(NSDictionary *)paramters
{
    [self readySendMessage:@"SearchApproveClientListMessage"
                     param:paramters
                   funName:@"searchApproveClientList:"
             synchronously:NO];
}

- (void)searchApproveClientListFinished:(id <MessageDelegate>)searchResponse
{
    SearchApproveClientListMessage* Msg = searchResponse;
    NSDictionary* rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([[rspCode lowercaseString] isEqualToString:RESPONE_RESULT_TRUE]){
        
    }
    [self noticeUI:rspDic];
}

#pragma mark
#pragma mark - 获取历史修改记录
- (void)getModifyHistoryList:(NSDictionary *)paramters
{
    [self readySendMessage:@"GetClientModifyHistoryListMessage"
                     param:paramters
                   funName:@"getModifyHistoryList:"
             synchronously:NO];
}

- (void)getModifyHistoryListFinished:(id <MessageDelegate>)searchResponse
{
    GetClientModifyHistoryListMessage* Msg = searchResponse;
    NSDictionary* rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([[rspCode lowercaseString] isEqualToString:RESPONE_RESULT_TRUE]){
        
    }
    [self noticeUI:rspDic];
}

#pragma mark
#pragma mark - 获取业务员下面审核通过的客户列表
- (void)searchApprovePassClientList:(NSDictionary *)paramters
{
    [self readySendMessage:@"SearchApprovePassListMessage"
                     param:paramters
                   funName:@"searchApprovePassClientList:"
             synchronously:NO];
}

- (void)searchApprovePassClientListFinished:(id <MessageDelegate>)searchResponse
{
    SearchApprovePassListMessage* Msg = searchResponse;
    NSDictionary* rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([[rspCode lowercaseString] isEqualToString:RESPONE_RESULT_TRUE]){
        
    }
    [self noticeUI:rspDic];
}

#pragma mark
#pragma mark - 更新接口
- (void)updateVersion:(NSDictionary *)paramters
{
    [self readySendMessage:@"UpdateVersionMessage"
                     param:paramters
                   funName:@"updateVersion:"
             synchronously:NO];
}

- (void)updateVersionFinished:(id <MessageDelegate>)searchResponse
{
    UpdateVersionMessage* Msg = searchResponse;
    NSDictionary* rspDic = [self handleRspInfo:Msg];
    NSString* rspCode = [Msg getRspcode];
    if([[rspCode lowercaseString] isEqualToString:RESPONE_RESULT_TRUE]){
        //处理更新的业务逻辑
        NSDictionary *versionData =  [NSJSONSerialization JSONObjectWithData:[[Msg.rspInfo objectForKey:@"data"] dataUsingEncoding:NSUTF8StringEncoding]
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:nil];
        NSString *url = [versionData objectForKey:@"url"];
        self.updateUrl = url;
        NSString *forse = [versionData objectForKey:@"forse"];
        if ([forse isEqualToString:RESPONE_RESULT_TRUE]) {
            //强制更新
            AlertShowView *alterView = [[AlertShowView alloc] initWithAlertViewTitle:@"强制更新"
                                                                             message:@"您的版本太低,请强制升级!"
                                                                            delegate:self
                                                                                 tag:kForceUpdateTag
                                                                   cancelButtonTitle:@"确定"
                                                                   otherButtonTitles:nil];
            [alterView show];
            [alterView release];
            return;
        }
        
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
    }else if (YES == [[msg getBusinessCode] isEqualToString:STATIC_DATA_BIZCODE]){
        [self getStaticDataFinished:msg];
    }else if (YES == [[msg getBusinessCode] isEqualToString:SEARCH_CUSTOMER_CODITION_BIZCODE]){
        [self searchCustomerListWithConditionFinished:msg];
    }else if (YES == [[msg getBusinessCode] isEqualToString:UPLOAD_ALL_CUSTOMER_BIZCODE]){
        [self uploadAllCustomerFinished:msg];
    }else if (YES == [[msg getBusinessCode] isEqualToString:GET_VISIT_HISTORY_BIZCODE]){
        [self getVisitHistoryListFinished:msg];
    }else if (YES == [[msg getBusinessCode] isEqualToString:ADD_VISIT_HISTORY_BIZCODE]){
        [self addVisitHistoryFinished:msg];
    }else if (YES == [[msg getBusinessCode] isEqualToString:DELETE_CUSTOMER_BIZCODE]){
        [self deleteCustomerFinished:msg];
    }else if (YES == [[msg getBusinessCode] isEqualToString:CHECK_CUSTOMER_BIZCODE]){
        [self checkCustomerFinished:msg];
    }else if (YES == [[msg getBusinessCode] isEqualToString:INSERT_CUSTOMER_BIZCODE]){
        [self insertCustomerFinished:msg];
    }else if (YES == [[msg getBusinessCode] isEqualToString:UPDATE_CLIENT_BASIC_INFO_BIZCODE]){
        [self updateCustomerFinished:msg];
    }else if (YES == [[msg getBusinessCode] isEqualToString:UPDATE_USER_BASIC_INFO_BIZCODE]){
        [self updateUserFinished:msg];
    }else if (YES == [[msg getBusinessCode] isEqualToString:SEARCH_APPROVE_CLIENT_LIST_BIZCODE]){
        [self searchApproveClientListFinished:msg];
    }else if (YES == [[msg getBusinessCode] isEqualToString:APPROVE_CLIENT_BIZCODE]){
        [self approveClientFinished:msg];
    }else if (YES == [[msg getBusinessCode] isEqualToString:GET_CLIENT_MODIFY_HISTORY_BIZCODE]){
        [self getModifyHistoryListFinished:msg];
    }else if (YES == [[msg getBusinessCode] isEqualToString:SEARCH_APPROVE_PASS_LIST_BIZCODE]){
        [self searchApprovePassClientListFinished:msg];
    }else if (YES == [[msg getBusinessCode] isEqualToString:UPDATE_VERSION_BIZCODE]){
        [self updateVersionFinished:msg];
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
#pragma mark - UIAlterViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (kForceUpdateTag == alertView.tag) {
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
    
    if (kLinkErrorTag == alertView.tag || kTimeOutErrorTag == alertView.tag) {
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
    
    if (kSessionTimeOutTag == alertView.tag) {
        //回到登陆页
        [(AppDelegate*)[UIApplication sharedApplication].delegate relogin];
    }
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
        [(AppDelegate*)[UIApplication sharedApplication].delegate relogin];
    }

}

- (void)alertViewWillPresent:(UIAlertController *)alertController
{
    UIViewController *mainVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    [mainVC presentViewController:alertController
                       animated:YES
                     completion:nil];
}



@end

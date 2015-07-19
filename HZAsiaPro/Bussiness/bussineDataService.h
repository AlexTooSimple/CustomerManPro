//
//  bussineDataService.h
//  
//
//  Created by Wu YouJian on 8/6/11.
//  Copyright 2011 asiainfo-linkage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "message_def.h"
#import "HttpStatus.h"
#import "HttpConnector.h"

#define kForceUpdateTag                 100   //
#define kLinkErrorTag                   101
#define kTimeOutErrorTag                102
#define kSessionTimeOutTag              103


@protocol HttpBackDelegate<NSObject>

@required
//key: bussineCode value :; Key:errorCode, value: key:MSG, value:
- (void)requestDidFinished:(NSDictionary*)info;
//key: bussineCode value :; Key:errorCode, value: key:MSG, value:
- (void)requestFailed:(NSDictionary*)info;

@optional
//点击超时或者连接错误提示上的取消按钮的回调接口
- (void)cancelTimeOutAndLinkError;
@end


@interface bussineDataService : NSObject <AlertShowViewDelegate, HttpStatus,UIAlertViewDelegate> {
	NSString *receiveString;
	
	NSDictionary *sendDataDic;
	NSString *sendString;
	NSDate *lastDate;
	NSDate *currentDate;
	
	id<HttpBackDelegate>  target;
    SEL sendMessageSelector;

#pragma mark - 系统的一些参数
    NSString  *updateUrl;
}

@property(nonatomic,assign)id<HttpBackDelegate>     target;
@property(nonatomic,assign)SEL sendMessageSelector;
@property(nonatomic,retain)NSString*		receiveString;
@property(nonatomic,retain)NSDictionary*	sendDataDic;
@property(nonatomic,retain)NSString*		sendString;
@property(nonatomic,retain)NSDate*			lastDate;
@property(nonatomic,retain)NSDate*			currentDate;

#pragma mark - 系统的一些参数
@property(nonatomic,retain)NSString*        updateUrl;

#pragma mark
#pragma mark - 公用方法
+(void)releaseBussineDataService;
+(bussineDataService*)sharedDataService;
-(id)init;
-(void)sendMessage:(id <MessageDelegate>)msg synchronously:(BOOL)isSynchronous;


#pragma mark
#pragma mark - 登录
- (void)login:(NSDictionary *)paramters;

#pragma mark
#pragma mark - 获取静态数据
- (void)getStaticData:(NSDictionary *)paramters;

#pragma mark
#pragma mark - 通过匹配条件获取客户列表
- (void)searchCustomerListWithCondition:(NSDictionary *)paramters;

#pragma mark
#pragma mark - 下载所有客户
- (void)uploadAllCustomer:(NSDictionary *)paramters;

#pragma mark
#pragma mark - 获取访问记录列表
- (void)getVisitHistoryList:(NSDictionary *)paramters;

#pragma mark
#pragma mark - 新增访问记录
- (void)addVisitHistory:(NSDictionary *)paramters;

#pragma mark
#pragma mark - 删除客户
- (void)deleteCustomer:(NSDictionary *)paramters;

#pragma mark
#pragma mark - 检查客户是否存在
- (void)checkCustomer:(NSDictionary *)paramters;

#pragma mark
#pragma mark - 新增客户
- (void)insertCustomer:(NSDictionary *)paramters;

#pragma mark
#pragma mark - 更新客户基本信息
- (void)updateCustomer:(NSDictionary *)paramters;

#pragma mark
#pragma mark - 更新用户基本信息
- (void)updateUser:(NSDictionary *)paramters;

#pragma mark
#pragma mark - 审批客户
- (void)approveClient:(NSDictionary *)paramters;

#pragma mark
#pragma mark - 搜索审批客户
- (void)searchApproveClientList:(NSDictionary *)paramters;

#pragma mark
#pragma mark - 获取历史修改记录
- (void)getModifyHistoryList:(NSDictionary *)paramters;

@end






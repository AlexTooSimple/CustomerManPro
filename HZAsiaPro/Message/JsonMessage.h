//
//  JsonMessage.h
//  HZAsiaPro
//
//  Created by wuhui on 15-3-11.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "message.h"

#define JSON_BODY_REUEST   @"com.ailk.ts.mapp.model.req.%@Request"

#define JSON_TEMP @"{\"@class\":\"com.ailk.ts.mapp.model.TSDatapackage\",\"header\":%@,\"body\":%@}"

#define JSON_HEADER @"\"@class\":\"com.ailk.ts.mapp.model.TSHeader\",\"bizCode\":\"%@\",\"identityId\":null,\"coordinates\":null,\"respCode\":null,\"respMsg\":null,\"mode\":null"


#define JSON_RESPCODE    @"respCode"
#define JSON_RESPMSG     @"respMsg"

@interface JsonMessage : message
{
    NSDictionary *jsonRspData;
}
@property(nonatomic, retain)NSDictionary *jsonRspData;

//公共解析部分
-(NSString*)getRspcode;
-(NSString*)getMSG;
//如果一个接口返回的报文只有第一级节点，可以调用此接口解析
//这样所有的数据都存储在：rspInfo中
-(void)parseRspcodeSubItemsToRspInfo;

- (void)parse:(NSString *)responseMessage;
//除了有第一级节点的报文，还有其他的报文，就必备重载这个函数
- (void)parseOther;
-(void)parseMessage;

-(NSString *)getJSONHeader:(NSDictionary *)headData;
-(NSString *)getRequestJSONFromHeader:(NSDictionary *)headDic withBody:(NSDictionary *)bodyDic;

@end

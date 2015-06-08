//
//  JsonMessage.m
//  HZAsiaPro
//
//  Created by wuhui on 15-3-11.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//
//  JSON 报文组装和解析

#import "JsonMessage.h"
#import <UIKit/UIKit.h>
#import "JSONKit.h"

@implementation JsonMessage
@synthesize jsonRspData;

-(id)init
{
    if (self = [super init])
    {
        self.isXML = NO;
    }
    return self;
}

-(void)dealloc
{
    if (jsonRspData != nil) {
        [jsonRspData release];
    }
    [super dealloc];
}

#pragma mark -
#pragma mark 解析返回报文内容
- (void)parseOther
{
}

-(void)parseMessage{
}

- (void)parse:(NSString *)responseMessage {
    if (nil != responseMessage) {
        NSData* responseData = [responseMessage dataUsingEncoding:NSUTF8StringEncoding];
        if (nil != responseData) {
            //解析应答报文
            UIDevice *currentDevice = [UIDevice currentDevice];
            NSMutableDictionary *dic = nil;
            if ([[[currentDevice systemVersion] substringToIndex:1] intValue] >= 5) {
                dic = [NSJSONSerialization JSONObjectWithData:responseData
                                                      options:NSJSONReadingMutableContainers
                                                        error:nil];
            }else{
                dic = [responseData objectFromJSONDataWithParseOptions:JKParseOptionValidFlags];
            }
            NSLog(@"dic=%@",dic);
            if (dic) {
                self.jsonRspData = dic;
                [self parseRspcodeSubItemsToRspInfo];
                [self parseOther];
            }
        }
    }
}

/*解析1级结构*/
-(void)parseRspcodeSubItemsToRspInfo
{
    NSDictionary *tempDict = [self.jsonRspData objectForKey:@"body"];
    self.rspInfo = tempDict;
}

- (NSString *)assembleJSONStringFromDictionary:(NSDictionary *)JSONDic
{
    NSData *JSONData = nil;
    UIDevice *currentDevice = [UIDevice currentDevice];
    NSString *systemVersion = currentDevice.systemVersion;
    if ([[systemVersion substringToIndex:1] integerValue] >= 5) {
        if ([NSJSONSerialization isValidJSONObject:JSONDic]) {
            NSError *error;
            JSONData = [NSJSONSerialization dataWithJSONObject:JSONDic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
        }
    }else{
        //使用JSONKit
        JSONData = [JSONDic JSONData];
    }
    NSString *JSONString = [[[NSString alloc] initWithData:JSONData
                                               encoding:NSUTF8StringEncoding] autorelease];
    return JSONString;
}

- (NSString *)getJSONHeader:(NSDictionary *)headData
{
    NSString *biz_Code = [headData objectForKey:@"bizCode"];
    self.bizCode = biz_Code;
    
    NSMutableDictionary *headCommonDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                   @"com.ailk.ts.mapp.model.TSHeader",@"@class",
                                   [NSNull null],@"identityId",
                                   [NSNull null],@"coordinates",
                                   [NSNull null],@"respCode",
                                   [NSNull null],@"respMsg",
                                   [NSNull null],@"mode",nil];
    [headCommonDic setValuesForKeysWithDictionary:headData];
    
    NSString *headerJSON = [self assembleJSONStringFromDictionary:headCommonDic];
    
    [headCommonDic release];
    return headerJSON;
}

- (NSString *)getRequestJSONFromHeader:(NSDictionary *)headDic withBody:(NSDictionary *)bodyDic
{
    //组装JSON header节点
    NSString *headJSON = [self getJSONHeader:headDic];
    
    //组装JSON body节点
    NSString *bodyJSON = [self assembleJSONStringFromDictionary:bodyDic];
    
    NSString *requestJSON = [NSString stringWithFormat:JSON_TEMP,headJSON,bodyJSON];
    
    return requestJSON;
}

-(NSString *)getRspcode
{
    if (self.jsonRspData == nil) {
        self.rspCode = @"6666";
        return self.rspCode;
    }
    
    NSDictionary *json_respon_header = [self.jsonRspData objectForKey:@"header"];
    if ([json_respon_header count] == 0) {
        self.rspCode = @"0010";
        return self.rspCode;
    }
    self.rspCode = [json_respon_header objectForKey:@"respCode"];
    return self.rspCode;
}

-(NSString *)getMSG
{   
    NSDictionary *json_respon_header = [self.jsonRspData objectForKey:@"header"];
    if (![[json_respon_header objectForKey:@"respMsg"] isEqual:[NSNull null]]) {
        self.rspDesc = [json_respon_header objectForKey:@"respMsg"];
    }else{
        self.rspDesc = nil;
    }
    
    return self.rspDesc;
}


@end

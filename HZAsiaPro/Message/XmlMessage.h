//
//  XmlMessage.h
//  HZAsiaPro
//
//  Created by wuhui on 15-3-11.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "message.h"
#import "GDataXMLNode.h"

//通用的解析XPATH
#define XML_ROOT                @"/Response/"
#define XML_RSPCODE             @"/Response/RspCode"
#define XML_MSG                 @"/Response/MSG"
#define XML_RSPCODE_SUBITEM     @"/Response/*"

//报文头模版
#define XML_HEAD_TEMPLATE    @"\
<?xml version=\"1.0\" encoding=\"UTF-8\"?>\
<MAPP>\
%@\
<SvcContent><![CDATA["

//报文正文
#define XML_BODY_TEMPLATE       @"<Request>%@</Request>"
//报文尾部
#define XML_TAIL                @"]]></SvcContent></MAPP>"

@interface XmlMessage : message
{
    GDataXMLDocument* doc;
}

@property(nonatomic, retain)GDataXMLDocument* doc;

// 建立 xml document
-(void)initXMLDocument:(NSData*)xmldata;

//公共解析部分
-(NSString*)getRspcode;
-(NSString*)getMSG;
//如果一个接口返回的报文只有第一级节点，可以调用此接口解析
//这样所有的数据都存储在：rspInfo中
-(void)parseRspcodeSubItemsToRspInfo;


-(void)parse:(NSString *)responseMessage;
//除了有第一级节点的报文，还有其他的报文，就必备重载这个函数
-(void)parseOther;
-(void)parseMessage;

//help
-(NSString*)getXmlStringFromDictionary:(NSDictionary*)dict;
-(NSString*)getXmlStringFromArray:(NSArray *)arr withNodeName:(NSString*)nodeName;
-(NSString*)getRequestXMLWithString:(NSDictionary *)headData
                           withBody:(NSDictionary *)body;
-(NSString*)getRequestXMLWithStringNoHeadData:(NSDictionary *)body;

@end

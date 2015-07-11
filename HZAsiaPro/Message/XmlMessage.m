//
//  XmlMessage.m
//  HZAsiaPro
//
//  Created by wuhui on 15-3-11.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "XmlMessage.h"

@implementation XmlMessage
@synthesize doc;

-(id)init{
    if (self = [super init]) {
        self.isXML = YES;
    }
    
    return self;
}

-(void)dealloc
{
    self.doc = nil;
    [super dealloc];
}


//key : string ; value: string
-(NSString*)getXmlStringFromDictionary:(NSDictionary*)dict
{
    if (dict == nil) {
        return @"";
    }
    
    NSMutableString *xmlString = [[[NSMutableString alloc] initWithCapacity:0] autorelease];
    NSArray *keys = [dict allKeys];
    
    for (int i=0; i<[dict count]; i++) {
        NSString *nodeNameSrc = [keys objectAtIndex:i];
        NSString* nodeValue = [dict objectForKey:nodeNameSrc];
        [xmlString appendFormat:@"<%@>%@</%@>",nodeNameSrc,nodeValue,nodeNameSrc];
    }
    
    return xmlString;
}

-(NSString*)getXmlStringFromArray:(NSArray *)arr withNodeName:(NSString*)nodeName{
    if (arr == nil) {
        return @"";
    }
    
    NSMutableString *xmlString=[[[NSMutableString alloc] initWithCapacity:0] autorelease];
    for (NSString* nodeValue in arr) {
        [xmlString appendFormat:@"<%@>%@</%@>",nodeName,nodeValue,nodeName];
    }
    
    return xmlString;
}

#pragma mark -
#pragma mark implementation
-(void)initXMLDocument:(NSData*)xmldata
{
    GDataXMLDocument* adoc = [[GDataXMLDocument alloc] initWithData:xmldata options:0 error:nil];
    self.doc = adoc;
    [adoc release];
}

//这一块数据，一般是各个接口公有的数据，子类可以传入一下变化的数据
-(NSString*)createXMLHead:(NSDictionary*)headData{
    NSString* headStr = nil;
    if (headData == nil || [headData count]== 0) {
        //拼接公共的参数
    }else{
        headStr = [self getXmlStringFromDictionary:headData];
    }
    NSString* headXml = [NSString stringWithFormat:XML_HEAD_TEMPLATE,headStr];
    return headXml;
}

-(NSString*)createXMLTail{
    return XML_TAIL;
}

-(NSString*)createXMLBodyWithDictionary:(NSDictionary *)body{
    if (body == nil || [body count] == 0) {
        return @"<Request></Request>";
    }
    
    NSString *createXMLbody = [self getXmlStringFromDictionary:body];
    NSString* bodyXml = [NSString stringWithFormat:XML_BODY_TEMPLATE,createXMLbody];
    return bodyXml;
}

-(NSString*)getRequestXMLWithString:(NSDictionary *)headData
                           withBody:(NSDictionary *)body
{
    NSString* xmlStr = nil;
    xmlStr = [NSString stringWithFormat:@"%@%@%@",
              [self createXMLHead:headData],
              [self createXMLBodyWithDictionary:body],
              [self createXMLTail]];
    
    NSLog(@"请求报文：%@",xmlStr);
    
    //可以进行加密
    return xmlStr;
}

-(NSString*)getRequestXMLWithStringNoHeadData:(NSDictionary *)body
{
    NSString* xmlStr = nil;
    xmlStr = [NSString stringWithFormat:@"%@%@%@",
              [self createXMLHead:nil],
              [self createXMLBodyWithDictionary:body],
              [self createXMLTail]];
    
    NSLog(@"请求报文：%@",xmlStr);
    
    //可以进行加密
    return xmlStr;
}


#pragma mark -
#pragma mark 解析返回报文内容
- (void)parseOther
{
    
}

-(void)parseMessage{
}

- (void)parse:(NSString *)responseMessage
{
    NSLog(@"应答报文：%@",responseMessage);
    if (nil != responseMessage) {
        NSData* responseData = [responseMessage dataUsingEncoding:NSUTF8StringEncoding];
        if (nil != responseData) {
            [self initXMLDocument:responseData];
            [self parseRspcodeSubItemsToRspInfo];
            [self parseOther];
        }
    }
}

/*解析1级结构*/
-(void)parseRspcodeSubItemsToRspInfo{
    NSMutableDictionary* tempDict = [[NSMutableDictionary alloc] initWithCapacity:1];
    NSMutableString* path = [[NSMutableString alloc] initWithCapacity:1];
    
    [path setString:[NSMutableString stringWithFormat:@"%@",XML_RSPCODE_SUBITEM]];
    NSArray* elements = [doc nodesForXPath:path error:nil];
    for (int i = 0; i < [elements count]; i++) {
        GDataXMLElement* element = [elements objectAtIndex:i];
        if ([element childCount]>1)
            continue;
        
        if ([element stringValue] && [element name])
            [tempDict setObject:[element stringValue] forKey:[element name]];
    }
    
    self.rspInfo = tempDict;
    [tempDict release];
    [path release];
}


-(NSString *)getRspcode
{
    if (self.doc == nil) {
        self.rspCode = @"6666";
        return self.rspCode;
    }
    
    NSString* tempPath = XML_RSPCODE;
    NSArray* elements = [self.doc nodesForXPath:tempPath error:nil];
    
    if ([elements count] == 0 || elements == nil) {
        self.rspCode = @"0010";
        return self.rspCode;
    }
    GDataXMLElement* element = [elements objectAtIndex:0];
    self.rspCode = [element stringValue];
    return self.rspCode;
}

-(NSString*)getMSG
{   
    NSString* tempPath = XML_MSG;	
    NSArray* elements = [self.doc nodesForXPath:tempPath error:nil];
    
    if ([elements count] == 0 || elements == nil) {
        return nil;
    }
    GDataXMLElement* element = [elements objectAtIndex:0];
    
    self.rspDesc = [element stringValue];
    return self.rspDesc;
}

@end

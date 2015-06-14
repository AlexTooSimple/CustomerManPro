//
//  NSDate-Helper.h
//  SaleToolsKit
//
//  Created by chengdonghai on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate(Helper)
- (NSString *)getFormatYearMonthDay;
- (int )getWeekNumOfMonth;
- (int )getWeekOfYear;
- (NSDate *)dateAfterDay:(int)day;
- (NSDate *)dateafterMonth:(int)month;
- (NSUInteger)getDay;
- (NSUInteger)getMonth;
- (NSUInteger)getYear;
- (int )getHour;
- (int)getMinute;
- (int )getHour:(NSDate *)date ;
- (NSDate *)endOfMonth;
- (NSDate *)beginningOfMonth;
- (NSDate *)endOfWeek;
- (NSString *)stringDaysAgoAgainstMidnight:(BOOL)flag;
+ (NSString *)dbFormatString;
- (NSString *)string ;
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;
- (NSString *)stringWithFormat:(NSString *)format ;

@end

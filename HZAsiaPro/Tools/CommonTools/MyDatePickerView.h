//
//  MyDatepinkc.h
//  SaleToolsKit
//
//  Created by 宏涛 庞 on 12-4-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MyDatePickerViewDelegate;
@interface MyDatePickerView : UIView
{
    UIDatePicker *datePicker;
    id<MyDatePickerViewDelegate> delegate;
    CGRect openRect;
    CGRect closeRect;
    BOOL isShow;
    int myTag;
}
@property(nonatomic,retain) UIDatePicker *datePicker;
@property(nonatomic,retain) id<MyDatePickerViewDelegate> delegate;
@property(nonatomic,assign) BOOL isShow;
@property(nonatomic,assign) int myTag;
-(void)setMaxDate:(NSDate *)maxDate;
-(void)setMinDate:(NSDate *)minDate;
-(void)setDateMode:(UIDatePickerMode)pickerMode;
-(void)show;
-(void)dismiss;
@end
@protocol MyDatePickerViewDelegate <NSObject>
@optional
-(void)clickMyDatePickerViewOk:(NSString*)selectedDate;
-(void)clickMyDatePickerViewCancel;
-(void)viewDidShow:(MyDatePickerView*)selfview;
-(void)viewDidDismiss;
@end
//
//  MyDataPickerView.m
//  SaleToolsKit
//
//  Created by 宏涛 庞 on 12-4-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyDatePickerView.h"
#import "NSDate-Helper.h"

@implementation MyDatePickerView
@synthesize datePicker;
@synthesize delegate;
@synthesize isShow;
@synthesize myTag;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        openRect = frame;
        closeRect = CGRectMake(openRect.origin.x, DEVICE_MAINSCREEN_HEIGHT, openRect.size.width, openRect.size.height);
        self.frame = closeRect;
        isShow = NO;
        float y = 44;
        float width = frame.size.width;
        float height = frame.size.height;
        [self setBackgroundColor:[UIColor clearColor]];
        
        datePicker=[[UIDatePicker alloc] initWithFrame:CGRectMake(0,y, width, height)];
        datePicker.date = [NSDate date];
        [datePicker setBackgroundColor:[UIColor whiteColor]];
        [datePicker setDatePickerMode:UIDatePickerModeDate];
        [self addSubview:datePicker];
        
        UINavigationBar *nav=[[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, width, y)];
        nav.barStyle = UIBarStyleBlack;
        UINavigationItem *item=[[UINavigationItem alloc] init];
        
        UIBarButtonItem *btnOK = [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(clickSubmit)];
        
        UIBarButtonItem *btnCancel= [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                     style:UIBarButtonItemStyleDone
                                                                    target:self
                                                                    action:@selector(clickCancel)];
        item.rightBarButtonItem=btnOK;
        item.leftBarButtonItem=btnCancel;
        
        [btnOK release];
        [btnCancel release];
        
        [nav pushNavigationItem:item animated:YES];
        [item release];
        [self addSubview:nav];
        [nav release];
    }
    return self;
}

-(void)setDateMode:(UIDatePickerMode)pickerMode
{
    self.datePicker.datePickerMode = pickerMode;
}

-(void)setMaxDate:(NSDate *)maxDate
{
    if (maxDate != nil) {
        datePicker.maximumDate = maxDate;
    }else{
        datePicker.maximumDate = [NSDate date];
    }
    
}

-(void)setMinDate:(NSDate *)minDate
{
    if (minDate != nil) {
        datePicker.minimumDate = minDate;
    }else{
        if (self.datePicker.datePickerMode == UIDatePickerModeDate) {
            unsigned int yyyy = 1900;
            unsigned int mm = 1;
            unsigned int dd = 1;
            NSDate *valiteData = [NSDate dateFromString:[NSString stringWithFormat:@"%d-%02d-%02d",yyyy,mm,dd]
                                             withFormat:@"yyyy-MM-dd"];
            datePicker.minimumDate = valiteData;
        }
    }
    
}
-(void)clickSubmit
{
    [self dismiss];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    if (self.datePicker.datePickerMode == UIDatePickerModeTime) {
        [df setDateFormat:@"hh:mm:ss"];
    }else if(self.datePicker.datePickerMode == UIDatePickerModeDate){
        [df setDateFormat:@"yyyy-MM-dd"];
    }
    

    NSString *s = [df stringFromDate:[self.datePicker date]];
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickMyDatePickerViewOk:)]) {
        [self.delegate clickMyDatePickerViewOk:s];
    }
    [df release];
}

-(void)clickCancel
{
    [self dismiss];
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickMyDatePickerViewCancel)]) {
        [self.delegate clickMyDatePickerViewCancel];
    }
}

-(void)show
{
    if (isShow == NO) {
        self.isShow = YES;
        [UIView beginAnimations:@"showPicker" context:nil];
        [UIView setAnimationDuration:0.4f];
        self.frame=openRect;
        [UIView commitAnimations];
        
        if (delegate && [delegate respondsToSelector:@selector(viewDidShow:)]) {
            [delegate viewDidShow:self];
        }
    }
}
-(void)dismiss
{
    if (isShow == YES) {
        self.isShow = NO;
        [UIView beginAnimations:@"showPicker" context:nil];
        [UIView setAnimationDuration:0.4f];
        self.frame=closeRect;
        [UIView commitAnimations];
        if (delegate && [delegate respondsToSelector:@selector(viewDidDismiss)]) {
            [delegate viewDidDismiss];
        }
    }
}

- (void)dealloc {
    [datePicker release];
    [super dealloc];
}
@end

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
@synthesize dateFomarter;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dateFomarter = NSLocalizedString(@"Date_Format", nil);
        
        openRect = frame;
        closeRect = CGRectMake(openRect.origin.x, APP_BASE_HEIGHT-20-44, openRect.size.width, openRect.size.height);
        self.frame = closeRect;
        isShow = NO;
        float y = 44;
        float width = frame.size.width;
        float height = frame.size.height;
        [self setBackgroundColor:[UIColor clearColor]];
        
        datePicker=[[UIDatePicker alloc] initWithFrame:CGRectMake(0,y, width, height)];
        datePicker.date = [NSDate date];
//        datePicker.maximumDate = [NSDate date];
        [datePicker setDatePickerMode:UIDatePickerModeDate];
        [datePicker setBackgroundColor:[UIColor whiteColor]];
        [datePicker setDatePickerMode:UIDatePickerModeDate];
        [self addSubview:datePicker];
        
        UINavigationBar *nav=[[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, width, y)];
       // nav.translucent = YES;
        nav.barStyle = UIBarStyleBlack;
        UINavigationItem *item=[[UINavigationItem alloc] init];
        //[nav setBackgroundColor:[UIColor redColor]];
        
        
        UIBarButtonItem *btnOK = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Sale_Confirm_String", nil)
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(clickSubmit)];
        int version = ((AppDelegate*)[UIApplication sharedApplication].delegate).systemVersion;
        if(4 < version){
            //btnOK.tintColor = [UIColor redColor];
        }
        
//        UIBarButtonItem *btnCancel= [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Sale_Cancel_String", nil)
//                                                                     style:UIBarButtonItemStyleDone
//                                                                    target:self
//                                                                    action:@selector(clickCancel)];
        
        UIBarButtonItem *btnCancel= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(clickCancel)];
       // [btnCancel setTag:TAG_BTN_CANCEL];
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
        NSInteger yyyy = 1900;
        NSInteger mm = 1;
        NSInteger dd = 1;
        NSDate *valiteData = [NSDate dateFromString:[NSString stringWithFormat:@"%d-%02d-%02d",yyyy,mm,dd]
                                         withFormat:@"yyyy-MM-dd"];
        datePicker.minimumDate = valiteData;
    }
    
}
-(void)clickSubmit
{
    [self dismiss];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    if (dateFomarter == nil || [@"" isEqualToString:dateFomarter]) {
        [df setDateFormat:@"dd/MM/yyyy"];
    } else {
        [df setDateFormat:dateFomarter];
    }
    

    NSString *s = [df stringFromDate:[self.datePicker date]];
    NSLog(@"Date:%@",s);
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
    [dateFomarter release];
    [super dealloc];
}
@end

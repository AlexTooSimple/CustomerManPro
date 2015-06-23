//
//  AddCustomerView.h
//  HZAsiaPro
//
//  Created by wuhui on 15/6/16.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertShowView.h"

#define CUSTOMER_TEXTFIELD_TYPE         @"1"
#define CUSTOMER_SELECT_TYPE            @"2"
#define CUSTOMER_DATE_SELECT_TYPE       @"3"
#define CUSTOMER_TIME_SELECT_TYPE       @"4"
#define CUSTOMER_TEXTVIEW_TYPE          @"5"


#define PLUS_CUSTOMER_TITLE             @"title"
#define PLUS_CUSTOMER_TYPE              @"type"
#define PLUS_SELECT_DATA_SOURCE         @"source"
#define PLUS_INIT_VALUE                 @"initValue"
#define PLUS_VALUE_IS_PUT_FORCE         @"forceInput"


#define PUT_FORCE_YES                   @"1"
#define PUT_FORCE_NO                    @"0"

@protocol AddCustomerViewDelegate;
@interface AddCustomerView : UIView<UITextFieldDelegate,
                                    UIGestureRecognizerDelegate,
                                    UITextViewDelegate,
                                    AlertShowViewDelegate>
{
    UIScrollView *contentTable;
    NSMutableArray  *itemShowList;

    id<AddCustomerViewDelegate> delegate;
    
    CGFloat changeFieldY;
    
    BOOL isShowHeader;
    NSString *headerTitle;
    CGFloat sectionHei;
    
    NSInteger selectViewRow;
    
    CGFloat initContentY;
}
@property (nonatomic ,retain)UIScrollView *contentTable;
@property (nonatomic ,retain)NSMutableArray *itemShowList;
@property (nonatomic ,assign)id<AddCustomerViewDelegate> delegate;
@property (nonatomic ,assign)CGFloat changeFieldY;
@property (nonatomic ,assign)CGFloat sectionHei;
@property (nonatomic ,assign)BOOL isShowHeader;
@property (nonatomic ,retain)NSString *headerTitle;
@property (nonatomic ,assign)NSInteger selectViewRow;
@property (nonatomic ,assign)CGFloat initContentY;

- (void)reloadCustomerView:(NSMutableArray *)itemDatas WithShowSection:(NSString *)sectionTitle;
- (NSDictionary *)commitGetAllCustomerData;

- (void)reloadViewDataWithSelectRow:(NSInteger)row;
- (void)reloadViewDataSelectDate:(NSString *)selectDate;
@end


@protocol AddCustomerViewDelegate <NSObject>
- (void)customerView:(AddCustomerView *)addCustomerView DidShowItemPickerWithRow:(NSInteger)row WithSource:(NSArray *)sourceList;
- (void)customerView:(AddCustomerView *)addCustomerView DidShowDate:(UIDatePickerMode )pickerMode;
- (void)customerViewDidShowTextField:(AddCustomerView *)addCustomerView;
- (void)customerViewDidShowAlertView:(UIAlertController *)alertController;
@end


//
//  CustomerListView.h
//  HZAsiaPro
//
//  Created by wuhui on 15/6/9.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshSingleView.h"
#import "ActionSheetView.h"

#define CUSTOMER_DIC_NAME_KEY           @"cname"
#define CUSTOMER_DIC_PHONE_KEY          @"mobile"

@protocol CustomerListViewDelegate;

@interface CustomerListView : UIView<RefreshSingleViewDataSource,
                                     RefreshSingleViewDelegate,
                                     ActionSheetViewDelegate>
{
    RefreshSingleView *contentTable;
    NSArray  *customerList;
    
    NSInteger selectRow;
    
    id<CustomerListViewDelegate> delegate;
}
@property(nonatomic ,assign)id<CustomerListViewDelegate> delegate;
@property(nonatomic ,retain)RefreshSingleView *contentTable;
@property(nonatomic ,retain)NSArray *customerList;

- (void)reloadData:(NSArray *)itemData;
@end


@protocol CustomerListViewDelegate <NSObject>
- (void)customerListView:(CustomerListView *)listView didSelectRow:(NSInteger) row;
- (void)customerDidSendSMS:(NSArray *)phoneList;
@end

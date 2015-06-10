//
//  CustomerListView.h
//  HZAsiaPro
//
//  Created by wuhui on 15/6/9.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CUSTOMER_DIC_NAME_KEY           @"name"
#define CUSTOMER_DIC_PHONE_KEY          @"phone"

@protocol CustomerListViewDelegate;

@interface CustomerListView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *contentTable;
    NSArray  *customerList;
    
    id<CustomerListViewDelegate> delegate;
}
@property(nonatomic ,assign)id<CustomerListViewDelegate> delegate;
@property(nonatomic ,retain)UITableView *contentTable;
@property(nonatomic ,retain)NSArray *customerList;
@end


@protocol CustomerListViewDelegate <NSObject>
- (void)customerListView:(CustomerListView *)listView didSelectRow:(NSInteger) row;
@end

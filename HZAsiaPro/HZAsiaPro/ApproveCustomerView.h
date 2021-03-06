//
//  ApproveCustomerView.h
//  HZAsiaPro
//
//  Created by wuhui on 15/6/29.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ApproveCustomerViewDelegate;
@interface ApproveCustomerView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *contentTable;
    NSMutableArray *itemList;
    id<ApproveCustomerViewDelegate> delegate;
    
    BOOL *approves;
}
@property (nonatomic ,retain)UITableView *contentTable;
@property (nonatomic ,retain)NSMutableArray *itemList;
@property (nonatomic ,assign)id<ApproveCustomerViewDelegate> delegate;

- (void)reloadDataView:(NSArray *)itemDatas;
- (void)resetRowCell:(NSInteger)row;
@end

@protocol ApproveCustomerViewDelegate <NSObject>
- (void)approveView:(ApproveCustomerView *)approveView didShowApproveDetail:(NSInteger) row;
- (void)approveView:(ApproveCustomerView *)approveView didClickedApprove:(NSInteger)row;
- (void)approveView:(ApproveCustomerView *)approveView didDeleteApprove:(NSInteger)row;
@end

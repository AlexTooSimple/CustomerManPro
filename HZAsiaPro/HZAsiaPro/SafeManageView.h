//
//  SafeManageView.h
//  HZAsiaPro
//
//  Created by wuhui on 15/6/23.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SafeManageViewDelegate;
@interface SafeManageView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *contentTable;
    NSArray *itemList;
    
    id<SafeManageViewDelegate> delegate;
}
@property (nonatomic ,retain)UITableView *contentTable;
@property (nonatomic ,retain)NSArray *itemList;
@property (nonatomic ,assign)id<SafeManageViewDelegate> delegate;

- (void)reloadViewData:(NSArray *)itemData;

@end

@protocol SafeManageViewDelegate <NSObject>
- (void)safeManageView:(SafeManageView *)safeView didSelectRow:(NSInteger)row;
@end


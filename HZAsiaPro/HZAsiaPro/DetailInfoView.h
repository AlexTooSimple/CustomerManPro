//
//  DetailInfoView.h
//  HZAsiaPro
//
//  Created by wuhui on 15/6/12.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailInfoView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *contentTable;
    NSArray *itemDatas;
}
@property (nonatomic ,retain)NSArray *itemDatas;
@property (nonatomic ,retain)UITableView *contentTable;

- (void)reloadViewData:(NSArray *)itemList;

@end

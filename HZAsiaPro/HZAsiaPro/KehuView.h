//
//  KehuView.h
//  HZAsiaPro
//
//  Created by apple on 15/6/11.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KehuView : UIView<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property(nonatomic,strong)NSMutableArray *tabMArr;
@property(nonatomic,strong)UITableView *tbvHome;
@property(nonatomic,strong)UISearchBar *scbHome;

- (void)reloadView;

@end

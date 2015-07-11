//
//  UserView.h
//  HZAsiaPro
//
//  Created by apple on 15/6/11.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserView : UIView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSMutableDictionary *tabMDic;
@property(nonatomic,strong)UITableView *tbvHome;

- (void)reloadView;

@end

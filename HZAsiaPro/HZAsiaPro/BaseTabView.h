//
//  BaseTabView.h
//  HZAsiaPro
//
//  Created by 颜梁坚 on 15/7/10.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTabView : UIView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSMutableDictionary *tabMDic;
@property(nonatomic,strong)UITableView *tbvHome;

- (void)reloadView;

@end

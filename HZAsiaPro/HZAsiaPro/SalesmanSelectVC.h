//
//  SalesmanSelectVC.h
//  HZAsiaPro
//
//  Created by 颜梁坚 on 15/7/10.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^tapBlock)(id);

@interface SalesmanSelectVC : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSMutableArray *tabMArr;
@property(nonatomic,strong)UITableView *tbvSaleMan;
@property(nonatomic,strong)NSMutableArray *selectMArr;

@property(copy, nonatomic) tapBlock tapBlk;

@end

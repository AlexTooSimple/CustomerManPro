//
//  ManageView.h
//  HZAsiaPro
//
//  Created by 颜梁坚 on 15/7/11.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bussineDataService.h"

typedef void(^tapBlock)(id);

@interface ManageView : UIView<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,HttpBackDelegate>

@property(nonatomic,strong)NSMutableArray *tabMArr;
@property(nonatomic,strong)NSMutableArray *searchMArr;
@property(nonatomic,strong)UITableView *tbvHome;
@property(nonatomic,strong)UISearchBar *scbHome;
@property(nonatomic,strong)NSMutableArray *allUserMarr;
@property(nonatomic,strong)NSMutableArray *removeMarr;
@property(copy, nonatomic) tapBlock tapBlk;
@property(copy, nonatomic) tapBlock btnTapBlk;

- (void)reloadView;

@end

//
//  KehuView.h
//  HZAsiaPro
//
//  Created by apple on 15/6/11.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionSheetView.h"

typedef void(^tapBlock)(id);

@interface KehuView : UIView<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,ActionSheetViewDelegate>{
    NSInteger selectRow;
}

@property(nonatomic,strong)NSMutableArray *tabMArr;
@property(nonatomic,strong)NSMutableArray *searchMArr;
@property(nonatomic,strong)UITableView *tbvHome;
@property(nonatomic,strong)UISearchBar *scbHome;
@property(copy, nonatomic) tapBlock tapBlk;
@property(copy, nonatomic) tapBlock messageBlk;

- (void)reloadView;

@end

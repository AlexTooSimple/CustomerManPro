//
//  AccountManageVC.h
//  HZAsiaPro
//
//  Created by 颜梁坚 on 15/6/29.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bussineDataService.h"

@interface AccountManageVC : UIViewController<UITableViewDelegate,UITableViewDataSource,HttpBackDelegate>

@property (nonatomic,strong)UITableView *tbvAccount;

@end

//
//  HomePageSetVC.h
//  HZAsiaPro
//
//  Created by 颜梁坚 on 15/6/25.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePageSetVC : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *tbvHomePageSet;
@property (nonatomic,strong)NSMutableArray *tbvMArr;

@end

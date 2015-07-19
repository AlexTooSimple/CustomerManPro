//
//  QueryClientVC.m
//  HZAsiaPro
//
//  Created by wuhui on 15/7/19.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "QueryClientVC.h"

@interface QueryClientVC ()

@end

@implementation QueryClientVC

- (void)loadView
{
    CGRect frame = [UIScreen mainScreen].bounds;
    UIView *rootView = [[UIView alloc] initWithFrame:frame];
    rootView.backgroundColor = [UIColor whiteColor];
    self.view = rootView;
    [rootView release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"搜索客户";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

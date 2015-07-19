//
//  ShowHistoryVC.m
//  HZAsiaPro
//
//  Created by wuhui on 15/7/19.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "ShowHistoryVC.h"

@interface ShowHistoryVC ()

@end

@implementation ShowHistoryVC

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
    self.title = @"历史修改记录";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

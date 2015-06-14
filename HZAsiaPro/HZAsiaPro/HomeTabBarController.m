//
//  HomeTabBarController.m
//  HZAsiaPro
//
//  Created by wuhui on 15/6/8.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "HomeTabBarController.h"
#import "HomeInfoVC.h"
#import "CustomerManageVC.h"
#import "SafeManageVC.h"
#import "SearchConditionVC.h"
#import "ICSDrawerController.h"
#import "ModelCustomerNavVC.h"
#import "ModelConditionNavVC.h"

@interface HomeTabBarController ()
@end

@implementation HomeTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    NSDictionary *NavTitleAttribute = [[NSDictionary alloc] initWithObjectsAndKeys:
                                       [UIColor whiteColor],NSForegroundColorAttributeName, nil];
    
    //首页提醒页面
    HomeInfoVC *homeVC = [[HomeInfoVC alloc] init];
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:homeVC];
    homeNav.navigationBar.barTintColor = [UIColor blackColor];
    homeNav.navigationBar.titleTextAttributes = NavTitleAttribute;
    [homeVC release];
    
    //客户管理页面
    CustomerManageVC *customerVC = [[CustomerManageVC alloc] init];
    SearchConditionVC *conditionVC = [[SearchConditionVC alloc] init];
    
    ModelCustomerNavVC *customerNav = [[ModelCustomerNavVC alloc] initWithRootViewController:customerVC];
    customerNav.navigationBar.barTintColor = [UIColor blackColor];
    customerNav.navigationBar.titleTextAttributes = NavTitleAttribute;
    
    ModelConditionNavVC *coditionNav = [[ModelConditionNavVC alloc] initWithRootViewController:conditionVC];
    coditionNav.navigationBar.barTintColor = [UIColor blackColor];
    coditionNav.navigationBar.titleTextAttributes = NavTitleAttribute;
    
    ICSDrawerController *drawer = [[ICSDrawerController alloc] initWithLeftViewController:coditionNav
                                                                     centerViewController:customerNav];
    [customerVC release];
    [conditionVC release];
    [customerNav release];
    [coditionNav release];
    
    //安全管理页面
    SafeManageVC *safeVC = [[SafeManageVC alloc] init];
    UINavigationController *safeNav = [[UINavigationController alloc] initWithRootViewController:safeVC];
    safeNav.navigationBar.barTintColor = [UIColor blackColor];
    safeNav.navigationBar.titleTextAttributes = NavTitleAttribute;
    [safeVC release];
    
    NSArray *controllers = [[NSArray alloc] initWithObjects:homeNav,drawer,safeNav, nil];
    
    [homeNav release];
    [drawer release];
    [safeNav release];
    
    [NavTitleAttribute release];
    
    [self setViewControllers:controllers animated:YES];
    [controllers release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

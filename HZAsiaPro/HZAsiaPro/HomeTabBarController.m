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
    
    self.tabBar.barTintColor = [UIColor blackColor];
    self.tabBar.tintColor = [UIColor whiteColor];
//    [self setTabBarList];
}

- (void)setTabBarList
{
    NSMutableArray *itemList = [[NSMutableArray alloc] initWithCapacity:0];
    NSInteger cnt = 3;
    for (int i=0; i<cnt; i++) {
        UITabBarItem *oneItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts
                                                                           tag:0];
        [itemList addObject:oneItem];
        [oneItem release];
    }
    
    self.tabBar.barTintColor = [UIColor blackColor];
    [self.tabBar setItems:itemList animated:YES];
    [itemList release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

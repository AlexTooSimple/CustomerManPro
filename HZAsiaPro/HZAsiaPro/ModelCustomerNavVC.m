//
//  ModelCustomerNavVC.m
//  HZAsiaPro
//
//  Created by wuhui on 15/6/14.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "ModelCustomerNavVC.h"

@interface ModelCustomerNavVC ()

@end

@implementation ModelCustomerNavVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(responseNotification)
                                                 name:CUSTOMER_DRAWER_NOTIFATION
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)responseNotification
{
    [self.drawer open];
}

#pragma mark
#pragma mark - ICSDrawerControllerPresenting
- (void)drawerControllerWillOpen:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = NO;
}

- (void)drawerControllerDidClose:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = YES;
}



@end

//
//  ModelConditionNavVC.m
//  HZAsiaPro
//
//  Created by wuhui on 15/6/14.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "ModelConditionNavVC.h"
#import "SearchConditionVC.h"

@interface ModelConditionNavVC ()

@end

@implementation ModelConditionNavVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark
#pragma mark - ICSDrawerControllerPresenting
- (void)drawerControllerWillOpen:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = NO;
}

- (void)drawerControllerDidOpen:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = YES;
}

- (void)drawerControllerWillClose:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = NO;
    if ([(SearchConditionVC *)self.visibleViewController respondsToSelector:@selector(closeConditionViewResponse)]) {
        [(SearchConditionVC *)self.visibleViewController performSelector:@selector(closeConditionViewResponse)];
    }
}

- (void)drawerControllerDidClose:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = YES;
}


@end

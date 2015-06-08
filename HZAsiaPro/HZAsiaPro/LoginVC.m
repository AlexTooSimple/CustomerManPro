//
//  LoginVC.m
//  HZAsiaPro
//
//  Created by wuhui on 15-3-4.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "LoginVC.h"
#import "LoginView.h"
#import "bussineDataService.h"

@interface LoginVC ()<LoginViewDelegate>

@end

@implementation LoginVC

- (void)loadView
{
    CGRect mainFrame = [UIScreen mainScreen].bounds;
    UIView *rootView = [[UIView alloc] initWithFrame:mainFrame];
    rootView.backgroundColor = [UIColor clearColor];
    self.view = rootView;
    [rootView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    LoginView *loginView = [[LoginView alloc] init];
    loginView.delegate = self;
    loginView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    loginView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:loginView];
    [loginView release];
}

- (void)didReceiveMemoryWarning
{
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
#pragma mark - LoginViewDelegate
- (void)loginWithUserName:(NSString *)userName Passwd:(NSString *)passWd
{
    NSDictionary *paramer = [[NSDictionary alloc] initWithObjectsAndKeys:
                             userName,@"UserName",
                             passWd,@"PassWd",nil];
    
    bussineDataService *bussineService = [bussineDataService sharedDataService];
    [bussineService login:paramer];
    [paramer release];
}
@end

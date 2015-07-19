//
//  SafeManageVC.m
//  HZAsiaPro
//
//  Created by wuhui on 15/6/8.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "SafeManageVC.h"
#import "SafeManageView.h"
#import "HomePageSetVC.h"
#import "AccountManageVC.h"
#import "ApproveCustomerVC.h"
#import "AutoCustomVC.h"

@interface SafeManageVC ()<SafeManageViewDelegate>
{
    SafeManageView *safeView;
}
@property (nonatomic ,retain)SafeManageView *safeView;
@property (nonatomic ,strong)NSMutableArray *itemArr;
@end

@implementation SafeManageVC

@synthesize safeView;

- (void)dealloc
{
    [safeView release];
    [self.itemArr release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initData];
}

- (void)loadView
{
    CGRect frame = [UIScreen mainScreen].bounds;
    UIView *rootView = [[UIView alloc] initWithFrame:frame];
    rootView.backgroundColor = [UIColor clearColor];
    self.view = rootView;
    [rootView release];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"安全管理";
    
    SafeManageView *safeManView = [[SafeManageView alloc] initWithFrame:CGRectZero];
    safeManView.backgroundColor = [UIColor whiteColor];
    safeManView.delegate = self;
    self.safeView = safeManView;
    [self.view addSubview:safeManView];
    [safeManView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.equalTo(self.view);
    }];
    [safeManView release];
    self.itemArr = [[NSMutableArray alloc] initWithCapacity:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData
{
    [self.itemArr removeAllObjects];
    //一旦设置用户权限，可以相应修改下列数组
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:CUSTOMER_DATA_BASE_DB];
    NSDictionary *usrInfo = [store getObjectById:CUSTOMER_USERINFO
                                       fromTable:CUSTOMER_DB_TABLE];
    NSNumber *isadmin = [usrInfo objectForKey:@"isadmin"];
    [self.itemArr addObject:@"调整账号权限并绑定手机号"];
    [self.itemArr addObject:@"设定首页提醒内容"];
    if ([isadmin integerValue] == PRO_MANAGER_LIMIT) {
        [self.itemArr addObject:@"管理客户池"];
        [self.itemArr addObject:@"审批客户上报"];
        [self.itemArr addObject:@"查看客户历史修改记录"];
    }
    
    [self.safeView reloadViewData:self.itemArr];
}

#pragma mark
#pragma mark - SafeManageViewDelegate
- (void)safeManageView:(SafeManageView *)safeView didSelectRow:(NSInteger)row
{
    NSString *TitleString = [self.itemArr objectAtIndex:row];
    if ([TitleString isEqualToString:@"调整账号权限并绑定手机号"]) {
        AccountManageVC *accountVC = [[AccountManageVC alloc] init];
        accountVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:accountVC animated:YES];
        [accountVC release];
    } else if ([TitleString isEqualToString:@"设定首页提醒内容"]) {
        HomePageSetVC *setVC = [[HomePageSetVC alloc] init];
        setVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:setVC animated:YES];
        [setVC release];
    } else if ([TitleString isEqualToString:@"管理客户池"]) {
        AutoCustomVC *custVC = [[AutoCustomVC alloc] init];
        custVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:custVC animated:YES];
        [custVC release];
    } else if ([TitleString isEqualToString:@"审批客户上报"]) {
        ApproveCustomerVC *approveVC = [[ApproveCustomerVC alloc] init];
        approveVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:approveVC animated:YES];
        [approveVC release];
    } else if ([TitleString isEqualToString:@"查看客户历史修改记录"]) {
        
    }
}
@end

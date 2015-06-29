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

@interface SafeManageVC ()<SafeManageViewDelegate>
{
    SafeManageView *safeView;
}
@property (nonatomic ,retain)SafeManageView *safeView;
@end

@implementation SafeManageVC

@synthesize safeView;

- (void)dealloc
{
    [safeView release];
    
    [super dealloc];
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
    
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData
{
    //一旦设置用户权限，可以相应修改下列数组
    NSArray *itemDatas = [[NSArray alloc] initWithObjects:
                          @"调整账号权限并绑定手机号",
                          @"设定首页提醒内容",
                          @"管理客户池",
                          @"审批客户上报",
                          @"查看客户历史修改记录",nil];
    [self.safeView reloadViewData:itemDatas];
    [itemDatas release];
}

#pragma mark
#pragma mark - SafeManageViewDelegate
- (void)safeManageView:(SafeManageView *)safeView didSelectRow:(NSInteger)row
{
    switch (row) {
        case 0:
        {
            //@"调整账号权限并绑定手机号"
            AccountManageVC *accountVC = [[AccountManageVC alloc] init];
            accountVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:accountVC animated:YES];
            [accountVC release];
        }
            break;
        case 1:
        {
            //@"设定首页提醒内容"
            HomePageSetVC *setVC = [[HomePageSetVC alloc] init];
            setVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:setVC animated:YES];
            [setVC release];
        }
            break;
        case 2:
        {
            //@"管理客户池"
        }
            break;
        case 3:
        {
            //@"审批客户上报"
        }
            break;
        case 4:
        {
            //@"查看客户历史修改记录"
        }
            break;
        case 5:
        {
        
        }
            break;
        default:
            break;
    }
}

@end

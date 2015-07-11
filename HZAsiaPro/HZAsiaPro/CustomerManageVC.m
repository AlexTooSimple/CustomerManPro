//
//  CustomerManageVC.m
//  HZAsiaPro
//
//  Created by wuhui on 15/6/8.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "CustomerManageVC.h"
#import "CustomerListView.h"
#import "DetailInfoVC.h"
#import "VerifyCustomerVC.h"
#import <MessageUI/MessageUI.h>
#import "AlertShowView.h"
#import "bussineDataService.h"

@interface CustomerManageVC ()<CustomerListViewDelegate,
                              MFMessageComposeViewControllerDelegate,
                              HttpBackDelegate>
@property (nonatomic, retain)CustomerListView *customerView;
@property (nonatomic, retain)NSArray *customerDataList;
@end

@implementation CustomerManageVC

@synthesize customerView;
@synthesize customerDataList;

- (void)dealloc
{
    if (customerDataList != nil) {
        [customerDataList release];
    }
    if (customerView != nil) {
        [customerView release];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:CUSTOMER_VC_SEARCH_DONE_NOTIFATION
                                                  object:nil];
    
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

    self.title = @"客户管理";
    
    [self setNavBarSearchItem];
    [self setNavBarInsertItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(searchCustomer:)
                                                 name:CUSTOMER_VC_SEARCH_DONE_NOTIFATION
                                               object:nil];
    
    CustomerListView *listView = [[CustomerListView alloc] init];
    listView.backgroundColor = [UIColor whiteColor];
    listView.delegate = self;
    self.customerView = listView;
    [self.view addSubview:customerView];
    
    [listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, DEVICE_TABBAR_HEIGTH, 0));
    }];
    
    [customerView release];
    
    [NSTimer scheduledTimerWithTimeInterval:0.01f
                                     target:self
                                   selector:@selector(searchSimpleCustomer)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNavBarInsertItem
{
    UIButton *insertBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    insertBtn.frame = CGRectMake(0, 0, 20.0f, 20.0f);
    [insertBtn setBackgroundImage:[UIImage imageNamed:@"icon-plus.png"]
                         forState:UIControlStateNormal];
    [insertBtn addTarget:self
                  action:@selector(insertCustomer:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *insertItem = [[UIBarButtonItem alloc] initWithCustomView:insertBtn];
    self.navigationItem.rightBarButtonItem = insertItem;
    [insertItem release];
}

- (void)setNavBarSearchItem
{
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(0, 0, 20, 20);
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"iconSearch.png"]
                         forState:UIControlStateNormal];
    [searchBtn addTarget:self
                  action:@selector(search:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    self.navigationItem.leftBarButtonItem = searchItem;
    [searchItem release];
}

#pragma mark
#pragma mark - 查询客户接口启动
- (void)searchCustomer:(NSNotification *)noti
{
    NSLog(@"searchcustomer");
    NSDictionary *condition = [noti object];
    //网络连接获取数据
    [self sendSearchCustomerMessage:condition];
}

- (void)searchSimpleCustomer
{
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:CUSTOMER_DATA_BASE_DB];
    NSDictionary *usrInfo = [store getObjectById:CUSTOMER_USERINFO
                                       fromTable:CUSTOMER_DB_TABLE];

    NSMutableDictionary *searchCondition = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSString *operatorCode = [usrInfo objectForKey:@"code"];
    [searchCondition setObject:operatorCode
                        forKey:@"operator"];
    
    bussineDataService *bussineService = [bussineDataService sharedDataService];
    bussineService.target = self;
    [bussineService searchCustomerListWithCondition:searchCondition];
}

#pragma mark
#pragma mark - SendHttpMessage
- (void)sendSearchCustomerMessage:(NSDictionary *)condition
{
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:CUSTOMER_DATA_BASE_DB];
    NSDictionary *usrInfo = [store getObjectById:CUSTOMER_USERINFO
                                       fromTable:CUSTOMER_DB_TABLE];
    NSNumber *isadmin = [usrInfo objectForKey:@"isadmin"];
    
    NSMutableDictionary *searchCondition;
    if (condition == nil) {
        searchCondition = [[NSMutableDictionary alloc] initWithCapacity:0];
    }else{
        searchCondition = [[NSMutableDictionary alloc] initWithDictionary:condition copyItems:YES];
    }
    
    
    if ([isadmin integerValue] != PRO_MANAGER_LIMIT) {
        //不是管理员
        NSString *operatorCode = [usrInfo objectForKey:@"code"];
        [searchCondition setObject:operatorCode
                            forKey:@"operator"];
    }
    bussineDataService *bussineService = [bussineDataService sharedDataService];
    bussineService.target = self;
    [bussineService searchCustomerListWithCondition:searchCondition];
}

#pragma mark
#pragma mark - HttpBackDelegate
- (void)requestDidFinished:(NSDictionary *)info
{
    NSString *bussineCode = [info objectForKey:@"bussineCode"];
    NSString *msg = [info objectForKey:@"MSG"];
    NSString *errorCode = [info objectForKey:@"errorCode"];
    if([[SearchCustomerWithConditionMessage getBizCode] isEqualToString:bussineCode]){
        if ([errorCode isEqualToString:RESPONE_RESULT_TRUE]) {
            message *msg = [info objectForKey:@"message"];
            NSDictionary *rspInfo = msg.rspInfo;
            NSString *data = [rspInfo objectForKey:@"data"];
            
            NSArray *rspCustomerList = [NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding]
                                                                       options:NSJSONReadingMutableContainers
                                                                         error:nil];
            self.customerDataList = rspCustomerList;
            [self.customerView reloadData:self.customerDataList];
        }else{
            AlertShowView *alert = [[AlertShowView alloc] initWithAlertViewTitle:@"提示"
                                                                         message:msg
                                                                        delegate:self
                                                                             tag:0
                                                               cancelButtonTitle:@"确定"
                                                               otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }

}

- (void)requestFailed:(NSDictionary *)info
{
    NSString *bussineCode = [info objectForKey:@"bussineCode"];
    NSString *msg = [info objectForKey:@"MSG"];
    if([[SearchCustomerWithConditionMessage getBizCode] isEqualToString:bussineCode]){
        AlertShowView *alert = [[AlertShowView alloc] initWithAlertViewTitle:@"提示"
                                                                     message:msg
                                                                    delegate:self
                                                                         tag:0
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

#pragma mark
#pragma mark - UIAction
- (void)search:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:CUSTOMER_DRAWER_NOTIFATION
                                                        object:nil];
}

- (void)insertCustomer:(id)sender
{
    VerifyCustomerVC *VC = [[VerifyCustomerVC alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
    [VC release];
}

#pragma mark
#pragma mark - CustomerListViewDelegate
- (void)customerListView:(CustomerListView *)listView didSelectRow:(NSInteger)row
{
    NSDictionary *selectCustomer = [self.customerDataList objectAtIndex:row];
    
    DetailInfoVC *VC = [[DetailInfoVC alloc] init];
    VC.detailType = allInfoType;
    VC.customerInfo = selectCustomer;
    VC.isFromApprove = NO;
    [self.navigationController pushViewController:VC animated:YES];
    [VC release];
}

- (void)customerDidSendSMS:(NSArray *)phoneList
{
    BOOL canSendSMS = [MFMessageComposeViewController canSendText];
    if (canSendSMS) {
        MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
        picker.messageComposeDelegate = self;
        picker.body = nil;
        picker.recipients = phoneList;
        [self presentViewController:picker
                           animated:YES
                         completion:nil];
        [picker release];
    }
}

#pragma mark
#pragma mark - MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultCancelled:
        {
            [controller dismissViewControllerAnimated:YES
                                           completion:nil];
        }
            break;
        case MessageComposeResultSent:
        {
            [controller dismissViewControllerAnimated:YES
                                           completion:nil];
            AlertShowView  *alert = [[AlertShowView alloc] initWithAlertViewTitle:nil
                                                                          message:@"短信发送成功"
                                                                         delegate:self
                                                                              tag:0
                                                                cancelButtonTitle:nil
                                                                otherButtonTitles:nil];
            [alert show];
            [NSTimer scheduledTimerWithTimeInterval:2.0f
                                             target:self
                                           selector:@selector(cancelAlterTimer:)
                                           userInfo:alert
                                            repeats:NO];
            [alert release];

    
        }
            break;
        case MessageComposeResultFailed:
        {
            [controller dismissViewControllerAnimated:YES
                                           completion:nil];
            AlertShowView  *alert = [[AlertShowView alloc] initWithAlertViewTitle:nil
                                                                          message:@"短信发送失败"
                                                                         delegate:self
                                                                              tag:0
                                                                cancelButtonTitle:nil
                                                                otherButtonTitles:nil];
            [alert show];
            [NSTimer scheduledTimerWithTimeInterval:2.0f
                                             target:self
                                           selector:@selector(cancelAlterTimer:)
                                           userInfo:alert
                                            repeats:NO];
            [alert release];
        }
            break;
        default:
            break;
    }
    
    
}

#pragma mark
#pragma mark - AlertShowViewDelegate
- (void)alertViewWillPresent:(UIAlertController *)alertController
{
    [self presentViewController:alertController
                            animated:YES
                          completion:nil];
}

#pragma mark
#pragma mark -  取消显示Alert
- (void)cancelAlterTimer:(NSTimer *)timer
{
    AlertShowView *alter = (AlertShowView *)[timer userInfo];
    [alter dismiss];
}


@end

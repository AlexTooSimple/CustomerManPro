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

@interface CustomerManageVC ()<CustomerListViewDelegate,MFMessageComposeViewControllerDelegate>
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
        make.center.equalTo(self.view);
        make.size.equalTo(self.view);
    }];
    
    [customerView release];
    
    [self initData];
    [self.customerView reloadData:self.customerDataList];
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

- (void)initData
{
    NSDictionary *row1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"张三",CUSTOMER_DIC_NAME_KEY,
                          @"13746232132",CUSTOMER_DIC_PHONE_KEY, nil];
    NSDictionary *row2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"李四",CUSTOMER_DIC_NAME_KEY,
                          @"15212332132",CUSTOMER_DIC_PHONE_KEY, nil];
    NSDictionary *row3 = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"张三",CUSTOMER_DIC_NAME_KEY,
                          @"13746232132",CUSTOMER_DIC_PHONE_KEY, nil];
    NSDictionary *row4 = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"李四",CUSTOMER_DIC_NAME_KEY,
                          @"15212332132",CUSTOMER_DIC_PHONE_KEY, nil];
    NSDictionary *row5 = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"张三",CUSTOMER_DIC_NAME_KEY,
                          @"13746232132",CUSTOMER_DIC_PHONE_KEY, nil];
    NSDictionary *row6 = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"李四",CUSTOMER_DIC_NAME_KEY,
                          @"15212332132",CUSTOMER_DIC_PHONE_KEY, nil];
    NSDictionary *row7 = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"张三",CUSTOMER_DIC_NAME_KEY,
                          @"13746232132",CUSTOMER_DIC_PHONE_KEY, nil];
    NSDictionary *row8 = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"李四",CUSTOMER_DIC_NAME_KEY,
                          @"15212332132",CUSTOMER_DIC_PHONE_KEY, nil];
    NSDictionary *row9 = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"张三",CUSTOMER_DIC_NAME_KEY,
                          @"13746232132",CUSTOMER_DIC_PHONE_KEY, nil];
    NSDictionary *row10 = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"李四",CUSTOMER_DIC_NAME_KEY,
                          @"15212332132",CUSTOMER_DIC_PHONE_KEY, nil];
    NSDictionary *row11 = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"张三",CUSTOMER_DIC_NAME_KEY,
                          @"13746232132",CUSTOMER_DIC_PHONE_KEY, nil];
    NSDictionary *row12 = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"李四",CUSTOMER_DIC_NAME_KEY,
                          @"15212332132",CUSTOMER_DIC_PHONE_KEY, nil];
    NSDictionary *row13 = [[NSDictionary alloc] initWithObjectsAndKeys:
                           @"张三",CUSTOMER_DIC_NAME_KEY,
                           @"13746232132",CUSTOMER_DIC_PHONE_KEY, nil];
    NSDictionary *row14 = [[NSDictionary alloc] initWithObjectsAndKeys:
                           @"李四",CUSTOMER_DIC_NAME_KEY,
                           @"15212332132",CUSTOMER_DIC_PHONE_KEY, nil];

    NSDictionary *row15 = [[NSDictionary alloc] initWithObjectsAndKeys:
                           @"张三",CUSTOMER_DIC_NAME_KEY,
                           @"13746232132",CUSTOMER_DIC_PHONE_KEY, nil];
    NSDictionary *row16 = [[NSDictionary alloc] initWithObjectsAndKeys:
                           @"李四",CUSTOMER_DIC_NAME_KEY,
                           @"15212332132",CUSTOMER_DIC_PHONE_KEY, nil];

    NSArray *itemList = [[NSArray alloc] initWithObjects:
                         row1,
                         row2,
                         row3,
                         row4,
                         row5,
                         row6,
                         row7,
                         row8,
                         row9,
                         row10,
                         row11,
                         row12,
                         row13,
                         row14,
                         row15,
                         row16,
                         nil];
    self.customerDataList = itemList;
    [itemList release];
    [row1 release];
    [row2 release];
    [row3 release];
    [row4 release];
    [row5 release];
    [row6 release];
    [row7 release];
    [row8 release];
    [row9 release];
    [row10 release];
    [row11 release];
    [row12 release];
    [row13 release];
    [row14 release];
    [row15 release];
    [row16 release];
}

#pragma mark
#pragma mark - 查询客户接口启动
- (void)searchCustomer:(NSNotification *)noti
{
    NSLog(@"searchcustomer");
    NSDictionary *condition = [noti object];
    //网络连接获取数据
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
    DetailInfoVC *VC = [[DetailInfoVC alloc] init];
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

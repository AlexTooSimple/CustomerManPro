//
//  ApproveCustomerVC.m
//  HZAsiaPro
//
//  Created by wuhui on 15/6/29.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "ApproveCustomerVC.h"
#import "ApproveCustomerView.h"
#import "DetailInfoVC.h"
#import "bussineDataService.h"

@interface ApproveCustomerVC ()<ApproveCustomerViewDelegate,
                                HttpBackDelegate,
                                AlertShowViewDelegate>
{
    ApproveCustomerView *contentApproveView;
    NSArray *approveDataList;
    NSInteger selectRow;
}
@property (nonatomic ,retain)ApproveCustomerView *contentApproveView;
@property (nonatomic ,retain)NSArray *approveDataList;
@property (nonatomic ,assign)NSInteger selectRow;
@end

@implementation ApproveCustomerVC

@synthesize contentApproveView;
@synthesize approveDataList;
@synthesize selectRow;

- (void)dealloc
{
    [contentApproveView release];
    if (approveDataList != nil) {
        [approveDataList release];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:CUSTOMER_APPROVE_CLIENT_NOTIFACTION
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
    self.title = @"审批上报";
    [self setNavBarSMSItem];
    
    [self layoutContentView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadView)
                                                 name:CUSTOMER_APPROVE_CLIENT_NOTIFACTION
                                               object:nil];

    [NSTimer scheduledTimerWithTimeInterval:0.02f
                                     target:self
                                   selector:@selector(sendSearchApproveListMessage)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNavBarSMSItem
{
    UIButton *smsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    smsBtn.frame = CGRectMake(0, 0, 20, 20);
    [smsBtn setBackgroundImage:[UIImage imageNamed:@"ico_sms_c.png"]
                         forState:UIControlStateNormal];
    [smsBtn addTarget:self
               action:@selector(sendSMS:)
     forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *smsItem = [[UIBarButtonItem alloc] initWithCustomView:smsBtn];
    self.navigationItem.rightBarButtonItem = smsItem;
    [smsItem release];
}

- (void)sendSMS:(id)sender
{
    
}

- (void)layoutContentView
{
    ApproveCustomerView *approveView = [[ApproveCustomerView alloc] init];
    approveView.backgroundColor = [UIColor whiteColor];
    approveView.delegate = self;
    [self.view addSubview:approveView];
    self.contentApproveView = approveView;
    [approveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.equalTo(self.view);
    }];
    [approveView release];
}

- (void)reloadView
{
    [self.contentApproveView resetRowCell:self.selectRow];
}

#pragma mark
#pragma mark - Send Http Message
- (void)sendSearchApproveListMessage
{
    bussineDataService *bussineService = [bussineDataService sharedDataService];
    bussineService.target = self;
    [bussineService searchApproveClientList:nil];
}


#pragma mark
#pragma mark - ApproveCustomerViewDelegate
- (void)approveView:(ApproveCustomerView *)approveView didShowApproveDetail:(NSInteger)row
{
    self.selectRow = row;
    
    NSDictionary *itemData = [self.approveDataList objectAtIndex:row];

    DetailInfoVC *detailVC = [[DetailInfoVC alloc] init];
    detailVC.detailType = basicInfoType;
    detailVC.customerInfo = itemData;
    detailVC.isFromApprove = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
    [detailVC release];
}

- (void)approveView:(ApproveCustomerView *)approveView didClickedApprove:(NSInteger)row
{
    self.selectRow = row;
    //审批接口调用
    bussineDataService *bussineService = [bussineDataService sharedDataService];
    bussineService.target = self;
    
    NSDictionary *selectApprove = [self.approveDataList objectAtIndex:row];
    NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 [selectApprove objectForKey:@"clientCode"],@"id",nil];
    
    [bussineService approveClient:requestData];
    [requestData release];
}


#pragma mark
#pragma mark - HttpBackDelegate
- (void)requestDidFinished:(NSDictionary *)info
{
    NSString *bussineCode = [info objectForKey:@"bussineCode"];
    NSString *msg = [info objectForKey:@"MSG"];
    NSString *errorCode = [info objectForKey:@"errorCode"];
    if([[SearchApproveClientListMessage getBizCode] isEqualToString:bussineCode]){
        if ([errorCode isEqualToString:RESPONE_RESULT_TRUE]) {
            message *msg = [info objectForKey:@"message"];
            NSDictionary *rspInfo = msg.rspInfo;
            NSString *data = [rspInfo objectForKey:@"data"];
            
            NSArray *rspCustomerList = [NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding]
                                                                       options:NSJSONReadingMutableContainers
                                                                         error:nil];
            
            if (rspCustomerList == nil ||
                [rspCustomerList isEqual:[NSNull null]] ||
                [rspCustomerList count] == 0) {
                AlertShowView *alert = [[AlertShowView alloc] initWithAlertViewTitle:@"提示"
                                                                             message:@"您还没有未审批的客户"
                                                                            delegate:self
                                                                                 tag:0
                                                                   cancelButtonTitle:@"确定"
                                                                   otherButtonTitles:nil];
                [alert show];
                [alert release];
            }else{
                self.approveDataList = rspCustomerList;
                [self.contentApproveView reloadDataView:self.approveDataList];
            }
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
    }else if([[ApproveClientMessage getBizCode] isEqualToString:bussineCode]){
        if ([errorCode isEqualToString:RESPONE_RESULT_TRUE]) {
            [self.contentApproveView resetRowCell:self.selectRow];
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
    if([[SearchApproveClientListMessage getBizCode] isEqualToString:bussineCode]){
        AlertShowView *alert = [[AlertShowView alloc] initWithAlertViewTitle:@"提示"
                                                                     message:msg
                                                                    delegate:self
                                                                         tag:0
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else if([[ApproveClientMessage getBizCode] isEqualToString:bussineCode]){
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
#pragma mark - AlertShowViewDelegate
- (void)alertViewWillPresent:(UIAlertController *)alertController
{
    [self.navigationController presentViewController:alertController
                                            animated:YES
                                          completion:nil];
}
@end

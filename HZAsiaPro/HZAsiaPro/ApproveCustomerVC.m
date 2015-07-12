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
}
@property (nonatomic ,retain)ApproveCustomerView *contentApproveView;
@property (nonatomic ,retain)NSArray *approveDataList;
@end

@implementation ApproveCustomerVC

@synthesize contentApproveView;
@synthesize approveDataList;

- (void)dealloc
{
    [contentApproveView release];
    if (approveDataList != nil) {
        [approveDataList release];
    }
   
    
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
    NSDictionary *itemData = [self.approveDataList objectAtIndex:row];
    DetailShowType showType;
    NSString *type = [itemData objectForKey:@"type"];
    if ([type isEqualToString:@"1"]) {
        //新增
        showType = allInfoType;
    }else if ([type isEqualToString:@"2"]){
        //新增登记信息
        showType = contactInfoType;
    }else if ([type isEqualToString:@"3"]){
        //修改基本信息
        showType = basicInfoType;
    }
    
    DetailInfoVC *detailVC = [[DetailInfoVC alloc] init];
    detailVC.detailType = showType;
    detailVC.isFromApprove = YES;
    [self.navigationController pushViewController:detailVC animated:YES];

}

- (void)approveView:(ApproveCustomerView *)approveView didClickedApprove:(NSInteger)row
{
    //审批接口调用
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

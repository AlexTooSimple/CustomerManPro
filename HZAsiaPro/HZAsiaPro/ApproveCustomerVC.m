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

@interface ApproveCustomerVC ()<ApproveCustomerViewDelegate>
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
    
    [self initData];
    [self.contentApproveView reloadDataView:self.approveDataList];
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
#pragma mark - 初始化数据
- (void)initData
{
    NSDictionary *data1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                           @"离散",@"title",
                           @"新增客户",@"typeName",
                           @"1",@"type",nil];
    NSDictionary *data2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                           @"离散",@"title",
                           @"修改登记信息",@"typeName",
                           @"2",@"type",nil];
    NSDictionary *data3 = [[NSDictionary alloc] initWithObjectsAndKeys:
                           @"离散",@"title",
                           @"修改客户基本信息",@"typeName",
                           @"3",@"type",nil];
    NSDictionary *data4 = [[NSDictionary alloc] initWithObjectsAndKeys:
                           @"离散离散",@"title",
                           @"新增客户",@"typeName",
                           @"1",@"type",nil];
    NSDictionary *data5 = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"离散",@"title",
                          @"修改登记信息",@"typeName",
                           @"2",@"type",nil];
    NSDictionary *data6 = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"离散",@"title",
                          @"修改客户基本信息",@"typeName",
                          @"3",@"type",nil];
    NSDictionary *data7 = [[NSDictionary alloc] initWithObjectsAndKeys:
                           @"离散",@"title",
                           @"新增客户",@"typeName",
                           @"1",@"type",nil];
    
    NSArray *itemDatas = [[NSArray alloc] initWithObjects:
                          data1,data2,data3,data4,data5,data6,data7, nil];
    [data1 release];
    [data2 release];
    [data3 release];
    [data4 release];
    [data5 release];
    [data6 release];
    [data7 release];
    
    self.approveDataList = itemDatas;
    [itemDatas release];
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
    
}

@end

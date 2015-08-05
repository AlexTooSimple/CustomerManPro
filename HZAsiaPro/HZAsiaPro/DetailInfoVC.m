//
//  DetailInfoVC.m
//  HZAsiaPro
//
//  Created by wuhui on 15/6/12.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//
#import "DetailInfoVC.h"
#import "DetailInfoView.h"
#import "ConcactHistoryView.h"
#import "OperationClientContactVC.h"
#import "OperationClientBasicInfoVC.h"
#import "ActionSheetView.h"
#import "bussineDataService.h"

#define DETAIL_BASE_INFO_VIEW_TAG           202
#define DETAIL_HISTORY_INFO_VIEW_TAG        201

#define DELETE_CUSTOMER_TAG                 301
#define ALTER_APPROVE_SUCCESS_TAG           401

@interface DetailInfoVC ()<UIScrollViewDelegate,
                          ActionSheetViewDelegate,
                          HttpBackDelegate,
                          UIActionSheetDelegate,
                          AlertShowViewDelegate,
                          UIAlertViewDelegate>
{
    UIScrollView *contentView;
    UIPageControl *contentControl;
    
    NSArray *customerInfoDataList;
    NSArray *customerHistoryList;
    BOOL isUpdate;
}
@property (nonatomic ,assign)BOOL isUpdate;
@property (nonatomic ,retain)UIScrollView *contentView;
@property (nonatomic ,retain)UIPageControl *contentControl;
@property (nonatomic ,retain)NSArray *customerInfoDataList;
@property (nonatomic ,retain)NSArray *customerHistoryList;
@end

@implementation DetailInfoVC

@synthesize customerInfo;
@synthesize contentControl;
@synthesize contentView;
@synthesize customerInfoDataList;
@synthesize customerHistoryList;
@synthesize detailType;
@synthesize isFromApprove;
@synthesize isUpdate;

- (void)dealloc
{
    if (customerInfo != nil) {
        [customerInfo release];
    }
    
    if (contentView != nil) {
        [contentView release];
    }
    
    if (contentControl != nil) {
        [contentControl release];
    }
    
    if (customerInfoDataList != nil) {
        [customerInfoDataList release];
    }
    
    if (customerHistoryList != nil) {
        [customerHistoryList release];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:CUSTOMER_UPDATE_CLIENT_DATA_NOTIFATION
                                                  object:nil];
    
    [super dealloc];
}

- (void)loadView
{
    CGRect frame = [UIScreen mainScreen].bounds;
    UIView *rootView = [[UIView alloc] initWithFrame:frame];
    rootView.backgroundColor = [UIColor whiteColor];
    self.view = rootView;
    [rootView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.isUpdate = NO;
    if (isFromApprove) {
        self.title = @"审批详情";
        [self setNavBarApproveItem];
    }else{
        self.title = @"客户详情";
        [self setNavBarOperatorItem];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setDetailUpdateKeyView)
                                                 name:CUSTOMER_UPDATE_CLIENT_DATA_NOTIFATION
                                               object:nil];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.scrollEnabled = YES;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
    self.contentView = scrollView;
    [self.view addSubview:scrollView];
    
    
    CGFloat hei;
    UIViewController *visibleVC =  [[self.navigationController viewControllers] objectAtIndex:([[self.navigationController viewControllers] count]-2)];
    if (visibleVC.hidesBottomBarWhenPushed) {
        hei = 0;
    }else{
        hei = DEVICE_TABBAR_HEIGTH;
    }
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(64.0f);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-hei);
    }];
    [scrollView release];
    
    switch (detailType) {
        case allInfoType:
        {
            [self layoutDetailAllView];
        }
            break;
        case basicInfoType:
        {
            [self layoutBasicInfoView];
        }
            break;
        case contactInfoType:
        {
            [self layoutConcactInfoView];
        }
            break;
        default:
            break;
    }
    
    [self initData];
}

- (void)initData
{
    switch (detailType) {
        case allInfoType:
        {
            //组装客户基本信息
            [self assembCustomerInfo];
            //获取来访记录
            [self getVisitHistoryList];
            
        }
            break;
        case basicInfoType:
        {
            //组装客户基本信息
            [self assembCustomerInfo];
            [self reloadDetailViewData];
        }
            break;
        case contactInfoType:
        {
            //获取来访记录
            [self getVisitHistoryList];
        }
            break;
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.isUpdate) {
        bussineDataService *bussineService = [bussineDataService sharedDataService];
        bussineService.target = self;
        NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     [self.customerInfo objectForKey:@"clientCode"],@"clientCode",nil];
        [bussineService searchCustomerListWithCondition:requestData];
        [requestData release];
    }
}

- (void)setDetailUpdateKeyView
{
    self.isUpdate = YES;
}

#pragma mark
#pragma mark - 设置NavLeft按钮
- (void)setNavBarOperatorItem
{
    UIBarButtonItem *operateItem = [[UIBarButtonItem alloc] initWithTitle:@"修改"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(operateClicked:)];
    self.navigationItem.rightBarButtonItem = operateItem;
    [operateItem release];
}

- (void)operateClicked:(id)sender
{
    ActionSheetView *sheetView = [[ActionSheetView alloc] initWithTitle:nil
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                 destructiveButtonTitle:@"删除"
                                                      otherButtonTitles:@"登记联系信息",@"修改客户基本信息",nil];
    [sheetView show];
    [sheetView release];
}

- (void)setNavBarApproveItem
{
    UIBarButtonItem *approveItem = [[UIBarButtonItem alloc] initWithTitle:@"审批"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(approveClicked:)];
    self.navigationItem.rightBarButtonItem = approveItem;
    [approveItem release];
    
}

- (void)approveClicked:(id)sender
{
    //审批
    bussineDataService *bussineService = [bussineDataService sharedDataService];
    bussineService.target = self;
    
    NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 [self.customerInfo objectForKey:@"clientCode"],@"id",nil];
    
    [bussineService approveClient:requestData];
    [requestData release];
}

#pragma mark
#pragma mark - 初始化页面
- (void)layoutDetailAllView
{
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
    pageControl.backgroundColor = [UIColor clearColor];
    pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    [pageControl addTarget:self
                    action:@selector(handlePageControlFrom:)
          forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:pageControl];
    
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_bottom).with.offset(-36.0f);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(30.0f);
    }];
    self.contentControl = pageControl;
    [pageControl release];
    
    //默认出现三屏，第一屏客户基本信息  第2屏客户联系记录  第3屏客户交易记录
    NSInteger cnt = 1;
    DetailInfoView *detailView = [[DetailInfoView alloc] init];
    detailView.tag = DETAIL_BASE_INFO_VIEW_TAG;
    detailView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:detailView];
    [detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView);
        make.width.equalTo(self.contentView);
        make.height.equalTo(self.contentView);
    }];
    
    cnt++;
    ConcactHistoryView *historyView = [[ConcactHistoryView alloc] init];
    historyView.backgroundColor = [UIColor whiteColor];
    historyView.tag = DETAIL_HISTORY_INFO_VIEW_TAG;
    [self.contentView addSubview:historyView];
    [historyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(detailView.mas_right);
        make.top.equalTo(self.contentView);
        make.width.equalTo(self.contentView);
        make.height.equalTo(self.contentView);
    }];
    
    
    [historyView release];
    [detailView release];

    CGFloat hei;
    UIViewController *visibleVC =  [[self.navigationController viewControllers] objectAtIndex:([[self.navigationController viewControllers] count]-2)];
    if (visibleVC.hidesBottomBarWhenPushed) {
        hei = 0;
    }else{
        hei = DEVICE_TABBAR_HEIGTH;
    }
    
    [self.contentView setContentSize:CGSizeMake(DEVICE_MAINSCREEN_WIDTH*cnt, DEVICE_MAINSCREEN_HEIGHT-64-hei)];
    
    [self.contentControl setNumberOfPages:cnt];
   
    [self.view bringSubviewToFront:self.contentControl];
}


- (void)layoutBasicInfoView
{
    DetailInfoView *detailView = [[DetailInfoView alloc] init];
    detailView.tag = DETAIL_BASE_INFO_VIEW_TAG;
    detailView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:detailView];
    [detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.size.equalTo(self.contentView);
    }];
    
    self.contentView.pagingEnabled = NO;
    self.contentView.showsHorizontalScrollIndicator = NO;
    
    [detailView release];
}

- (void)layoutConcactInfoView;
{
    ConcactHistoryView *historyView = [[ConcactHistoryView alloc] init];
    historyView.tag = DETAIL_HISTORY_INFO_VIEW_TAG;
    historyView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:historyView];
    [historyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.contentView);
        make.center.equalTo(self.contentView);
    }];
    
    self.contentView.showsHorizontalScrollIndicator = NO;
    self.contentView.pagingEnabled = NO;
    
    [historyView release];
}

#pragma mark
#pragma mark - 获取来访记录
- (void)getVisitHistoryList
{
    NSString *clientCode = [self.customerInfo objectForKey:@"clientCode"];
    bussineDataService *bussineService = [bussineDataService sharedDataService];
    NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 clientCode,@"clientCode",nil];
    bussineService.target = self;
    [bussineService getVisitHistoryList:requestData];
    [requestData release];
}

#pragma mark
#pragma mark - 刷新数据
- (void)reloadDetailViewData
{
    DetailInfoView *detailView = (DetailInfoView *)[self.contentView viewWithTag:DETAIL_BASE_INFO_VIEW_TAG];
    ConcactHistoryView *historyView = (ConcactHistoryView *)[self.contentView viewWithTag:DETAIL_HISTORY_INFO_VIEW_TAG];
    if (detailView != nil) {
        [detailView reloadViewData:self.customerInfoDataList];
    }
    
    if (historyView != nil) {
        [historyView reloadViewData:self.customerHistoryList];
    }
}

#pragma mark
#pragma mark - ActionSheetViewDelegate
- (void)actionSheetView:(ActionSheetView *)sheetView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            //删除客户
            [self deleteClient];
        }
            break;
        case 1:
        {
            //登记联系信息
            [self gotoOperatClientContactInfoVC];
        }
            break;
        case 2:
        {
            //修改客户基本信息
            [self gotoOperatClientBaiscInfoVC];
        }
            break;
        default:
            break;
    }
}

- (void)actionSheetViewWillPresent:(UIAlertController *)alertController
{
    UIViewController  *currentVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    [currentVC presentViewController:alertController
                            animated:YES
                          completion:nil];
}


#pragma mark
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            //删除客户
            [self deleteClient];
        }
            break;
        case 1:
        {
            //登记联系信息
            [self gotoOperatClientContactInfoVC];
        }
            break;
        case 2:
        {
            //修改客户基本信息
            [self gotoOperatClientBaiscInfoVC];
        }
            break;
        default:
            break;
    }
}



#pragma mark
#pragma mark - actionSheet对应的操作
- (void)gotoOperatClientBaiscInfoVC
{
    OperationClientBasicInfoVC *operationVC = [[OperationClientBasicInfoVC alloc] init];
    NSDictionary *currentCustomerInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                         [self.customerInfo objectForKey:@"clientCode"], @"clientCode",
                                         [self.customerInfo objectForKey:@"clientType"], @"clientType",
                                         [self.customerInfo objectForKey:@"cname"],@"cname",
                                         [self.customerInfo objectForKey:@"mobile"],@"mobile",nil];
    operationVC.customerInfo = currentCustomerInfo;
    [currentCustomerInfo release];
    
    [operationVC reloadInitData:self.customerInfoDataList];
    [self.navigationController pushViewController:operationVC animated:YES];
    [operationVC release];
}

- (void)gotoOperatClientContactInfoVC
{
    NSDictionary *nameDic = [self.customerInfoDataList objectAtIndex:0];
    OperationClientContactVC *operationVC = [[OperationClientContactVC alloc] init];
    operationVC.clientCode = [self.customerInfo objectForKey:@"clientCode"];
    [operationVC reloadInitData:nameDic];
    [self.navigationController pushViewController:operationVC animated:YES];
    [operationVC release];
}

- (void)deleteClient
{
    bussineDataService *bussineService = [bussineDataService sharedDataService];
    bussineService.target = self;
    NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 [self.customerInfo objectForKey:@"clientCode"], @"clientCode",nil];
    [bussineService deleteCustomer:requestData];
    [requestData release];
}


#pragma mark
#pragma mark - 初始化数据
- (void)assembCustomerInfo
{
    NSString *clientType = [self.customerInfo objectForKey:@"clientType"];
    if ([clientType isEqualToString:@"0"]) {
        //个人客户
        [self assembIndividualData];
    }else if ([clientType isEqualToString:@"1"]){
        //企业客户
        [self assembBusinessData];
    }
}

- (void)assembBusinessData
{
    NSMutableArray *infoList = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSDictionary *nameDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"公司名称:", DATA_SHOW_TITLE_COLUM,
                             [self.customerInfo objectForKey:@"cname"],DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:nameDic];
    [nameDic release];
    
    NSString *mobile = nil;
    if ([self.customerInfo objectForKey:@"mobile"] == nil || [[self.customerInfo objectForKey:@"mobile"] isEqual:[NSNull null]]) {
        mobile = [self.customerInfo objectForKey:@"first_phone"];
    }else{
        mobile = [self.customerInfo objectForKey:@"mobile"];
    }
    NSDictionary *phoneDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"联系电话:", DATA_SHOW_TITLE_COLUM,
                              mobile,DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:phoneDic];
    [phoneDic release];
    
    
//    NSDictionary *clientStatusDic = [[NSDictionary alloc] initWithObjectsAndKeys:
//                                     @"客户状态:", DATA_SHOW_TITLE_COLUM,
//                                     @"李光荣",DATA_SHOW_VALUE_COLUM,nil];
//    [infoList addObject:clientStatusDic];
//    [clientStatusDic release];
//    
//    NSDictionary *clientVistDic = [[NSDictionary alloc] initWithObjectsAndKeys:
//                                   @"客户所属:", DATA_SHOW_TITLE_COLUM,
//                                   @"13321314132",DATA_SHOW_VALUE_COLUM,nil];
//    [infoList addObject:clientVistDic];
//    [clientVistDic release];
    
    NSDictionary *shortNameDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"公司简称:", DATA_SHOW_TITLE_COLUM,
                                  [self.customerInfo objectForKey:@"shortforname"],DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:shortNameDic];
    [shortNameDic release];
    
    NSDictionary *engishNameDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   @"法人代表:", DATA_SHOW_TITLE_COLUM,
                                   [self.customerInfo objectForKey:@"faren"],DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:engishNameDic];
    [engishNameDic release];
    
    NSDictionary *originalNameDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     @"联系人:", DATA_SHOW_TITLE_COLUM,
                                     [self.customerInfo objectForKey:@"contact"],DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:originalNameDic];
    [originalNameDic release];
    
    NSDictionary *originalPhoneDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      @"原始公司名称:", DATA_SHOW_TITLE_COLUM,
                                      [self.customerInfo objectForKey:@"fristName"],DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:originalPhoneDic];
    [originalPhoneDic release];
    
    NSDictionary *certTypeDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"原始电话:", DATA_SHOW_TITLE_COLUM,
                                 [self.customerInfo objectForKey:@"phoneO"],DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:certTypeDic];
    [certTypeDic release];
    
    NSDictionary *certIDDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"注册地址:", DATA_SHOW_TITLE_COLUM,
                               [self.customerInfo objectForKey:@"zhcaddr"],DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:certIDDic];
    [certIDDic release];
    
    NSDictionary *startDateDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"注册资金:", DATA_SHOW_TITLE_COLUM,
                                  [NSString stringWithFormat:@"%ld",[[self.customerInfo objectForKey:@"zhcprice"] longValue]],DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:startDateDic];
    [startDateDic release];
    
    NSDictionary *countyDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"经营范围:", DATA_SHOW_TITLE_COLUM,
                             [self.customerInfo objectForKey:@"jyfanwei"],DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:countyDic];
    [countyDic release];

    NSDictionary *areaDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"行业性质:", DATA_SHOW_TITLE_COLUM,
                             [self.customerInfo objectForKey:@"hyxingzhi"],DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:areaDic];
    [areaDic release];
    
    NSDictionary *professDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @"行业排名:", DATA_SHOW_TITLE_COLUM,
                                [self.customerInfo objectForKey:@"hypaiming"],DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:professDic];
    [professDic release];
    
    NSDictionary *companyDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @"税籍户管:", DATA_SHOW_TITLE_COLUM,
                                [self.customerInfo objectForKey:@"shjhuguan"],DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:companyDic];
    [companyDic release];
    
    NSDictionary *addressDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @"工商执照号:", DATA_SHOW_TITLE_COLUM,
                                [self.customerInfo objectForKey:@"id"],DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:addressDic];
    [addressDic release];
    
    NSDictionary *businessDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"税务执照号:", DATA_SHOW_TITLE_COLUM,
                                 [self.customerInfo objectForKey:@"shwno"],DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:businessDic];
    [businessDic release];
    
    NSDictionary *sexDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                            @"税务代码:", DATA_SHOW_TITLE_COLUM,
                            [self.customerInfo objectForKey:@"shwcode"],DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:sexDic];
    [sexDic release];
    
    NSDictionary *marryDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"经营地址:", DATA_SHOW_TITLE_COLUM,
                              [self.customerInfo objectForKey:@"address"],DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:marryDic];
    [marryDic release];
    
    NSDictionary *educationDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"经营期限:", DATA_SHOW_TITLE_COLUM,
                                  [self.customerInfo objectForKey:@"jyqixian"],DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:educationDic];
    [educationDic release];
    
    NSDictionary *postNumberDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   @"邮政编码:", DATA_SHOW_TITLE_COLUM,
                                   [self.customerInfo objectForKey:@"post"],DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:postNumberDic];
    [postNumberDic release];
    
    
    NSDictionary *companyPhoneDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     @"E-mail:", DATA_SHOW_TITLE_COLUM,
                                     [self.customerInfo objectForKey:@"email"],DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:companyPhoneDic];
    [companyPhoneDic release];
    
    NSDictionary *chuanzhenDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"组织机构代码:", DATA_SHOW_TITLE_COLUM,
                                  [self.customerInfo objectForKey:@"fax"],DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:chuanzhenDic];
    [chuanzhenDic release];
    
    NSDictionary *emailDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"入驻方式:", DATA_SHOW_TITLE_COLUM,
                              [self.customerInfo objectForKey:@"email"],DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:emailDic];
    [emailDic release];
    
    NSDictionary *jzjdDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"进展阶段:", DATA_SHOW_TITLE_COLUM,
                             [self.customerInfo objectForKey:@"steps"],DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:jzjdDic];
    [jzjdDic release];
    
    NSDictionary *remarkDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"备注:", DATA_SHOW_TITLE_COLUM,
                               [self.customerInfo objectForKey:@"remarks"],DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:remarkDic];
    [remarkDic release];
    
    self.customerInfoDataList = infoList;
    [infoList release];

}

- (void)assembIndividualData
{
    NSMutableArray *infoList = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSDictionary *nameDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"客户姓名:", DATA_SHOW_TITLE_COLUM,
                             [self.customerInfo objectForKey:@"cname"],DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:nameDic];
    [nameDic release];
    
    NSDictionary *phoneDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"移动电话:", DATA_SHOW_TITLE_COLUM,
                              [self.customerInfo objectForKey:@"mobile"],DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:phoneDic];
    [phoneDic release];
    
    
//    NSDictionary *clientStatusDic = [[NSDictionary alloc] initWithObjectsAndKeys:
//                                     @"客户状态:", DATA_SHOW_TITLE_COLUM,
//                                     @"李光荣",DATA_SHOW_VALUE_COLUM,nil];
//    [infoList addObject:clientStatusDic];
//    [clientStatusDic release];
//    
//    NSDictionary *clientVistDic = [[NSDictionary alloc] initWithObjectsAndKeys:
//                                   @"客户所属:", DATA_SHOW_TITLE_COLUM,
//                                   @"13321314132",DATA_SHOW_VALUE_COLUM,nil];
//    [infoList addObject:clientVistDic];
//    [clientVistDic release];
    
    NSDictionary *shortNameDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"缩写:", DATA_SHOW_TITLE_COLUM,
                                  [self.customerInfo objectForKey:@"shortforname"],DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:shortNameDic];
    [shortNameDic release];
    
    NSDictionary *engishNameDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   @"英文名:", DATA_SHOW_TITLE_COLUM,
                                   [self.customerInfo objectForKey:@"enname"],DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:engishNameDic];
    [engishNameDic release];
    
    NSDictionary *originalNameDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     @"原始姓名:", DATA_SHOW_TITLE_COLUM,
                                     [self.customerInfo objectForKey:@"fristName"],DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:originalNameDic];
    [originalNameDic release];
    
    NSDictionary *originalPhoneDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      @"原始电话:", DATA_SHOW_TITLE_COLUM,
                                      [self.customerInfo objectForKey:@"fristPhone"],DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:originalPhoneDic];
    [originalPhoneDic release];
    
    NSDictionary *certTypeDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"证件类型:", DATA_SHOW_TITLE_COLUM,
                                 [self.customerInfo objectForKey:@"idtype"],DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:certTypeDic];
    [certTypeDic release];
    
    NSDictionary *certIDDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"证件号码:", DATA_SHOW_TITLE_COLUM,
                               [self.customerInfo objectForKey:@"id"],DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:certIDDic];
    [certIDDic release];
    
    NSDictionary *startDateDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"出生日期:", DATA_SHOW_TITLE_COLUM,
                                  [self.customerInfo objectForKey:@"birthdayStr"],DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:startDateDic];
    [startDateDic release];
    
    //    NSDictionary *countyDic = [[NSDictionary alloc] initWithObjectsAndKeys:
    //                             @"国籍", DATA_SHOW_TITLE_COLUM,
    //                             @"",DATA_SHOW_VALUE_COLUM,nil];
    //    [infoList addObject:countyDic];
    //    [countyDic release];
    //
    //    NSDictionary *areaDic = [[NSDictionary alloc] initWithObjectsAndKeys:
    //                             @"区域", DATA_SHOW_TITLE_COLUM,
    //                             @"",DATA_SHOW_VALUE_COLUM,nil];
    //    [infoList addObject:areaDic];
    //    [areaDic release];
    
    NSDictionary *professDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @"职业:", DATA_SHOW_TITLE_COLUM,
                                [self.customerInfo objectForKey:@"business"],DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:professDic];
    [professDic release];
    
    NSDictionary *companyDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @"公司:", DATA_SHOW_TITLE_COLUM,
                                [self.customerInfo objectForKey:@"company"],DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:companyDic];
    [companyDic release];
    
    NSDictionary *addressDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @"联系地址:", DATA_SHOW_TITLE_COLUM,
                                [self.customerInfo objectForKey:@"address"],DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:addressDic];
    [addressDic release];
    
    NSDictionary *businessDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"行业:", DATA_SHOW_TITLE_COLUM,
                                 [self.customerInfo objectForKey:@"hangye"],DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:businessDic];
    [businessDic release];
    
    NSDictionary *sexDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                            @"性别:", DATA_SHOW_TITLE_COLUM,
                            [self.customerInfo objectForKey:@"sex"],DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:sexDic];
    [sexDic release];
    
    NSDictionary *marryDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"婚否:", DATA_SHOW_TITLE_COLUM,
                              [self.customerInfo objectForKey:@"marige"],DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:marryDic];
    [marryDic release];
    
    NSDictionary *educationDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"学历:", DATA_SHOW_TITLE_COLUM,
                                  [self.customerInfo objectForKey:@"xueli"],DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:educationDic];
    [educationDic release];
    
    NSDictionary *postNumberDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   @"邮政编码:", DATA_SHOW_TITLE_COLUM,
                                   [self.customerInfo objectForKey:@"post"],DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:postNumberDic];
    [postNumberDic release];
    
    
    NSDictionary *companyPhoneDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     @"办公电话:", DATA_SHOW_TITLE_COLUM,
                                     [self.customerInfo objectForKey:@"phoneO"],DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:companyPhoneDic];
    [companyPhoneDic release];
    
    NSDictionary *homePhoneDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"家庭电话:", DATA_SHOW_TITLE_COLUM,
                                  [self.customerInfo objectForKey:@"phoneH"],DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:homePhoneDic];
    [homePhoneDic release];
    
    NSDictionary *chuanzhenDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"传真:", DATA_SHOW_TITLE_COLUM,
                                  [self.customerInfo objectForKey:@"fax"],DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:chuanzhenDic];
    [chuanzhenDic release];
    
    NSDictionary *emailDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"电子邮件:", DATA_SHOW_TITLE_COLUM,
                              [self.customerInfo objectForKey:@"email"],DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:emailDic];
    [emailDic release];
    
    NSDictionary *jzjdDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"进展阶段:", DATA_SHOW_TITLE_COLUM,
                             [self.customerInfo objectForKey:@"steps"],DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:jzjdDic];
    [jzjdDic release];
    
    NSDictionary *remarkDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"备注:", DATA_SHOW_TITLE_COLUM,
                               [self.customerInfo objectForKey:@"remarks"],DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:remarkDic];
    [remarkDic release];
    
    self.customerInfoDataList = infoList;
    [infoList release];

}

- (void)assembConcactHistoryData:(NSArray *)concactHistoryItemList
{
    NSMutableArray *historyList = [[NSMutableArray alloc] initWithCapacity:0];
    NSInteger cnt = [concactHistoryItemList count];
    for (int i = 0; i<cnt; i++) {
        NSDictionary *oneConcactItem = [concactHistoryItemList objectAtIndex:i];
        NSMutableArray *historyOneItem = [[NSMutableArray alloc] initWithCapacity:0];
        NSDictionary *dateDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"日期:",DATA_SHOW_TITLE_COLUM,
                                 @"2014-6-1",DATA_SHOW_VALUE_COLUM ,nil];
        [historyOneItem addObject:dateDic];
        [dateDic release];
        
        NSDictionary *typeDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"类型:",DATA_SHOW_TITLE_COLUM,
                                 [oneConcactItem objectForKey:@"type"],DATA_SHOW_VALUE_COLUM,nil];
        [historyOneItem addObject:typeDic];
        [typeDic release];
        
        NSDictionary *willingnessDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        @"购买意向:",DATA_SHOW_TITLE_COLUM,
                                        [oneConcactItem objectForKey:@"intent"],DATA_SHOW_VALUE_COLUM,nil];
        [historyOneItem addObject:willingnessDic];
        [willingnessDic release];
        
        NSDictionary *peopleDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   [oneConcactItem objectForKey:@"receptionist"],DATA_SHOW_VALUE_COLUM,
                                   @"接待人:",DATA_SHOW_TITLE_COLUM, nil];
        [historyOneItem addObject:peopleDic];
        [peopleDic release];
        
        NSDictionary *remarkDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   @"备注:",DATA_SHOW_TITLE_COLUM,
                                   [oneConcactItem objectForKey:@"remarks"],DATA_SHOW_VALUE_COLUM,nil];
        [historyOneItem addObject:remarkDic];
        [remarkDic release];
        
        
        [historyList addObject:historyOneItem];
        [historyOneItem release];
    }
    self.customerHistoryList = historyList;
    [historyList release];
}

#pragma mark
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.contentView != nil && scrollView == self.contentView ) {
        CGFloat pageWidth = scrollView.frame.size.width;
        int page1 = floor(scrollView.contentOffset.x/pageWidth) + 1;
        NSLog(@"%@,, x===%lf,,page===%d",scrollView,scrollView.contentOffset.x,page1);
        [self.contentControl setCurrentPage:(page1-1)];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"OL");
}

#pragma mark
#pragma mark - UIAction
- (void)handlePageControlFrom:(id)sender
{
    UIPageControl *pageControl = (UIPageControl *)sender;
    NSInteger page = pageControl.currentPage;
    CGPoint currentPoint = self.contentView.contentOffset;
    [UIView animateWithDuration:0.03f animations:^{
        [self.contentView setContentOffset:CGPointMake(DEVICE_MAINSCREEN_WIDTH*page, currentPoint.y) animated:YES];
    }];
}



#pragma mark
#pragma mark - HttpBackDelegate
- (void)requestDidFinished:(NSDictionary *)info
{
    NSString *bussineCode = [info objectForKey:@"bussineCode"];
    NSString *msg = [info objectForKey:@"MSG"];
    NSString *errorCode = [info objectForKey:@"errorCode"];
    if([[GetVisitHistoryListMessage getBizCode] isEqualToString:bussineCode]){
        if ([errorCode isEqualToString:RESPONE_RESULT_TRUE]) {
            message *msg = [info objectForKey:@"message"];
            NSDictionary *rspInfo = msg.rspInfo;
            NSString *data = [rspInfo objectForKey:@"data"];
            
            NSArray *rspConcactList = [NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding]
                                                                      options:NSJSONReadingMutableContainers
                                                                        error:nil];
            
            //组装客户联系记录
            [self assembConcactHistoryData:rspConcactList];
            [self reloadDetailViewData];
            
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
    }else if([[DeleteClientMessage getBizCode] isEqualToString:bussineCode]){
        if ([errorCode isEqualToString:RESPONE_RESULT_TRUE]) {
            AlertShowView *alert = [[AlertShowView alloc] initWithAlertViewTitle:@"删除成功"
                                                                         message:@"客户已被删除，谢谢！"
                                                                        delegate:self
                                                                             tag:DELETE_CUSTOMER_TAG
                                                               cancelButtonTitle:@"确定"
                                                               otherButtonTitles:nil];
            [alert show];
            [alert release];

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
    }else if([[SearchCustomerWithConditionMessage getBizCode] isEqualToString:bussineCode]){
        if ([errorCode isEqualToString:RESPONE_RESULT_TRUE]) {
            message *msg = [info objectForKey:@"message"];
            NSDictionary *rspInfo = msg.rspInfo;
            NSString *data = [rspInfo objectForKey:@"data"];
            
            NSArray *rspCustomerList = [NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding]
                                                                       options:NSJSONReadingMutableContainers
                                                                         error:nil];
            
            if (self.isUpdate) {
                self.isUpdate = NO;
            }
            
            self.customerInfo = [rspCustomerList objectAtIndex:0];
            [self assembCustomerInfo];
            
            DetailInfoView *detailView = (DetailInfoView *)[self.contentView viewWithTag:DETAIL_BASE_INFO_VIEW_TAG];
            if (detailView != nil) {
                [detailView reloadViewData:self.customerInfoDataList];
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
            
            AlertShowView *alert = [[AlertShowView alloc] initWithAlertViewTitle:@""
                                                                         message:@"客户审批通过"
                                                                        delegate:self
                                                                             tag:ALTER_APPROVE_SUCCESS_TAG
                                                               cancelButtonTitle:@"确定"
                                                               otherButtonTitles:nil];
            [alert show];
            [alert release];
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
    if([[GetVisitHistoryListMessage getBizCode] isEqualToString:bussineCode]){
        AlertShowView *alert = [[AlertShowView alloc] initWithAlertViewTitle:@"提示"
                                                                     message:msg
                                                                    delegate:self
                                                                         tag:0
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else if([[DeleteClientMessage getBizCode] isEqualToString:bussineCode]){
        AlertShowView *alert = [[AlertShowView alloc] initWithAlertViewTitle:@"提示"
                                                                     message:msg
                                                                    delegate:self
                                                                         tag:0
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else if([[SearchCustomerWithConditionMessage getBizCode] isEqualToString:bussineCode]){
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

- (void)alertShowView:(AlertShowView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.index == DELETE_CUSTOMER_TAG) {
        [[NSNotificationCenter defaultCenter] postNotificationName:CUSTOMER_DELETE_NOTIFATION
                                                            object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }else if (ALTER_APPROVE_SUCCESS_TAG == alertView.index){
        [[NSNotificationCenter defaultCenter] postNotificationName:CUSTOMER_APPROVE_CLIENT_NOTIFACTION
                                                            object:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark
#pragma mark - UIAlterViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == DELETE_CUSTOMER_TAG) {
        [[NSNotificationCenter defaultCenter] postNotificationName:CUSTOMER_DELETE_NOTIFATION
                                                            object:nil];

        [self.navigationController popViewControllerAnimated:YES];
    }else if (ALTER_APPROVE_SUCCESS_TAG == alertView.tag){
        [[NSNotificationCenter defaultCenter] postNotificationName:CUSTOMER_APPROVE_CLIENT_NOTIFACTION
                                                            object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end

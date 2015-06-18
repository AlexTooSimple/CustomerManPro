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

@interface DetailInfoVC ()<UIScrollViewDelegate>
{
    UIScrollView *contentView;
    UIPageControl *contentControl;
    
    NSArray *customerInfoDataList;
    NSArray *customerHistoryList;
}
@property (nonatomic ,retain)UIScrollView *contentView;
@property (nonatomic ,retain)UIPageControl *contentControl;
@property (nonatomic ,retain)NSArray *customerInfoDataList;
@property (nonatomic ,retain)NSArray *customerHistoryList;
@end

@implementation DetailInfoVC

@synthesize contentControl;
@synthesize contentView;
@synthesize customerInfoDataList;
@synthesize customerHistoryList;

- (void)dealloc
{
    if (contentView != nil) {
        [contentView release];
    }
    
    [contentControl release];
    
    if (customerInfoDataList != nil) {
        [customerInfoDataList release];
    }
    
    if (customerHistoryList != nil) {
        [customerHistoryList release];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"客户详情";
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.scrollEnabled = YES;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    self.contentView = scrollView;
    [self.view addSubview:scrollView];
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        if (IS_IOS_8_LATER) {
//            make.top.equalTo(self.view);
//        }else{
//            make.top.equalTo(self.view).with.offset(32.0f);
//        }
//        if (IS_IOS_8_LATER) {
//            make.bottom.equalTo(self.view).with.offset(-DEVICE_TABBAR_HEIGTH-10);
//        }else{
//            make.bottom.equalTo(self.view).with.offset(-DEVICE_TABBAR_HEIGTH);
//        }
//        
//        make.left.equalTo(self.view);
//        make.right.equalTo(self.view);
        make.center.equalTo(self.view);
        make.size.equalTo(self.view);
    }];
    [scrollView release];
    
    
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
    pageControl.backgroundColor = [UIColor clearColor];
    pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    [pageControl addTarget:self
                    action:@selector(handlePageControlFrom:)
          forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:pageControl];
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom).with.offset(-80.0f);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(30.0f);
    }];
    self.contentControl = pageControl;
    [pageControl release];
    
    [self initData];
    
    [self reloadScrollContent];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadScrollContent
{
    //默认出现三屏，第一屏客户基本信息  第2屏客户联系记录  第3屏客户交易记录
    NSInteger cnt = 1;
    DetailInfoView *detailView = [[DetailInfoView alloc] init];
    detailView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:detailView];
    [detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView);
        make.width.equalTo(self.contentView);
        make.height.equalTo(self.contentView).with.offset(-DEVICE_TABBAR_HEIGTH-64);
    }];
    
    [detailView reloadViewData:self.customerInfoDataList];
    
    
    cnt++;
    ConcactHistoryView *historyView = [[ConcactHistoryView alloc] init];
    historyView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:historyView];
    [historyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(detailView.mas_right);
        make.top.equalTo(self.contentView);
        make.width.equalTo(self.contentView);
        make.height.equalTo(self.contentView).with.offset(-DEVICE_TABBAR_HEIGTH-64);
    }];
    [historyView reloadViewData:self.customerHistoryList];
    
    
    [historyView release];
    [detailView release];
    
    CGFloat contentWidth = self.view.frame.size.width;
    CGFloat contentHeight = self.view.frame.size.height - DEVICE_TABBAR_HEIGTH - 64.0f;
    [self.contentView setContentSize:CGSizeMake(contentWidth *cnt, contentHeight)];
    
    [self.contentControl setNumberOfPages:cnt];
    [self.view bringSubviewToFront:self.contentControl];
    
}

- (void)initData
{
    //组装客户基本信息
    [self assembCustomerInfo];
    //组装客户联系记录
    [self assembConcactHistoryData];
}

- (void)assembCustomerInfo
{
    
    
    NSMutableArray *infoList = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSDictionary *nameDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"客户姓名", DATA_SHOW_TITLE_COLUM,
                             @"李光荣",DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:nameDic];
    [nameDic release];
    
    NSDictionary *phoneDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"移动电话", DATA_SHOW_TITLE_COLUM,
                             @"13321314132",DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:phoneDic];
    [phoneDic release];
    
    
    NSDictionary *clientStatusDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"客户状态", DATA_SHOW_TITLE_COLUM,
                             @"李光荣",DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:clientStatusDic];
    [clientStatusDic release];
    
    NSDictionary *clientVistDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"客户所属", DATA_SHOW_TITLE_COLUM,
                             @"13321314132",DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:clientVistDic];
    [clientVistDic release];
    
    NSDictionary *shortNameDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"缩写", DATA_SHOW_TITLE_COLUM,
                                  @"lgr",DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:shortNameDic];
    [shortNameDic release];
    
    NSDictionary *engishNameDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   @"英文名", DATA_SHOW_TITLE_COLUM,
                                   @"henry",DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:engishNameDic];
    [engishNameDic release];
    
    NSDictionary *originalNameDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     @"原始姓名", DATA_SHOW_TITLE_COLUM,
                                     @"李光荣",DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:originalNameDic];
    [originalNameDic release];
    
    NSDictionary *originalPhoneDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      @"原始电话", DATA_SHOW_TITLE_COLUM,
                                      @"13987232311",DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:originalPhoneDic];
    [originalPhoneDic release];
    
    NSDictionary *certTypeDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"证件类型", DATA_SHOW_TITLE_COLUM,
                             @"身份证",DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:certTypeDic];
    [certTypeDic release];
    
    NSDictionary *certIDDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"证件号码", DATA_SHOW_TITLE_COLUM,
                             @"330521212312313213",DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:certIDDic];
    [certIDDic release];
    
    NSDictionary *startDateDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"出生日期", DATA_SHOW_TITLE_COLUM,
                             @"1982-3-21",DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:startDateDic];
    [startDateDic release];
    
    NSDictionary *countyDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"国籍", DATA_SHOW_TITLE_COLUM,
                             @"中国",DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:countyDic];
    [countyDic release];
    
    NSDictionary *areaDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"区域", DATA_SHOW_TITLE_COLUM,
                             @"",DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:areaDic];
    [areaDic release];
    
    NSDictionary *professDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"职业", DATA_SHOW_TITLE_COLUM,
                             @"李光荣",DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:professDic];
    [professDic release];
    
    NSDictionary *companyDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"公司", DATA_SHOW_TITLE_COLUM,
                             @"浙江省杭州市西湖区天目山路278号黄龙时代广场A座1006室很干净啊金卡双方都阿娇款到发货",DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:companyDic];
    [companyDic release];
    
    NSDictionary *addressDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"联系地址", DATA_SHOW_TITLE_COLUM,
                             @"浙江省杭州市西湖区天目山路278号黄龙时代广场A座1006室",DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:addressDic];
    [addressDic release];
    
    NSDictionary *businessDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"行业", DATA_SHOW_TITLE_COLUM,
                             @"李光荣",DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:businessDic];
    [businessDic release];
    
    NSDictionary *sexDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"性别", DATA_SHOW_TITLE_COLUM,
                             @"李光荣",DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:sexDic];
    [sexDic release];
    
    NSDictionary *marryDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"婚否", DATA_SHOW_TITLE_COLUM,
                             @"俩大",DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:marryDic];
    [marryDic release];
    
    NSDictionary *educationDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"学历", DATA_SHOW_TITLE_COLUM,
                             @"俩大",DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:educationDic];
    [educationDic release];
    
    NSDictionary *postNumberDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"邮政编码", DATA_SHOW_TITLE_COLUM,
                             @"李光荣",DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:postNumberDic];
    [postNumberDic release];
    
    
    NSDictionary *companyPhoneDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"办公电话", DATA_SHOW_TITLE_COLUM,
                             @"俩大",DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:companyPhoneDic];
    [companyPhoneDic release];
    
    NSDictionary *homePhoneDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"家庭电话", DATA_SHOW_TITLE_COLUM,
                             @"李光荣",DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:homePhoneDic];
    [homePhoneDic release];
    
    NSDictionary *chuanzhenDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"传真", DATA_SHOW_TITLE_COLUM,
                             @"13321314132",DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:chuanzhenDic];
    [chuanzhenDic release];
    
    NSDictionary *emailDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"电子邮件", DATA_SHOW_TITLE_COLUM,
                             @"俩大",DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:emailDic];
    [emailDic release];
    
    NSDictionary *jzjdDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"进展阶段", DATA_SHOW_TITLE_COLUM,
                             @"李光荣",DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:jzjdDic];
    [jzjdDic release];
    
    NSDictionary *remarkDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"备注", DATA_SHOW_TITLE_COLUM,
                             @"爱撒娇的安静的会计师阿娇打飞机打分卡阿加咖啡的权利啊见附件按甲方的",DATA_SHOW_VALUE_COLUM,nil];
    [infoList addObject:remarkDic];
    [remarkDic release];
    
    self.customerInfoDataList = infoList;
    [infoList release];
}

- (void)assembConcactHistoryData
{
    NSMutableArray *historyList = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i<5; i++) {
        NSMutableArray *historyOneItem = [[NSMutableArray alloc] initWithCapacity:0];
        NSDictionary *dateDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"日期",DATA_SHOW_TITLE_COLUM,
                                 @"2014-6-1",DATA_SHOW_VALUE_COLUM ,nil];
        [historyOneItem addObject:dateDic];
        [dateDic release];
        
        NSDictionary *typeDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"类型",DATA_SHOW_TITLE_COLUM,
                                 @"来访",DATA_SHOW_VALUE_COLUM,nil];
        [historyOneItem addObject:typeDic];
        [typeDic release];
        
        NSDictionary *willingnessDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        @"购买意向",DATA_SHOW_TITLE_COLUM,
                                        @"初步意向",DATA_SHOW_VALUE_COLUM,nil];
        [historyOneItem addObject:willingnessDic];
        [willingnessDic release];
        
        NSDictionary *peopleDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   @"黄卓瑜",DATA_SHOW_VALUE_COLUM,
                                   @"接待人",DATA_SHOW_TITLE_COLUM, nil];
        [historyOneItem addObject:peopleDic];
        [peopleDic release];
        
        NSDictionary *remarkDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   @"备注",DATA_SHOW_TITLE_COLUM,
                                   @"阿卡基督教啊就卡丁车啊数控技术",DATA_SHOW_VALUE_COLUM,nil];
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
    if (self.contentView != nil  && self.contentControl != nil) {
        if(scrollView == self.contentView){
            CGFloat pageWidth = scrollView.frame.size.width;
            int page1 = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
            self.contentControl.currentPage = page1;
        }
    }
}

#pragma mark
#pragma mark - UIAction
- (void)handlePageControlFrom:(id)sender
{
    UIPageControl *pageControl = (UIPageControl *)sender;
    NSInteger page = pageControl.currentPage;
    CGPoint currentPoint = self.contentView.contentOffset;
    [self.contentView setContentOffset:CGPointMake(DEVICE_MAINSCREEN_WIDTH*page, currentPoint.y) animated:YES];
}


@end

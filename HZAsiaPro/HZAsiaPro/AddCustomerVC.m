//
//  AddCustomerVC.m
//  HZAsiaPro
//
//  Created by wuhui on 15/6/15.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "AddCustomerVC.h"
#import "AddCustomerView.h"
#import "ItemPickerView.h"
#import "MyDatePickerView.h"
#import "bussineDataService.h"

#define ALTER_SUCCESS_BACK_TAG  201

typedef enum ClickedView {
    click_basic,
    click_contact,
} ClickedView;

@interface AddCustomerVC ()<MyDatePickerViewDelegate,
                            ItemPickerDelegate,
                            AddCustomerViewDelegate,
                            UIScrollViewDelegate,
                            HttpBackDelegate,
                            AlertShowViewDelegate,
                            UIAlertViewDelegate>
{
    AddCustomerView *basicInfoView;
    AddCustomerView *contactInfoView;
    UIScrollView *contentView;
    UIPageControl *contentControl;
    NSMutableArray *plusShowDataList;
    NSMutableArray *contactShowDataList;
    
    MyDatePickerView *datePicker;
    ItemPickerView *itemPicker;
    
    
    ClickedView currentShowView;
}
@property (nonatomic ,retain)NSMutableArray *plusShowDataList;
@property (nonatomic ,retain)NSMutableArray *contactShowDataList;
@property (nonatomic ,retain)AddCustomerView *basicInfoView;
@property (nonatomic ,retain)AddCustomerView *contactInfoView;
@property (nonatomic ,retain)UIScrollView *contentView;
@property (nonatomic ,retain)UIPageControl *contentControl;
@property (nonatomic ,retain)MyDatePickerView *datePicker;
@property (nonatomic ,retain)ItemPickerView *itemPicker;
@property (nonatomic ,assign)ClickedView currentShowView;
@end

@implementation AddCustomerVC

@synthesize plusShowDataList;
@synthesize contactShowDataList;

@synthesize basicInfoView;
@synthesize contactInfoView;

@synthesize itemPicker;
@synthesize datePicker;

@synthesize contentControl;
@synthesize contentView;

@synthesize currentShowView;

@synthesize customerInsertInfo;

- (void)dealloc
{
    [datePicker release];
    [itemPicker release];
    
    [basicInfoView release];
    [contactInfoView release];
    [plusShowDataList release];
    [contactShowDataList release];
    
    [contentView release];
    [contentControl release];
    
    if (customerInsertInfo != nil) {
        [customerInsertInfo release];
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
    self.title = @"新增客户";
    
    [self setNavBarCommitItem];
    
    [self layoutContentView];
    
    [self initData];
    
    [self.basicInfoView reloadCustomerView:self.plusShowDataList WithShowSection:@"客户基本信息"];
    [self.contactInfoView reloadCustomerView:self.contactShowDataList WithShowSection:@"客户本次接洽信息"];
    
    ItemPickerView *searchItemPicker = [[ItemPickerView alloc] initWithFrame:CGRectMake(0, DEVICE_MAINSCREEN_HEIGHT-220-DEVICE_TABBAR_HEIGTH+9, DEVICE_MAINSCREEN_WIDTH, 220)];
    searchItemPicker.delegate = self;
    self.itemPicker = searchItemPicker;
    [self.view addSubview:searchItemPicker];
    [searchItemPicker release];
    
    MyDatePickerView *datePickerView = [[MyDatePickerView alloc]initWithFrame:CGRectMake(0, DEVICE_MAINSCREEN_HEIGHT-220-DEVICE_TABBAR_HEIGTH+9, DEVICE_MAINSCREEN_WIDTH, 220)];
    datePickerView.delegate = self;
    self.datePicker = datePickerView;
    [self.view addSubview:datePickerView];
    [datePickerView release];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


- (void)layoutContentView
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.scrollEnabled = YES;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    self.contentView = scrollView;
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.equalTo(self.view);
    }];
    [scrollView release];
    
    
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
    pageControl.backgroundColor = [UIColor clearColor];
    pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    pageControl.userInteractionEnabled = NO;
//    [pageControl addTarget:self
//                    action:@selector(handlePageControlFrom:)
//          forControlEvents:UIControlEventValueChanged];
//    
    [self.view addSubview:pageControl];
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom).with.offset(-80.0f);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(30.0f);
    }];
    self.contentControl = pageControl;
    [pageControl release];
    
    
    AddCustomerView  *customerView = [[AddCustomerView alloc] init];
    customerView.backgroundColor = [UIColor whiteColor];
    customerView.delegate = self;
    customerView.initContentY = 64.0f;
    self.basicInfoView = customerView;
    [self.contentView addSubview:customerView];
    [customerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView);
        make.width.equalTo(self.contentView);
        make.height.equalTo(self.contentView).with.offset(-DEVICE_TABBAR_HEIGTH-64);
    }];
    [customerView release];
    
    AddCustomerView  *contactView = [[AddCustomerView alloc] init];
    contactView.backgroundColor = [UIColor whiteColor];
    contactView.delegate = self;
    customerView.initContentY = 64.0f;
    self.contactInfoView = contactView;
    [self.contentView addSubview:contactView];
    [contactView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.basicInfoView.mas_right);
        make.width.equalTo(self.contentView);
        make.height.equalTo(self.contentView).with.offset(-DEVICE_TABBAR_HEIGTH-64);
    }];
    [contactView release];
    
    [self.contentView setContentSize:CGSizeMake(DEVICE_MAINSCREEN_WIDTH*2, DEVICE_MAINSCREEN_HEIGHT-64-DEVICE_TABBAR_HEIGTH)];
    
    [self.contentControl setNumberOfPages:2];
    [self.view bringSubviewToFront:self.contentControl];

}


- (void)closeViewResponse
{
    [self.datePicker dismiss];
    [self.itemPicker dismiss];
}

- (void)setNavBarCommitItem
{
    UIBarButtonItem *commitItem = [[UIBarButtonItem alloc] initWithTitle:@"上报审批"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(commitClicked:)];
    self.navigationItem.rightBarButtonItem = commitItem;
    [commitItem release];
}

- (void)commitClicked:(id)sender
{
    NSDictionary *customerInfoDic = [self.basicInfoView commitGetAllCustomerData];
    if (customerInfoDic != nil) {
        NSDictionary *customerContractDic = [self.contactInfoView commitGetAllCustomerData];
        if (customerContractDic != nil) {
            //启动接口
            NSString *clientType = [self.customerInsertInfo objectForKey:@"clientType"];
            if ([clientType isEqualToString:@"1"]) {
                //企业用户
                [self sendInsertBusinessMessage:customerContractDic];
            }else{
                //个人用户
                [self sendInsertIndvialMessage:customerContractDic];
            }
        }
    }
    
}

#pragma mark
#pragma mark - SendHttpMessage
//新增企业用户
- (void)sendInsertBusinessMessage:(NSDictionary *)basicInfo
{
    NSString *cname = [basicInfo objectForKey:@"公司名称"];
    NSString *mobile = [basicInfo objectForKey:@"联系电话"];
    NSString *shortforname = [basicInfo objectForKey:@"公司简称"];
    NSString *faren = [basicInfo objectForKey:@"法人代表"];
    NSString *contact = [basicInfo objectForKey:@"联系人"];
    NSString *steps = [basicInfo objectForKey:@"进展阶段"];
    NSString *zhcaddr = [basicInfo objectForKey:@"注册地址"];
    
    NSString *zczj =  [basicInfo objectForKey:@"注册资金"];
    NSNumber *zhcprice =  [NSNumber numberWithInteger:[zczj integerValue]];//要数字特殊处理
    
    NSString *jyfanwei = [basicInfo objectForKey:@"经营范围"];
    NSString *hyxingzhi = [basicInfo objectForKey:@"行业性质"];
    NSString *hypaiming = [basicInfo objectForKey:@"行业排名"];
    NSString *shjhuguan = [basicInfo objectForKey:@"税籍户管"];
    NSString *idStr = [basicInfo objectForKey:@"工商执照号"];
    NSString *shwno = [basicInfo objectForKey:@"税务执照号"];
    NSString *shwcode = [basicInfo objectForKey:@"税务代码"];
    NSString *address = [basicInfo objectForKey:@"经营地址"];
    NSString *jyqixian = [basicInfo objectForKey:@"经营期限"];
    NSString *post = [basicInfo objectForKey:@"邮政编码"];
    NSString *email = [basicInfo objectForKey:@"E-mail"];
    NSString *fax = [basicInfo objectForKey:@"组织机构代码"];
    NSString *remarks = [basicInfo objectForKey:@"备注"];
    
    
    //创建人
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:CUSTOMER_DATA_BASE_DB];
    NSDictionary *usrInfo = [store getObjectById:CUSTOMER_USERINFO
                                       fromTable:CUSTOMER_DB_TABLE];
    NSString *createBy = [usrInfo objectForKey:@"code"];
    [store release];
    
    NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 
                                 cname,@"cname",
                                 mobile,@"mobile",
                                 shortforname,@"shortforname",
                                 faren,@"faren",
                                 contact,@"contact",
                                 steps,@"steps",
                                 zhcaddr,@"zhcaddr",
                                 zhcprice,@"zhcprice",
                                 jyfanwei,@"jyfanwei",
                                 hyxingzhi,@"hyxingzhi",
                                 hypaiming,@"hypaiming",
                                 shjhuguan,@"shjhuguan",
                                 idStr,@"id",
                                 shwno,@"shwno",
                                 shwcode,@"shwcode",
                                 address,@"address",
                                 jyqixian,@"jyqixian",
                                 post,@"post",
                                 email,@"email",
                                 fax,@"fax",
                                 remarks,@"remarks",
                                 createBy,@"createBy",
                                 nil];
    bussineDataService *bussineService = [bussineDataService sharedDataService];
    bussineService.target = self;
    [bussineService insertCustomer:requestData];
    [requestData release];
}

//新增个人用户
- (void)sendInsertIndvialMessage:(NSDictionary *)basicInfo
{
    
    NSString *cname = [basicInfo objectForKey:@"客户姓名"];
    NSString *shortforname = [basicInfo objectForKey:@"缩写"];
    NSString *enname = [basicInfo objectForKey:@"英文名"];
    NSString *sex = [basicInfo objectForKey:@"性别"];
    NSString *mobile = [basicInfo objectForKey:@"移动电话"];
    NSString *idtype = [basicInfo objectForKey:@"证件类型"];
    NSString *idStr = [basicInfo objectForKey:@"证件号码"];
    NSString *steps = [basicInfo objectForKey:@"进展阶段"];
    NSString *birthdayStr = [basicInfo objectForKey:@"出生日期"];
    NSString *business = [basicInfo objectForKey:@"职业"];
    NSString *company = [basicInfo objectForKey:@"公司"];
    NSString *address = [basicInfo objectForKey:@"联系地址"];
    NSString *hangye = [basicInfo objectForKey:@"行业"];
    NSString *marige = [basicInfo objectForKey:@"婚否"];
    NSString *xueli = [basicInfo objectForKey:@"学历"];
    NSString *remarks = [basicInfo objectForKey:@"备注"];
    
    //创建人
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:CUSTOMER_DATA_BASE_DB];
    NSDictionary *usrInfo = [store getObjectById:CUSTOMER_USERINFO
                                       fromTable:CUSTOMER_DB_TABLE];
    NSString *createBy = [usrInfo objectForKey:@"code"];
    [store release];
    
    NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 cname,@"cname",
                                 shortforname,@"shortforname",
                                 enname,@"enname",
                                 sex,@"sex",
                                 mobile,@"mobile",
                                 idtype,@"idtype",
                                 idStr,@"id",
                                 steps,@"steps",
                                 company,@"company",
                                 business,@"business",
                                 address,@"address",
                                 hangye,@"hangye",
                                 marige,@"marige",
                                 xueli,@"xueli",
                                 remarks,@"remarks",
                                 createBy,@"createBy",
                                 birthdayStr,@"birthdayStr",
                                 nil];
    
    bussineDataService *bussineService = [bussineDataService sharedDataService];
    bussineService.target = self;
    [bussineService insertCustomer:requestData];
    [requestData release];
}

#pragma mark
#pragma mark - 初始化数据
- (void)initData
{
    NSString *clientType = [self.customerInsertInfo objectForKey:@"clientType"];
    if ([clientType isEqualToString:@"1"]) {
        //企业用户
        [self assembBussinessCustomerInfo];
    }else{
        //个人用户
        [self assembInvidualCustomerInfo];
    }
}

//组装个人信息
- (void)assembInvidualCustomerInfo
{
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:CUSTOMER_DATA_BASE_DB];
    //布局基本信息
    NSMutableArray *itemList = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableDictionary *nameDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                    @"客户姓名",PLUS_CUSTOMER_TITLE,
                                    CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,
                                    PUT_FORCE_YES,PLUS_VALUE_IS_PUT_FORCE,
                                    [self.customerInsertInfo objectForKey:@"cname"],PLUS_INIT_VALUE,nil];
    [itemList addObject:nameDic];
    [nameDic release];
    
    NSMutableDictionary *suoxieDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      @"缩写", PLUS_CUSTOMER_TITLE,
                                      CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,nil];
    [itemList addObject:suoxieDic];
    [suoxieDic release];
    
    NSMutableDictionary *engishNameDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                          @"英文名", PLUS_CUSTOMER_TITLE,
                                          CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,nil];
    [itemList addObject:engishNameDic];
    [engishNameDic release];
    
    
    //布局性别数据源
    NSDictionary *sexData0 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @"",SOURCE_DATA_NAME_COULUM,
                                @"",SOURCE_DATA_ID_COLUM,nil];
    NSDictionary *sexData1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"男",SOURCE_DATA_NAME_COULUM,
                              @"男",SOURCE_DATA_ID_COLUM,nil];
    NSDictionary *sexData2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"女",SOURCE_DATA_NAME_COULUM,
                              @"女",SOURCE_DATA_ID_COLUM, nil];
    NSArray *sexSource = [[NSArray alloc] initWithObjects:sexData0,sexData1,sexData2, nil];
    [sexData1 release];
    [sexData2 release];
    [sexData0 release];
    
    NSMutableDictionary *sexDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                   @"性别",PLUS_CUSTOMER_TITLE,
                                   CUSTOMER_SELECT_TYPE,PLUS_CUSTOMER_TYPE,
                                   sexSource,PLUS_SELECT_DATA_SOURCE,
                                   [NSNumber numberWithInt:0],PLUS_INIT_VALUE,nil];
    [itemList addObject:sexDic];
    [sexDic release];
    [sexSource release];
    
    NSMutableDictionary *phoneDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     @"移动电话", PLUS_CUSTOMER_TITLE,
                                     CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,
                                     [self.customerInsertInfo objectForKey:@"mobile"],PLUS_INIT_VALUE,nil];
    [itemList addObject:phoneDic];
    [phoneDic release];
    
    NSArray *certTypeSourceItem = [store getObjectById:CUSTOMER_ID_TYPE_LIST
                                         fromTable:CUSTOMER_DB_TABLE];
    NSMutableArray *certTypeSource = [[NSMutableArray alloc] initWithArray:certTypeSourceItem
                                                                copyItems:YES];
    NSDictionary *c_oneNoItem = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"",SOURCE_DATA_NAME_COULUM,
                                 @"",SOURCE_DATA_ID_COLUM,nil];
    [certTypeSource insertObject:c_oneNoItem atIndex:0];
    [c_oneNoItem release];

    NSMutableDictionary *certTypeDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                        @"证件类型",PLUS_CUSTOMER_TITLE,
                                        CUSTOMER_SELECT_TYPE,PLUS_CUSTOMER_TYPE,
                                        certTypeSource,PLUS_SELECT_DATA_SOURCE,
                                        [NSNumber numberWithInt:0],PLUS_INIT_VALUE,nil];
    [itemList addObject:certTypeDic];
    [certTypeDic release];
    [certTypeSource release];
    
    NSMutableDictionary *certIDDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      @"证件号码", PLUS_CUSTOMER_TITLE,
                                      CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,nil];
    [itemList addObject:certIDDic];
    [certIDDic release];
    
    //进展阶段数据源
    NSArray *jinzhanSourceItem = [store getObjectById:CUSTOMER_JINZHAN_JIEDUAN_LIST
                                        fromTable:CUSTOMER_DB_TABLE];
    NSMutableArray *jinzhanSource = [[NSMutableArray alloc] initWithArray:jinzhanSourceItem
                                                                 copyItems:YES];
    NSDictionary *j_oneNoItem = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"",SOURCE_DATA_NAME_COULUM,
                                 @"",SOURCE_DATA_ID_COLUM,nil];
    [jinzhanSource insertObject:j_oneNoItem atIndex:0];
    [j_oneNoItem release];

    NSMutableDictionary *jianzhanjieduanDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                               @"进展阶段", PLUS_CUSTOMER_TITLE,
                                               CUSTOMER_SELECT_TYPE,PLUS_CUSTOMER_TYPE,
                                               jinzhanSource,PLUS_SELECT_DATA_SOURCE,
                                               [NSNumber numberWithInteger:0],PLUS_INIT_VALUE,nil];
    [itemList addObject:jianzhanjieduanDic];
    [jianzhanjieduanDic release];
    [jinzhanSource release];
    
    NSMutableDictionary *birthdayDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                        @"出生日期", PLUS_CUSTOMER_TITLE,
                                        CUSTOMER_DATE_SELECT_TYPE,PLUS_CUSTOMER_TYPE,nil];
    [itemList addObject:birthdayDic];
    [birthdayDic release];
    
    NSMutableDictionary *companyDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       @"公司", PLUS_CUSTOMER_TITLE,
                                       CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,nil];
    [itemList addObject:companyDic];
    [companyDic release];
    
    NSMutableDictionary *addressDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       @"联系地址", PLUS_CUSTOMER_TITLE,
                                       CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,nil];
    [itemList addObject:addressDic];
    [addressDic release];
    
    //职业数据源
    NSArray *professionSourceItem = [store getObjectById:CUSTOMER_PROFESSION_LIST
                                           fromTable:CUSTOMER_DB_TABLE];
    NSMutableArray *professionSource = [[NSMutableArray alloc] initWithArray:professionSourceItem
                                                                copyItems:YES];
    NSDictionary *p_oneNoItem = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"",SOURCE_DATA_NAME_COULUM,
                                 @"",SOURCE_DATA_ID_COLUM,nil];
    [professionSource insertObject:p_oneNoItem atIndex:0];
    [p_oneNoItem release];

    NSMutableDictionary *professionDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                          @"职业", PLUS_CUSTOMER_TITLE,
                                          CUSTOMER_SELECT_TYPE,PLUS_CUSTOMER_TYPE,
                                          professionSource,PLUS_SELECT_DATA_SOURCE,
                                          [NSNumber numberWithInt:0],PLUS_INIT_VALUE,nil];
    [itemList addObject:professionDic];
    [professionDic release];
    [professionSource release];
    
    //行业数据源
    NSArray *hangyeSourceItem = [store getObjectById:CUSTOMER_INDUSTRY_LIST
                                       fromTable:CUSTOMER_DB_TABLE];
    NSMutableArray *hangyeSource = [[NSMutableArray alloc] initWithArray:hangyeSourceItem
                                                                   copyItems:YES];
    NSDictionary *h_oneNoItem = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"",SOURCE_DATA_NAME_COULUM,
                                 @"",SOURCE_DATA_ID_COLUM,nil];
    [hangyeSource insertObject:h_oneNoItem atIndex:0];
    [h_oneNoItem release];

    NSMutableDictionary *hangyeDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      @"行业", PLUS_CUSTOMER_TITLE,
                                      CUSTOMER_SELECT_TYPE,PLUS_CUSTOMER_TYPE,
                                      hangyeSource,PLUS_SELECT_DATA_SOURCE,
                                      [NSNumber numberWithInteger:0],PLUS_INIT_VALUE,nil];
    [itemList addObject:hangyeDic];
    [hangyeDic release];
    [hangyeSource release];
    
    //婚烟数据源
    NSDictionary *marry1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                            @"",SOURCE_DATA_NAME_COULUM,
                            @"",SOURCE_DATA_ID_COLUM, nil];
    NSDictionary *marry2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                            @"已婚",SOURCE_DATA_NAME_COULUM,
                            @"已婚",SOURCE_DATA_ID_COLUM, nil];
    NSDictionary *marry3 = [[NSDictionary alloc] initWithObjectsAndKeys:
                            @"未婚",SOURCE_DATA_NAME_COULUM,
                            @"未婚",SOURCE_DATA_ID_COLUM, nil];
    NSArray *marrySource = [[NSArray alloc] initWithObjects:marry1,marry2,marry3, nil];
    [marry1 release];[marry2 release];[marry3 release];
    
    NSMutableDictionary *marryDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     @"婚否", PLUS_CUSTOMER_TITLE,
                                     CUSTOMER_SELECT_TYPE,PLUS_CUSTOMER_TYPE,
                                     marrySource,PLUS_SELECT_DATA_SOURCE,
                                     [NSNumber numberWithInteger:0],PLUS_INIT_VALUE,nil];
    [itemList addObject:marryDic];
    [marryDic release];
    [marrySource release];
    
    //学历数据源
    NSArray *xueliSourceItem = [store getObjectById:CUSTOMER_EDUCATION_LIST
                                      fromTable:CUSTOMER_DB_TABLE];
    
    NSMutableArray *xueliSource = [[NSMutableArray alloc] initWithArray:xueliSourceItem
                                                               copyItems:YES];
    NSDictionary *x_oneNoItem = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"",SOURCE_DATA_NAME_COULUM,
                                 @"",SOURCE_DATA_ID_COLUM,nil];
    [xueliSource insertObject:x_oneNoItem atIndex:0];
    [x_oneNoItem release];
    
    NSMutableDictionary *xueliDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     @"学历", PLUS_CUSTOMER_TITLE,
                                     CUSTOMER_SELECT_TYPE,PLUS_CUSTOMER_TYPE,
                                     xueliSource,PLUS_SELECT_DATA_SOURCE,
                                     [NSNumber numberWithInt:0],PLUS_INIT_VALUE,nil];
    [itemList addObject:xueliDic];
    [xueliDic release];
    [xueliSource release];
    
    NSMutableDictionary *remarkDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      @"备注",PLUS_CUSTOMER_TITLE,
                                      CUSTOMER_TEXTVIEW_TYPE,PLUS_CUSTOMER_TYPE,nil];
    [itemList addObject:remarkDic];
    [remarkDic release];
    
    self.plusShowDataList = itemList;
    [itemList release];
    
    
    //布局洽谈信息
    NSMutableArray *contactList = [[NSMutableArray alloc] initWithCapacity:0];
    
    //联系方式数据源
    
    NSArray *contactTypeSource = [store getObjectById:CUSTOMER_VISIT_TYPE_LIST
                                            fromTable:CUSTOMER_DB_TABLE];
    
    NSMutableDictionary *contactTypeDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                           @"联系类型",PLUS_CUSTOMER_TITLE,
                                           CUSTOMER_SELECT_TYPE,PLUS_CUSTOMER_TYPE,
                                           contactTypeSource,PLUS_SELECT_DATA_SOURCE,
                                           [NSNumber numberWithInt:0],PLUS_INIT_VALUE,nil];
    [contactList addObject:contactTypeDic];
    [contactTypeDic release];
    [contactTypeSource release];
    
    //购买意向数据源
    NSArray *purposeSourceItem = [store getObjectById:CUSTOMER_PURPOSE_LIST
                                        fromTable:CUSTOMER_DB_TABLE];
    NSMutableArray *purposeSource = [[NSMutableArray alloc] initWithArray:purposeSourceItem
                                                              copyItems:YES];
    NSDictionary *p_oneNoItem1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"",SOURCE_DATA_NAME_COULUM,
                                 @"",SOURCE_DATA_ID_COLUM,nil];
    [purposeSource insertObject:p_oneNoItem1 atIndex:0];
    [p_oneNoItem1 release];

    NSMutableDictionary *purposeDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       @"购买意向",PLUS_CUSTOMER_TITLE,
                                       CUSTOMER_SELECT_TYPE,PLUS_CUSTOMER_TYPE,
                                       purposeSource,PLUS_SELECT_DATA_SOURCE,
                                       [NSNumber numberWithInteger:0],PLUS_INIT_VALUE,
                                       PUT_FORCE_YES,PLUS_VALUE_IS_PUT_FORCE,nil];
    [contactList addObject:purposeDic];
    [purposeDic release];
    [purposeSource release];
    
    //来访形式数据源
    NSDictionary *visitType1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @"单独",SOURCE_DATA_NAME_COULUM,
                                @"单独",SOURCE_DATA_ID_COLUM,nil];
    NSDictionary *visitType2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @"夫妻",SOURCE_DATA_NAME_COULUM,
                                @"夫妻",SOURCE_DATA_ID_COLUM,nil];
    NSDictionary *visitType3 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @"与家人",SOURCE_DATA_NAME_COULUM,
                                @"与家人",SOURCE_DATA_ID_COLUM,nil];
    NSDictionary *visitType4 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @"与朋友",SOURCE_DATA_NAME_COULUM,
                                @"与朋友",SOURCE_DATA_ID_COLUM,nil];
    NSArray *visitTypeSource = [[NSArray alloc] initWithObjects:
                                visitType1,visitType2,visitType3,visitType4, nil];
    [visitType4 release];[visitType1 release]; [visitType2 release];[visitType3 release];
    
    NSMutableDictionary *visitTypeDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                         @"来访形式",PLUS_CUSTOMER_TITLE,
                                         CUSTOMER_SELECT_TYPE,PLUS_CUSTOMER_TYPE,
                                         visitTypeSource,PLUS_SELECT_DATA_SOURCE,
                                         [NSNumber numberWithInt:0],PLUS_INIT_VALUE,nil];
    [contactList addObject:visitTypeDic];
    [visitTypeDic release];
    [visitTypeSource release];
    
    NSMutableDictionary *visitPeopleDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                           @"来访人数", PLUS_CUSTOMER_TITLE,
                                           CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,
                                           @"1",PLUS_INIT_VALUE,nil];
    [contactList addObject:visitPeopleDic];
    [visitPeopleDic release];
    
    //来访频率数据源
    NSDictionary *visitNum1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"初访",SOURCE_DATA_NAME_COULUM,
                               @"初访",SOURCE_DATA_ID_COLUM,nil];
    NSDictionary *visitNum2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"再访",SOURCE_DATA_NAME_COULUM,
                               @"再访",SOURCE_DATA_ID_COLUM,nil];
    NSDictionary *visitNum3 = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"其他",SOURCE_DATA_NAME_COULUM,
                               @"其他",SOURCE_DATA_ID_COLUM,nil];
    NSArray *visitNumSource = [[NSArray alloc] initWithObjects:visitNum1,visitNum2,visitNum3, nil];
    [visitNum1 release];[visitNum2 release];[visitNum3 release];
    
    NSMutableDictionary *visitNumDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                        @"来访频率",PLUS_CUSTOMER_TITLE,
                                        CUSTOMER_SELECT_TYPE,PLUS_CUSTOMER_TYPE,
                                        visitNumSource,PLUS_SELECT_DATA_SOURCE,
                                        [NSNumber numberWithInt:0],PLUS_INIT_VALUE,nil];
    [contactList addObject:visitNumDic];
    [visitNumDic release];
    [visitNumSource release];
    
    NSMutableDictionary *contactRemarkDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                             @"备注",PLUS_CUSTOMER_TITLE,
                                             CUSTOMER_TEXTVIEW_TYPE,PLUS_CUSTOMER_TYPE,nil];
    [contactList addObject:contactRemarkDic];
    [contactRemarkDic release];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *initDate = [df stringFromDate:[NSDate date]];
    
    NSMutableDictionary *contactDateDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                           @"日期",PLUS_CUSTOMER_TITLE,
                                           CUSTOMER_DATE_SELECT_TYPE,PLUS_CUSTOMER_TYPE,
                                           initDate,PLUS_INIT_VALUE,
                                           PUT_FORCE_YES,PLUS_VALUE_IS_PUT_FORCE,nil];
    [contactList addObject:contactDateDic];
    [contactDateDic release];
    [df release];
    
//    NSMutableDictionary *contactTimeDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
//                                           @"时间",PLUS_CUSTOMER_TITLE,
//                                           CUSTOMER_TIME_SELECT_TYPE,PLUS_CUSTOMER_TYPE,nil];
//    [contactList addObject:contactTimeDic];
//    [contactTimeDic release];
//    
//    NSMutableDictionary *contactPhoneDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
//                                            @"接待人员",PLUS_CUSTOMER_TITLE,
//                                            CUSTOMER_SELECT_TYPE,PLUS_CUSTOMER_TYPE,nil];
//    [contactList addObject:contactPhoneDic];
//    [contactPhoneDic release];
    
    self.contactShowDataList = contactList;
    [contactList release];
    
    [store release];
    

}

//组装企业信息
- (void)assembBussinessCustomerInfo
{
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:CUSTOMER_DATA_BASE_DB];
    //布局基本信息
    NSMutableArray *itemList = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableDictionary *nameDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                    @"公司名称",PLUS_CUSTOMER_TITLE,
                                    CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,
                                    PUT_FORCE_YES,PLUS_VALUE_IS_PUT_FORCE,
                                    [self.customerInsertInfo objectForKey:@"cname"],PLUS_INIT_VALUE,nil];
    [itemList addObject:nameDic];
    [nameDic release];
    
    NSMutableDictionary *suoxieDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      @"公司简称", PLUS_CUSTOMER_TITLE,
                                      CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,nil];
    [itemList addObject:suoxieDic];
    [suoxieDic release];
    
    NSMutableDictionary *phoneDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     @"联系电话", PLUS_CUSTOMER_TITLE,
                                     CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,
                                     [self.customerInsertInfo objectForKey:@"mobile"],PLUS_INIT_VALUE,nil];
    [itemList addObject:phoneDic];
    [phoneDic release];
    
    //进展阶段数据源
    NSArray *jinzhanSourceItem = [store getObjectById:CUSTOMER_JINZHAN_JIEDUAN_LIST
                                        fromTable:CUSTOMER_DB_TABLE];
    
    NSMutableArray *jinzhanSource = [[NSMutableArray alloc] initWithArray:jinzhanSourceItem
                                                               copyItems:YES];
    NSDictionary *j_oneNoItem = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"",SOURCE_DATA_NAME_COULUM,
                               @"",SOURCE_DATA_ID_COLUM,nil];
    [jinzhanSource insertObject:j_oneNoItem atIndex:0];
    [j_oneNoItem release];
    
    NSMutableDictionary *jianzhanjieduanDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                               @"进展阶段", PLUS_CUSTOMER_TITLE,
                                               CUSTOMER_SELECT_TYPE,PLUS_CUSTOMER_TYPE,
                                               jinzhanSource,PLUS_SELECT_DATA_SOURCE,
                                               [NSNumber numberWithInteger:1],PLUS_INIT_VALUE,nil];
    [itemList addObject:jianzhanjieduanDic];
    [jianzhanjieduanDic release];
    
    NSMutableDictionary *engishNameDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                          @"法人代表", PLUS_CUSTOMER_TITLE,
                                          CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,nil];
    [itemList addObject:engishNameDic];
    [engishNameDic release];
    
    NSMutableDictionary *certIDDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      @"联系人", PLUS_CUSTOMER_TITLE,
                                      CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,nil];
    [itemList addObject:certIDDic];
    [certIDDic release];
    
    NSMutableDictionary *birthdayDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                        @"注册地址", PLUS_CUSTOMER_TITLE,
                                        CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,nil];
    [itemList addObject:birthdayDic];
    [birthdayDic release];
    
    NSMutableDictionary *companyDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       @"注册资金", PLUS_CUSTOMER_TITLE,
                                       CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,nil];
    [itemList addObject:companyDic];
    [companyDic release];
    
    NSMutableDictionary *addressDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       @"经营范围", PLUS_CUSTOMER_TITLE,
                                       CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,nil];
    [itemList addObject:addressDic];
    [addressDic release];
    
    //行业数据源
    NSArray *hangyeSourceItem = [store getObjectById:CUSTOMER_INDUSTRY_LIST
                                       fromTable:CUSTOMER_DB_TABLE];
    NSMutableArray *hangyeSource = [[NSMutableArray alloc] initWithArray:hangyeSourceItem
                                                               copyItems:YES];
    NSDictionary *oneNoItem = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"",SOURCE_DATA_NAME_COULUM,
                               @"",SOURCE_DATA_ID_COLUM,nil];
    [hangyeSource insertObject:oneNoItem atIndex:0];
    [oneNoItem release];
    
    NSMutableDictionary *hangyeDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      @"行业性质", PLUS_CUSTOMER_TITLE,
                                      CUSTOMER_SELECT_TYPE,PLUS_CUSTOMER_TYPE,
                                      hangyeSource,PLUS_SELECT_DATA_SOURCE,
                                      [NSNumber numberWithInteger:0],PLUS_INIT_VALUE,nil];
    [itemList addObject:hangyeDic];
    [hangyeDic release];
    [hangyeSource release];
    
    
    NSMutableDictionary *hypmDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       @"行业排名", PLUS_CUSTOMER_TITLE,
                                       CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,nil];
    [itemList addObject:hypmDic];
    [hypmDic release];
    
    NSMutableDictionary *sjhgDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       @"税籍户管", PLUS_CUSTOMER_TITLE,
                                       CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,nil];
    [itemList addObject:sjhgDic];
    [sjhgDic release];
    
    NSMutableDictionary *gszzhDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       @"工商执照号", PLUS_CUSTOMER_TITLE,
                                       CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,nil];
    [itemList addObject:gszzhDic];
    [gszzhDic release];
    
    NSMutableDictionary *swzzhDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       @"税务执照号", PLUS_CUSTOMER_TITLE,
                                       CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,nil];
    [itemList addObject:swzzhDic];
    [swzzhDic release];
    
    NSMutableDictionary *swdmDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       @"税务代码", PLUS_CUSTOMER_TITLE,
                                       CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,nil];
    [itemList addObject:swdmDic];
    [swdmDic release];
    
    NSMutableDictionary *jydzDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       @"经营地址", PLUS_CUSTOMER_TITLE,
                                       CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,nil];
    [itemList addObject:jydzDic];
    [jydzDic release];
    
    NSMutableDictionary *jyqxDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       @"经营期限", PLUS_CUSTOMER_TITLE,
                                       CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,nil];
    [itemList addObject:jyqxDic];
    [jyqxDic release];
    
    NSMutableDictionary *jyfwDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       @"经营范围", PLUS_CUSTOMER_TITLE,
                                       CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,nil];
    [itemList addObject:jyfwDic];
    [jyfwDic release];
    
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       @"邮政编码", PLUS_CUSTOMER_TITLE,
                                       CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,nil];
    [itemList addObject:postDic];
    [postDic release];
    
    NSMutableDictionary *emailDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       @"E-mail", PLUS_CUSTOMER_TITLE,
                                       CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,nil];
    [itemList addObject:emailDic];
    [emailDic release];
    
    NSMutableDictionary *zjjgdmDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       @"组织机构代码", PLUS_CUSTOMER_TITLE,
                                       CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,nil];
    [itemList addObject:zjjgdmDic];
    [zjjgdmDic release];
    
    NSMutableDictionary *remarkDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      @"备注",PLUS_CUSTOMER_TITLE,
                                      CUSTOMER_TEXTVIEW_TYPE,PLUS_CUSTOMER_TYPE,nil];
    [itemList addObject:remarkDic];
    [remarkDic release];
    
    self.plusShowDataList = itemList;
    [itemList release];
    
    
    //布局洽谈信息
    NSMutableArray *contactList = [[NSMutableArray alloc] initWithCapacity:0];
    
    //联系方式数据源
    NSArray *contactTypeSource = [store getObjectById:CUSTOMER_VISIT_TYPE_LIST
                                            fromTable:CUSTOMER_DB_TABLE];
    
    NSMutableDictionary *contactTypeDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                           @"联系类型",PLUS_CUSTOMER_TITLE,
                                           CUSTOMER_SELECT_TYPE,PLUS_CUSTOMER_TYPE,
                                           contactTypeSource,PLUS_SELECT_DATA_SOURCE,
                                           [NSNumber numberWithInt:0],PLUS_INIT_VALUE,nil];
    [contactList addObject:contactTypeDic];
    [contactTypeDic release];
    [contactTypeSource release];
    
    //购买意向数据源
    NSArray *purposeSourceItem = [store getObjectById:CUSTOMER_PURPOSE_LIST
                                        fromTable:CUSTOMER_DB_TABLE];
    NSMutableArray *purposeSource = [[NSMutableArray alloc] initWithArray:purposeSourceItem
                                                                copyItems:YES];
    NSDictionary *p_oneNoItem1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"",SOURCE_DATA_NAME_COULUM,
                                  @"",SOURCE_DATA_ID_COLUM,nil];
    [purposeSource insertObject:p_oneNoItem1 atIndex:0];
    [p_oneNoItem1 release];
    
    NSMutableDictionary *purposeDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       @"购买意向",PLUS_CUSTOMER_TITLE,
                                       CUSTOMER_SELECT_TYPE,PLUS_CUSTOMER_TYPE,
                                       purposeSource,PLUS_SELECT_DATA_SOURCE,
                                       [NSNumber numberWithInteger:0],PLUS_INIT_VALUE,
                                       PUT_FORCE_YES,PLUS_VALUE_IS_PUT_FORCE,nil];
    [contactList addObject:purposeDic];
    [purposeDic release];
    [purposeSource release];
    
    
    //来访频率数据源
    NSDictionary *visitNum1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"初访",SOURCE_DATA_NAME_COULUM,
                               @"初访",SOURCE_DATA_ID_COLUM,nil];
    NSDictionary *visitNum2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"再访",SOURCE_DATA_NAME_COULUM,
                               @"再访",SOURCE_DATA_ID_COLUM,nil];
    NSDictionary *visitNum3 = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"其他",SOURCE_DATA_NAME_COULUM,
                               @"其他",SOURCE_DATA_ID_COLUM,nil];
    NSArray *visitNumSource = [[NSArray alloc] initWithObjects:visitNum1,visitNum2,visitNum3, nil];
    [visitNum1 release];[visitNum2 release];[visitNum3 release];
    
    NSMutableDictionary *visitNumDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                        @"来访频率",PLUS_CUSTOMER_TITLE,
                                        CUSTOMER_SELECT_TYPE,PLUS_CUSTOMER_TYPE,
                                        visitNumSource,PLUS_SELECT_DATA_SOURCE,
                                        [NSNumber numberWithInt:0],PLUS_INIT_VALUE,nil];
    [contactList addObject:visitNumDic];
    [visitNumDic release];
    [visitNumSource release];
    
    NSMutableDictionary *contactRemarkDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                             @"备注",PLUS_CUSTOMER_TITLE,
                                             CUSTOMER_TEXTVIEW_TYPE,PLUS_CUSTOMER_TYPE,nil];
    [contactList addObject:contactRemarkDic];
    [contactRemarkDic release];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *initDate = [df stringFromDate:[NSDate date]];
    
    NSMutableDictionary *contactDateDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                           @"日期",PLUS_CUSTOMER_TITLE,
                                           CUSTOMER_DATE_SELECT_TYPE,PLUS_CUSTOMER_TYPE,
                                           initDate,PLUS_INIT_VALUE,
                                           PUT_FORCE_YES,PLUS_VALUE_IS_PUT_FORCE,nil];
    [contactList addObject:contactDateDic];
    [contactDateDic release];
    [df release];
    
//    NSMutableDictionary *contactTimeDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
//                                           @"时间",PLUS_CUSTOMER_TITLE,
//                                           CUSTOMER_TIME_SELECT_TYPE,PLUS_CUSTOMER_TYPE,nil];
//    [contactList addObject:contactTimeDic];
//    [contactTimeDic release];
//    
//    NSMutableDictionary *contactPhoneDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
//                                            @"接待人员",PLUS_CUSTOMER_TITLE,
//                                            CUSTOMER_SELECT_TYPE,PLUS_CUSTOMER_TYPE,nil];
//    [contactList addObject:contactPhoneDic];
//    [contactPhoneDic release];
    
    self.contactShowDataList = contactList;
    [contactList release];
    
    [store release];

}

#pragma mark
#pragma mark - ItemPickerDelegate
- (void)viewDidDismiss:(ItemPickerView *)itemView
{
    [[[UIApplication sharedApplication].windows firstObject] willRemoveSubview:self.itemPicker];
}

- (void)itemPickerView:(ItemPickerView *)itemPicker selectRow:(NSInteger)row selectData:(NSString *)itemStr
{
    switch (currentShowView) {
        case click_contact:
        {
            [self.contactInfoView reloadViewDataWithSelectRow:row];
        }
            break;
        case click_basic:
        {
            [self.basicInfoView reloadViewDataWithSelectRow:row];
        }
            break;
        default:
            break;
    }
    
}

#pragma mark
#pragma mark - MyDatePickerViewDelegate
-(void)viewDidDismiss
{
    [[[UIApplication sharedApplication].windows firstObject] willRemoveSubview:self.datePicker];
}
-(void)clickMyDatePickerViewOk:(NSString*)selectedDate
{
    switch (currentShowView) {
        case click_contact:
        {
            [self.contactInfoView reloadViewDataSelectDate:selectedDate];
        }
            break;
        case click_basic:
        {
            [self.basicInfoView reloadViewDataSelectDate:selectedDate];
        }
            break;
        default:
            break;
    }
}

#pragma mark
#pragma mark - AddCustomerViewDelegate
- (void)customerView:(AddCustomerView *)addCustomerView DidShowItemPickerWithRow:(NSInteger)row WithSource:(NSArray *)sourceList
{
    if (addCustomerView == self.basicInfoView) {
        currentShowView = click_basic;
    }else if(addCustomerView == self.contactInfoView){
        currentShowView = click_contact;
    }
    [self.itemPicker reloadPickerData:sourceList];
    [self.itemPicker selectPickerRow:row];
    [self.itemPicker show];
    [[[UIApplication sharedApplication].windows firstObject] addSubview:self.itemPicker];

}

- (void)customerView:(AddCustomerView *)addCustomerView DidShowDate:(UIDatePickerMode)pickerMode
{
    if (addCustomerView == self.basicInfoView) {
        currentShowView = click_basic;
    }else if(addCustomerView == self.contactInfoView){
        currentShowView = click_contact;
    }
    [self.datePicker setDateMode:pickerMode];
    [self.datePicker setMaxDate:[NSDate date]];
    [self.datePicker setMinDate:nil];
    
    [self.datePicker show];
    [[[UIApplication sharedApplication].windows firstObject] addSubview:self.datePicker];

}

- (void)customerViewDidShowTextField:(AddCustomerView *)addCustomerView
{
    [self closeViewResponse];
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
//- (void)handlePageControlFrom:(id)sender
//{
//    UIPageControl *pageControl = (UIPageControl *)sender;
//    NSInteger page = pageControl.currentPage;
//    CGPoint currentPoint = self.contentView.contentOffset;
//    [self.contentView setContentOffset:CGPointMake(DEVICE_MAINSCREEN_WIDTH*page, currentPoint.y) animated:YES];
//}


#pragma mark
#pragma mark - HttpBackDelegate
- (void)requestDidFinished:(NSDictionary *)info
{
    NSString *bussineCode = [info objectForKey:@"bussineCode"];
    NSString *msg = [info objectForKey:@"MSG"];
    NSString *errorCode = [info objectForKey:@"errorCode"];
    if([[InsertClientMessage getBizCode] isEqualToString:bussineCode]){
        if ([errorCode isEqualToString:RESPONE_RESULT_TRUE]) {
            AlertShowView *alert = [[AlertShowView alloc] initWithAlertViewTitle:@"新增客户成功"
                                                                         message:@"您的新增客户请求已经提交,等待管理员审批中,谢谢！"
                                                                        delegate:self
                                                                             tag:ALTER_SUCCESS_BACK_TAG
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
    if([[AddVisitHistoryMessage getBizCode] isEqualToString:bussineCode]){
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
    if(ALTER_SUCCESS_BACK_TAG == alertView.index){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark
#pragma mark - UIAlterViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(ALTER_SUCCESS_BACK_TAG == alertView.tag){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}



@end

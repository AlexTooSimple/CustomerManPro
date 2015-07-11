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

typedef enum ClickedView {
    click_basic,
    click_contact,
} ClickedView;

@interface AddCustomerVC ()<MyDatePickerViewDelegate,
                            ItemPickerDelegate,
                            AddCustomerViewDelegate,
                            UIScrollViewDelegate>
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
        }
    }
    
}

#pragma mark
#pragma mark - 初始化数据
- (void)initData
{
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:CUSTOMER_DATA_BASE_DB];
    //布局基本信息
    NSMutableArray *itemList = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableDictionary *nameDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                    @"客户姓名",PLUS_CUSTOMER_TITLE,
                                    CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,
                                    PUT_FORCE_YES,PLUS_VALUE_IS_PUT_FORCE,nil];
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
    NSDictionary *sexData1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"男",SOURCE_DATA_NAME_COULUM,
                              @"男",SOURCE_DATA_ID_COLUM,nil];
    NSDictionary *sexData2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"女",SOURCE_DATA_NAME_COULUM,
                              @"女",SOURCE_DATA_ID_COLUM, nil];
    NSArray *sexSource = [[NSArray alloc] initWithObjects:sexData1,sexData2, nil];
    [sexData1 release];
    [sexData2 release];
    
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
                                     CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,nil];
    [itemList addObject:phoneDic];
    [phoneDic release];
    
    NSArray *certTypeSource = [store getObjectById:CUSTOMER_ID_TYPE_LIST
                                         fromTable:CUSTOMER_DB_TABLE];
    NSMutableDictionary *certTypeDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                        @"证件类型",PLUS_CUSTOMER_TITLE,
                                        CUSTOMER_SELECT_TYPE,PLUS_CUSTOMER_TYPE,
                                        certTypeSource,PLUS_SELECT_DATA_SOURCE,
                                        [NSNumber numberWithInt:0],PLUS_INIT_VALUE,nil];
    [itemList addObject:certTypeDic];
    [certTypeDic release];
    
    NSMutableDictionary *certIDDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     @"证件号码", PLUS_CUSTOMER_TITLE,
                                     CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,nil];
    [itemList addObject:certIDDic];
    [certIDDic release];
    
    //进展阶段数据源
    NSArray *jinzhanSource = [store getObjectById:CUSTOMER_JINZHAN_JIEDUAN_LIST
                                        fromTable:CUSTOMER_DB_TABLE];
    
    NSMutableDictionary *jianzhanjieduanDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      @"进展阶段", PLUS_CUSTOMER_TITLE,
                                      CUSTOMER_SELECT_TYPE,PLUS_CUSTOMER_TYPE,
                                      jinzhanSource,PLUS_SELECT_DATA_SOURCE,
                                      [NSNumber numberWithInteger:1],PLUS_INIT_VALUE,nil];
    [itemList addObject:jianzhanjieduanDic];
    [jianzhanjieduanDic release];
    
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
    NSArray *professionSource = [store getObjectById:CUSTOMER_PROFESSION_LIST
                                           fromTable:CUSTOMER_DB_TABLE];
    NSMutableDictionary *professionDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      @"职业", PLUS_CUSTOMER_TITLE,
                                      CUSTOMER_SELECT_TYPE,PLUS_CUSTOMER_TYPE,
                                      professionSource,PLUS_SELECT_DATA_SOURCE,
                                      [NSNumber numberWithInt:0],PLUS_INIT_VALUE,nil];
    [itemList addObject:professionDic];
    [professionDic release];
    [professionSource release];
    
    //行业数据源
    NSArray *hangyeSource = [store getObjectById:CUSTOMER_INDUSTRY_LIST
                                       fromTable:CUSTOMER_DB_TABLE];
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
    NSArray *xueliSource = [store getObjectById:CUSTOMER_EDUCATION_LIST
                                      fromTable:CUSTOMER_DB_TABLE];
    
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
    NSArray *purposeSource = [store getObjectById:CUSTOMER_PURPOSE_LIST
                                        fromTable:CUSTOMER_DB_TABLE];
    
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
    
    NSMutableDictionary *contactTimeDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       @"时间",PLUS_CUSTOMER_TITLE,
                                       CUSTOMER_TIME_SELECT_TYPE,PLUS_CUSTOMER_TYPE,nil];
    [contactList addObject:contactTimeDic];
    [contactTimeDic release];
    
    NSMutableDictionary *contactPhoneDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                         @"接待人员",PLUS_CUSTOMER_TITLE,
                                         CUSTOMER_SELECT_TYPE,PLUS_CUSTOMER_TYPE,nil];
    [contactList addObject:contactPhoneDic];
    [contactPhoneDic release];

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




@end

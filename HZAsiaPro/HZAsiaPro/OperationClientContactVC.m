//
//  OperationClientContactVC.m
//  HZAsiaPro
//
//  Created by wuhui on 15/6/21.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "OperationClientContactVC.h"
#import "AddCustomerView.h"
#import "MyDatePickerView.h"
#import "ItemPickerView.h"

@interface OperationClientContactVC ()<AddCustomerViewDelegate,
                                       ItemPickerDelegate,
                                       MyDatePickerViewDelegate>
{
    MyDatePickerView *datePicker;
    ItemPickerView *itemPicker;
    AddCustomerView *contactInfoView;
    
    NSMutableArray *contactShowDataList;
}
@property (nonatomic ,retain)AddCustomerView *contactInfoView;
@property (nonatomic ,retain)MyDatePickerView *datePicker;
@property (nonatomic ,retain)ItemPickerView *itemPicker;
@property (nonatomic ,retain)NSMutableArray *contactShowDataList;

@end

@implementation OperationClientContactVC

@synthesize datePicker;
@synthesize itemPicker;
@synthesize contactInfoView;
@synthesize contactShowDataList;

- (void)dealloc
{
    [datePicker release];
    [itemPicker release];
    [contactInfoView release];
    [contactShowDataList release];

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
    self.title = @"登记客户洽谈信息";
    [self setNavBarCommitItem];
    
    [self layoutContentView];
    
    [self.contactInfoView reloadCustomerView:self.contactShowDataList WithShowSection:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNavBarCommitItem
{
    UIBarButtonItem *commitItem = [[UIBarButtonItem alloc] initWithTitle:@"提交"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(commitClicked:)];
    self.navigationItem.rightBarButtonItem = commitItem;
    [commitItem release];
}

- (void)commitClicked:(id)sender
{
    
}


- (void)layoutContentView
{
    AddCustomerView  *customerView = [[AddCustomerView alloc] init];
    customerView.backgroundColor = [UIColor whiteColor];
    customerView.delegate = self;
    customerView.initContentY = 0.0f;
    self.contactInfoView = customerView;
    [self.view addSubview:customerView];
    [customerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(self.view).with.offset(-DEVICE_TABBAR_HEIGTH);
    }];
    [customerView release];
    
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

- (void)closeViewResponse
{
    [self.datePicker dismiss];
    [self.itemPicker dismiss];
}

#pragma mark
#pragma mark - 初始化数据
- (void)reloadInitData:(NSDictionary *)sourceInitData
{
    NSMutableArray *contactList = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSString *clientName = [sourceInitData objectForKey:DATA_SHOW_VALUE_COLUM];
    
    NSMutableDictionary *clientNameDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                           @"客户姓名",PLUS_CUSTOMER_TITLE,
                                           CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,
                                           clientName,PLUS_INIT_VALUE,nil];
    [contactList addObject:clientNameDic];
    [clientNameDic release];
    
    //联系方式数据源
    NSDictionary *contactType1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"来访",SOURCE_DATA_NAME_COULUM,
                                  @"0",SOURCE_DATA_ID_COLUM,nil];
    
    NSDictionary *contactType2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"来电",SOURCE_DATA_NAME_COULUM,
                                  @"0",SOURCE_DATA_ID_COLUM,nil];
    
    NSDictionary *contactType3 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"去电",SOURCE_DATA_NAME_COULUM,
                                  @"0",SOURCE_DATA_ID_COLUM,nil];
    
    NSDictionary *contactType4 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"来函",SOURCE_DATA_NAME_COULUM,
                                  @"0",SOURCE_DATA_ID_COLUM,nil];
    
    NSDictionary *contactType5 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"其他类型",SOURCE_DATA_NAME_COULUM,
                                  @"0",SOURCE_DATA_ID_COLUM,nil];
    NSArray *contactTypeSource = [[NSArray alloc] initWithObjects:
                                  contactType1,contactType2,contactType3,contactType4,contactType5, nil];
    [contactType1 release]; [contactType2 release]; [contactType3 release]; [contactType4 release];
    [contactType5 release];
    
    
    NSMutableDictionary *contactTypeDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                           @"联系类型",PLUS_CUSTOMER_TITLE,
                                           CUSTOMER_SELECT_TYPE,PLUS_CUSTOMER_TYPE,
                                           contactTypeSource,PLUS_SELECT_DATA_SOURCE,
                                           [NSNumber numberWithInt:0],PLUS_INIT_VALUE,nil];
    [contactList addObject:contactTypeDic];
    [contactTypeDic release];
    [contactTypeSource release];
    
    //购买意向数据源
    NSDictionary *purpose1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"",SOURCE_DATA_NAME_COULUM,
                              @"0",SOURCE_DATA_ID_COLUM,nil];
    NSDictionary *purpose2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"初步意向",SOURCE_DATA_NAME_COULUM,
                              @"0",SOURCE_DATA_ID_COLUM,nil];
    NSDictionary *purpose3 = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"绝对购买",SOURCE_DATA_NAME_COULUM,
                              @"0",SOURCE_DATA_ID_COLUM,nil];
    NSDictionary *purpose4 = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"强烈意向",SOURCE_DATA_NAME_COULUM,
                              @"0",SOURCE_DATA_ID_COLUM,nil];
    NSDictionary *purpose5 = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"多次来访",SOURCE_DATA_NAME_COULUM,
                              @"0",SOURCE_DATA_ID_COLUM,nil];
    NSArray *purposeSource = [[NSArray alloc] initWithObjects:
                              purpose1,purpose2,purpose3,purpose4,purpose5, nil];
    [purpose1 release];[purpose2 release];[purpose3 release];[purpose4 release];[purpose5 release];
    
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
                                @"0",SOURCE_DATA_ID_COLUM,nil];
    NSDictionary *visitType2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @"夫妻",SOURCE_DATA_NAME_COULUM,
                                @"0",SOURCE_DATA_ID_COLUM,nil];
    NSDictionary *visitType3 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @"与家人",SOURCE_DATA_NAME_COULUM,
                                @"0",SOURCE_DATA_ID_COLUM,nil];
    NSDictionary *visitType4 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @"与朋友",SOURCE_DATA_NAME_COULUM,
                                @"0",SOURCE_DATA_ID_COLUM,nil];
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
                               @"0",SOURCE_DATA_ID_COLUM,nil];
    NSDictionary *visitNum2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"再访",SOURCE_DATA_NAME_COULUM,
                               @"0",SOURCE_DATA_ID_COLUM,nil];
    NSDictionary *visitNum3 = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"其他",SOURCE_DATA_NAME_COULUM,
                               @"0",SOURCE_DATA_ID_COLUM,nil];
    NSArray *visitNumSource = [[NSArray alloc] initWithObjects:visitNum1,visitNum2,visitNum3, nil];
    [visitNum1 release];[visitNum2 release];[visitNum3 release];
    
    NSMutableDictionary *visitNumDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                        @"来访频率",PLUS_CUSTOMER_TITLE,
                                        CUSTOMER_SELECT_TYPE,PLUS_CUSTOMER_TYPE,
                                        visitNumSource,PLUS_SELECT_DATA_SOURCE,
                                        [NSNumber numberWithInt:1],PLUS_INIT_VALUE,nil];
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
    
    
}

#pragma mark
#pragma mark - ItemPickerDelegate
- (void)viewDidDismiss:(ItemPickerView *)itemView
{
    [[[UIApplication sharedApplication].windows firstObject] willRemoveSubview:self.itemPicker];
}

- (void)itemPickerView:(ItemPickerView *)itemPicker selectRow:(NSInteger)row selectData:(NSString *)itemStr
{
    [self.contactInfoView reloadViewDataWithSelectRow:row];
}

#pragma mark
#pragma mark - MyDatePickerViewDelegate
-(void)viewDidDismiss
{
    [[[UIApplication sharedApplication].windows firstObject] willRemoveSubview:self.datePicker];
}
-(void)clickMyDatePickerViewOk:(NSString*)selectedDate
{
    [self.contactInfoView reloadViewDataSelectDate:selectedDate];
}


#pragma mark
#pragma mark - AddCustomerViewDelegate
#pragma mark
#pragma mark - AddCustomerViewDelegate
- (void)customerView:(AddCustomerView *)addCustomerView DidShowItemPickerWithRow:(NSInteger)row WithSource:(NSArray *)sourceList
{
    [self.itemPicker reloadPickerData:sourceList];
    [self.itemPicker selectPickerRow:row];
    [self.itemPicker show];
    [[[UIApplication sharedApplication].windows firstObject] addSubview:self.itemPicker];
    
}

- (void)customerView:(AddCustomerView *)addCustomerView DidShowDate:(UIDatePickerMode)pickerMode
{
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


@end
